import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/instabug_montonic_clock.dart';
import 'package:instabug_flutter/src/utils/screen_loading/flags_config.dart';
import 'package:instabug_flutter/src/utils/screen_loading/route_matcher.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';
import 'package:instabug_flutter/src/utils/screen_loading/ui_trace.dart';
import 'package:meta/meta.dart';

/// @nodoc
@internal
class ScreenLoadingManager {
  ScreenLoadingManager._();

  /// @nodoc
  @internal
  @visibleForTesting
  ScreenLoadingManager.init();

  static ScreenLoadingManager _instance = ScreenLoadingManager._();

  static ScreenLoadingManager get instance => _instance;

  /// Shorthand for [instance]
  static ScreenLoadingManager get I => instance;
  static const tag = "ScreenLoadingManager";
  UiTrace? currentUiTrace;
  ScreenLoadingTrace? currentScreenLoadingTrace;

  /// @nodoc
  @internal
  final List<ScreenLoadingTrace> prematurelyEndedTraces = [];

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(ScreenLoadingManager instance) {
    _instance = instance;
  }

  /// @nodoc
  @internal
  void resetDidStartScreenLoading() {
    // Allows starting a new screen loading capture trace in the same ui trace (without navigating out and in to the same screen)
    currentUiTrace?.didStartScreenLoading = false;
    InstabugLogger.I.d(
      'Resetting didStartScreenLoading — setting didStartScreenLoading: ${currentUiTrace?.didStartScreenLoading}',
      tag: APM.tag,
    );
  }

  /// @nodoc
  void _logExceptionErrorAndStackTrace(Object error, StackTrace stackTrace) {
    InstabugLogger.I.e(
      '[Error]:$error \n'
      '[StackTrace]: $stackTrace',
      tag: APM.tag,
    );
  }

  /// @nodoc
  Future<bool> _checkInstabugSDKBuilt(String apiName) async {
    // Check if Instabug SDK is Built
    final isInstabugSDKBuilt = await Instabug.isBuilt();
    if (!isInstabugSDKBuilt) {
      InstabugLogger.I.e(
        'Instabug API {$apiName} was called before the SDK is built. To build it, first by following the instructions at this link:\n'
        'https://docs.instabug.com/reference#showing-and-manipulating-the-invocation',
        tag: APM.tag,
      );
    }
    return isInstabugSDKBuilt;
  }

  /// @nodoc
  @internal
  void resetDidReportScreenLoading() {
    // Allows reporting a new screen loading capture trace in the same ui trace even if one was reported before by resetting the flag which is used for checking.
    currentUiTrace?.didReportScreenLoading = false;
    InstabugLogger.I.d(
      'Resetting didExtendScreenLoading — setting didExtendScreenLoading: ${currentUiTrace?.didExtendScreenLoading}',
      tag: APM.tag,
    );
  }

  /// @nodoc
  @internal
  void resetDidExtendScreenLoading() {
    // Allows reporting a new screen loading capture trace in the same ui trace even if one was reported before by resetting the flag which is used for checking.
    currentUiTrace?.didExtendScreenLoading = false;
    InstabugLogger.I.d(
      'Resetting didReportScreenLoading — setting didReportScreenLoading: ${currentUiTrace?.didReportScreenLoading}',
      tag: APM.tag,
    );
  }

  /// The function `sanitizeScreenName` removes leading and trailing slashes from a screen name in Dart.
  ///
  /// Args:
  ///   screenName (String): The `sanitizeScreenName` function is designed to remove a specific character
  /// ('/') from the beginning and end of a given `screenName` string. If the `screenName` is equal to
  /// '/', it will return 'ROOT_PAGE'. Otherwise, it will remove the character from the beginning and end
  /// if
  ///
  /// Returns:
  ///   The `sanitizeScreenName` function returns the sanitized screen name after removing any leading or
  /// trailing '/' characters. If the input `screenName` is equal to '/', it returns 'ROOT_PAGE'.

  @internal
  String sanitizeScreenName(String screenName) {
    const characterToBeRemoved = '/';
    final lastIndex = screenName.length - 1;
    var sanitizedScreenName = screenName;

    if (screenName == characterToBeRemoved) {
      return 'ROOT_PAGE';
    }
    if (screenName[0] == characterToBeRemoved) {
      sanitizedScreenName = sanitizedScreenName.substring(1);
    }
    if (screenName[lastIndex] == characterToBeRemoved) {
      sanitizedScreenName = sanitizedScreenName.substring(0, sanitizedScreenName.length - 1);
    }
    return sanitizedScreenName;
  }

  @internal
  Future<void> startUiTrace(String screenName) async {
    try {
      resetDidStartScreenLoading();

      final isSDKBuilt =
          await _checkInstabugSDKBuilt("APM.InstabugCaptureScreenLoading");
      if (!isSDKBuilt) return;

      // TODO: On Android, FlagsConfig.apm.isEnabled isn't implemented correctly
      // so we skip the isApmEnabled check on Android and only check on iOS.
      // This is a temporary fix until we implement the isEnabled check correctly.
      // We need to fix this in the future.
      final isApmEnabled = await FlagsConfig.apm.isEnabled();
      if (!isApmEnabled && IBGBuildInfo.I.isIOS) {
        InstabugLogger.I.e(
          'APM is disabled, skipping starting the UI trace for screen: $screenName.\n'
          'Please refer to the documentation for how to enable APM on your app: '
          'https://docs.instabug.com/docs/react-native-apm-disabling-enabling',
          tag: APM.tag,
        );
        return;
      }

      final sanitizedScreenName = sanitizeScreenName(screenName);
      final microTimeStamp = IBGDateTime.I.now().microsecondsSinceEpoch;
      final uiTraceId = IBGDateTime.I.now().millisecondsSinceEpoch;
      APM.startCpUiTrace(sanitizedScreenName, microTimeStamp, uiTraceId);
      currentUiTrace = UiTrace(sanitizedScreenName, traceId: uiTraceId);
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// @nodoc
  @internal
  Future<void> startScreenLoadingTrace(ScreenLoadingTrace trace) async {
    try {
      final isSDKBuilt =
          await _checkInstabugSDKBuilt("APM.InstabugCaptureScreenLoading");
      if (!isSDKBuilt) return;

      final isScreenLoadingEnabled =
          await FlagsConfig.screenLoading.isEnabled();
      if (!isScreenLoadingEnabled) {
        if (IBGBuildInfo.I.isIOS) {
          InstabugLogger.I.e(
            'Screen loading monitoring is disabled, skipping starting screen loading monitoring for screen: ${trace.screenName}.\n'
            'Please refer to the documentation for how to enable screen loading monitoring on your app: '
            'https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking'
            "If Screen Loading is enabled but you're still seeing this message, please reach out to support.",
            tag: APM.tag,
          );
        }
        return;
      }

      final isSameScreen = RouteMatcher.I.match(
        routePath: trace.screenName,
        actualPath: currentUiTrace?.screenName,
      );

      final didStartLoading = currentUiTrace?.didStartScreenLoading == true;

      if (isSameScreen && !didStartLoading) {
        InstabugLogger.I.d(
          'starting screen loading trace — screenName: ${trace.screenName}, startTimeInMicroseconds: ${trace.startTimeInMicroseconds}',
          tag: APM.tag,
        );
        currentUiTrace?.didStartScreenLoading = true;
        currentScreenLoadingTrace = trace;
        return;
      }
      InstabugLogger.I.d(
        'failed to start screen loading trace — screenName: ${trace.screenName}, startTimeInMicroseconds: ${trace.startTimeInMicroseconds}',
        tag: APM.tag,
      );
      InstabugLogger.I.d(
        'didStartScreenLoading: $didStartLoading, isSameScreen: $isSameScreen',
        tag: APM.tag,
      );
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// @nodoc
  @internal
  Future<void> reportScreenLoading(ScreenLoadingTrace? trace) async {
    try {
      final isSDKBuilt =
          await _checkInstabugSDKBuilt("APM.InstabugCaptureScreenLoading");
      if (!isSDKBuilt) return;

      int? duration;
      final isScreenLoadingEnabled =
          await FlagsConfig.screenLoading.isEnabled();
      if (!isScreenLoadingEnabled) {
        if (IBGBuildInfo.I.isIOS) {
          InstabugLogger.I.e(
            'Screen loading monitoring is disabled, skipping reporting screen loading time for screen: ${trace?.screenName}.\n'
            'Please refer to the documentation for how to enable screen loading monitoring on your app: '
            'https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking'
            "If Screen Loading is enabled but you're still seeing this message, please reach out to support.",
            tag: APM.tag,
          );
        }
        return;
      }

      final isSameScreen = currentScreenLoadingTrace == trace;

      final isReported = currentUiTrace?.didReportScreenLoading ==
          true; // Changed to isReported
      final isValidTrace = trace != null;

      // Only report the first screen loading trace with the same name as the active UiTrace
      if (isSameScreen && !isReported && isValidTrace) {
        currentUiTrace?.didReportScreenLoading = true;

        APM.reportScreenLoadingCP(
          trace?.startTimeInMicroseconds ?? 0,
          duration ?? trace?.duration ?? 0,
          currentUiTrace?.traceId ?? 0,
        );
        return;
      } else {
        InstabugLogger.I.d(
          'Failed to report screen loading trace — screenName: ${trace?.screenName}, '
          'startTimeInMicroseconds: ${trace?.startTimeInMicroseconds}, '
          'duration: $duration, '
          'trace.duration: ${trace?.duration ?? 0}',
          tag: APM.tag,
        );
        InstabugLogger.I.d(
          'didReportScreenLoading: $isReported, '
          'isSameName: $isSameScreen',
          tag: APM.tag,
        );
        _reportScreenLoadingDroppedError(trace);
      }
      return;
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  void _reportScreenLoadingDroppedError(ScreenLoadingTrace? trace) {
    InstabugLogger.I.e(
      "Screen Loading trace dropped as the trace isn't from the current screen, or another trace was reported before the current one. — $trace",
      tag: APM.tag,
    );
  }

  /// Extends the already ended screen loading adding a stage to it
  Future<void> endScreenLoading() async {
    try {
      final isSDKBuilt = await _checkInstabugSDKBuilt("endScreenLoading");
      if (!isSDKBuilt) return;

      final isScreenLoadingEnabled =
          await FlagsConfig.screenLoading.isEnabled();
      if (!isScreenLoadingEnabled) {
        if (IBGBuildInfo.I.isIOS) {
          InstabugLogger.I.e(
            'Screen loading monitoring is disabled, skipping ending screen loading monitoring with APM.endScreenLoading().\n'
            'Please refer to the documentation for how to enable screen loading monitoring in your app: '
            'https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking'
            "If Screen Loading is enabled but you're still seeing this message, please reach out to support.",
            tag: APM.tag,
          );
        }
        return;
      }

      final didExtendScreenLoading =
          currentUiTrace?.didExtendScreenLoading == true;
      if (didExtendScreenLoading) {
        InstabugLogger.I.e(
          'endScreenLoading has already been called for the current screen visit. Multiple calls to this API are not allowed during a single screen visit, only the first call will be considered.',
          tag: APM.tag,
        );
        return;
      }

      // Handles no active screen loading trace - cannot end
      final didStartScreenLoading =
          currentScreenLoadingTrace?.startTimeInMicroseconds != null;
      if (!didStartScreenLoading) {
        InstabugLogger.I.e(
          "endScreenLoading wasn’t called as there is no active screen Loading trace.",
          tag: APM.tag,
        );
        return;
      }

      final extendedMonotonicEndTimeInMicroseconds =
          InstabugMonotonicClock.I.now;

      var duration = extendedMonotonicEndTimeInMicroseconds -
          currentScreenLoadingTrace!.startMonotonicTimeInMicroseconds;

      var extendedEndTimeInMicroseconds =
          currentScreenLoadingTrace!.startTimeInMicroseconds + duration;

      // cannot extend as the trace has not ended yet.
      // we report the extension timestamp as 0 and can be override later on.
      final didEndScreenLoadingPrematurely =
          currentScreenLoadingTrace?.endTimeInMicroseconds == null;
      if (didEndScreenLoadingPrematurely) {
        extendedEndTimeInMicroseconds = 0;
        duration = 0;

        InstabugLogger.I.e(
          "endScreenLoading was called too early in the Screen Loading cycle. Please make sure to call the API after the screen is done loading.",
          tag: APM.tag,
        );
      }
      InstabugLogger.I.d(
        'endTimeInMicroseconds: ${currentScreenLoadingTrace?.endTimeInMicroseconds}, '
        'didEndScreenLoadingPrematurely: $didEndScreenLoadingPrematurely, extendedEndTimeInMicroseconds: $extendedEndTimeInMicroseconds.',
        tag: APM.tag,
      );
      InstabugLogger.I.d(
        'Ending screen loading capture — duration: $extendedEndTimeInMicroseconds',
        tag: APM.tag,
      );

      // Ends screen loading trace
      APM.endScreenLoadingCP(
        extendedEndTimeInMicroseconds,
        currentUiTrace?.traceId ?? 0,
      );
      currentUiTrace?.didExtendScreenLoading = true;

      return;
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }
}

class DropScreenLoadingError extends Error {
  final ScreenLoadingTrace trace;

  DropScreenLoadingError(this.trace);

  @override
  String toString() {
    return 'DropScreenLoadingError: $trace';
  }
}
