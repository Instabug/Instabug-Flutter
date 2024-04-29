import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/screen_loading/flags_config.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';
import 'package:instabug_flutter/src/utils/screen_loading/ui_trace.dart';
import 'package:meta/meta.dart';

class ScreenLoadingManager {
  ScreenLoadingManager._();

  static ScreenLoadingManager _instance = ScreenLoadingManager._();

  static ScreenLoadingManager get instance => _instance;

  /// Shorthand for [instance]
  static ScreenLoadingManager get I => instance;
  static const tag = "ScreenLoadingManager";
  UiTrace? _currentUiTrace;
  ScreenLoadingTrace? _currentScreenLoadingTrace;

  /// @nodoc
  @internal
  ScreenLoadingTrace? get currentScreenLoadingTrace => _currentScreenLoadingTrace;

  /// @nodoc
  @internal
  final List<ScreenLoadingTrace> prematurelyEndedTraces = [];

  /// @nodoc
  @internal
  UiTrace? get currentUiTrace => _currentUiTrace;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(ScreenLoadingManager instance) {
    _instance = instance;
  }


  /// @nodoc
  @internal
  void resetDidStartScreenLoading() {
    // Allows starting a new screen loading capture trace in the same ui trace (without navigating out and in to the same screen)
    _currentUiTrace?.didStartScreenLoading = false;
    debugPrint('${APM.tag}: Resetting didStartScreenLoading — setting didStartScreenLoading: ${_currentUiTrace?.didStartScreenLoading}');
  }

  /// @nodoc
  @internal
  void resetDidReportScreenLoading() {
    // Allows reporting a new screen loading capture trace in the same ui trace even if one was reported before by resetting the flag which is used for checking.
    _currentUiTrace?.didReportScreenLoading = false;
    debugPrint('${APM.tag}: Resetting didExtendScreenLoading — setting didExtendScreenLoading: ${_currentUiTrace?.didExtendScreenLoading}');
  }

  /// @nodoc
  @internal
  void resetDidExtendScreenLoading() {
    // Allows reporting a new screen loading capture trace in the same ui trace even if one was reported before by resetting the flag which is used for checking.
    _currentUiTrace?.didExtendScreenLoading = false;
    debugPrint('${APM.tag}: Resetting didReportScreenLoading — setting didReportScreenLoading: ${_currentUiTrace?.didReportScreenLoading}');
  }

  @internal
  Future<void> startUiTrace(String screenName) async {
    resetDidStartScreenLoading();
    final isApmEnabled = await FlagsConfig.Apm.isEnabled();
    if (!isApmEnabled) {
      return;
    }
    final microTimeStamp = DateTime.now().microsecondsSinceEpoch;
    final uiTraceId = DateTime.now().millisecondsSinceEpoch;
    APM.startCpUiTrace(screenName, microTimeStamp, uiTraceId);
    _currentUiTrace = UiTrace(screenName, traceId: uiTraceId);
  }

  /// @nodoc
  @internal
  Future<void> startScreenLoadingTrace(
    String screenName, {
    required int startTimeInMicroseconds,
  }) async {
    final isScreenLoadingEnabled =
        await FlagsConfig.ScreenLoading.isEnabled();
    if (!isScreenLoadingEnabled) {
      return;
    }

    final isSameScreen = screenName == _currentUiTrace?.screenName;
    final didStartLoading = _currentUiTrace?.didStartScreenLoading == true;

    if (isSameScreen && !didStartLoading) {
      final trace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: startTimeInMicroseconds,
      );
      debugPrint('${APM.tag} starting screen loading trace — screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds');
      _currentUiTrace?.didStartScreenLoading = true;
      _currentScreenLoadingTrace = trace;
      return;
    }
    debugPrint('${APM.tag} failed to start screen loading trace — screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds');
    debugPrint('${APM.tag} didStartScreenLoading: ${_currentUiTrace?.didStartScreenLoading}, isSameName: ${screenName ==
        _currentUiTrace?.screenName}');
  }

  /// @nodoc
  @internal
  Future<void> reportScreenLoading(ScreenLoadingTrace? trace) async {
    int? duration;
    final isScreenLoadingMonitoringEnabled =
        await FlagsConfig.ScreenLoading.isEnabled();
    if (!isScreenLoadingMonitoringEnabled) {
      return;
    }

    final isSameScreen = trace?.screenName == _currentScreenLoadingTrace?.screenName;
    final isReported = _currentUiTrace?.didReportScreenLoading == true; // Changed to isReported
    final isValidTrace = trace != null;

    // Only report the first screen loading trace with the same name as the active UiTrace
    if (isSameScreen && !isReported && isValidTrace) {
      _currentUiTrace?.didReportScreenLoading = true;

      APM.reportScreenLoadingCP(
        trace?.startTimeInMicroseconds ?? 0,
        duration ?? trace?.duration ?? 0,
        _currentUiTrace?.traceId ?? 0,
      );
      return;
    } else {
      debugPrint(
        '${APM.tag}: failed to report screen loading trace — screenName: ${trace?.screenName}, '
            'startTimeInMicroseconds: ${trace?.startTimeInMicroseconds}, '
            'duration: $duration, '
            'trace.duration: ${trace?.duration ?? 0}',
      );
      debugPrint(
        '${APM.tag} didReportScreenLoading: ${_currentUiTrace?.didReportScreenLoading}, '
            'isSameName: ${trace?.screenName == _currentScreenLoadingTrace?.screenName}',
      );
      _reportScreenLoadingDroppedError(trace!);
    }
    return;
  }

  void _reportScreenLoadingDroppedError(ScreenLoadingTrace trace) {
    final error = DropScreenLoadingError(
      trace,
    );
    debugPrint('${APM.tag}: Droping the screen loading capture — $trace');
    // Todo: !IMP - Check if this should only be logged
    CrashReporting.reportHandledCrash(error, error.stackTrace);
  }

  /// Extends the already ended screen loading adding a stage to it
  Future<void> endScreenLoading() async {
    // end time -> 0
    final isScreenLoadingEnabled = await FlagsConfig.ScreenLoading.isEnabled();
    if (!isScreenLoadingEnabled) {
      return;
    }

    // TODO: endscreen loading only called once
    final didExtendScreenLoading = _currentUiTrace?.didExtendScreenLoading  == true;
    if (didExtendScreenLoading) {
      InstabugLogger.I.e(
        'endScreenLoading has already been called for the current screen visit. Multiple calls to this API are not allowed during a single screen visit, only the first call will be considered.',
        tag: APM.tag,
      );
      return;
    }

    // Handles no active screen loading trace - cannot end
    final didStartScreenLoading = _currentScreenLoadingTrace?.startTimeInMicroseconds != null;
    if (!didStartScreenLoading) {
      InstabugLogger.I.e(
        "endScreenLoading wasn’t called as there is no active screen Loading trace.",
        tag: APM.tag,);
      return;
    }
    final extendedEndTimeInMicroseconds = DateTime.now().microsecondsSinceEpoch;

    final duration = extendedEndTimeInMicroseconds -
        _currentScreenLoadingTrace!.startTimeInMicroseconds;
    // cannot extend as the trace has not ended yet.
    // we report the end/extension as 0 and can be overritten later on.
    var didEndScreenLoadingPrematurely = _currentScreenLoadingTrace?.endTimeInMicroseconds == null;
    if (didEndScreenLoadingPrematurely) {
      _currentScreenLoadingTrace?.endTimeInMicroseconds = 0;
      prematurelyEndedTraces.add(_currentScreenLoadingTrace!);
      InstabugLogger.I.e(
        "endScreenLoading was called too early in the Screen Loading cycle. Please make sure to call the API after the screen is done loading.",
        tag: APM.tag,
      );
      debugPrint('${APM.tag}: endTimeInMicroseconds: ${_currentScreenLoadingTrace?.endTimeInMicroseconds}, '
          'didEndScreenLoadingPrematurely: $didEndScreenLoadingPrematurely');
    }
    debugPrint('${APM.tag}: Ending screen loading capture — duration: $duration');
    _currentScreenLoadingTrace?.endTimeInMicroseconds =
        extendedEndTimeInMicroseconds;
    // Ends screen loading trace
    APM.endScreenLoadingCP(
      extendedEndTimeInMicroseconds,
      _currentUiTrace?.traceId ?? 0,
    );
    _currentUiTrace?.didExtendScreenLoading = true;

    return;
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
