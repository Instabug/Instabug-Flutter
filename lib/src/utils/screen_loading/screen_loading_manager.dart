import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/screen_loading/flags_config.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';
import 'package:instabug_flutter/src/utils/screen_loading/ui_trace.dart';

class ScreenLoadingManager {
  ScreenLoadingManager._();

  static ScreenLoadingManager _instance = ScreenLoadingManager._();

  static ScreenLoadingManager get instance => _instance;

  /// Shorthand for [instance]
  static ScreenLoadingManager get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(ScreenLoadingManager instance) {
    _instance = instance;
  }

  static const tag = "ScreenLoadingManager";
  late UiTrace _currentUiTrace;
  ScreenLoadingTrace? _currentScreenLoadingTrace;

  Future<void> startUiTrace(String screenName) async {
    final isApmEnabled = await FlagsConfig.Apm.isEnabled();
    if (!isApmEnabled) {
      log("Unable to start Ui Trace, as ${FlagsConfig.Apm.name} feature is disabled.",
          name: APM.tag);
      return;
    }
    final microTimeStamp = DateTime.now().microsecondsSinceEpoch;
    final uiTraceId = DateTime.now().millisecondsSinceEpoch;
    APM.startCpUiTrace(screenName, microTimeStamp, uiTraceId);
    _currentUiTrace = UiTrace(screenName, traceId: uiTraceId);
  }

  Future<bool> startScreenLoadingTrace(
    String screenName, {
    required int startTimeInMicroseconds,
  }) async {
    final isScreenLoadingMonitoringEnabled =
        await FlagsConfig.ScreenLoading.isEnabled();
    if (!isScreenLoadingMonitoringEnabled) {
      log("Unable to start Screen loading capture, as ${FlagsConfig.ScreenLoading.name} feature is disabled.",
          name: APM.tag);
      return false;
    }
    // only accepts the first widget with the same name
    if (screenName == _currentUiTrace.screenName &&
        _currentScreenLoadingTrace != null) {
      final trace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: startTimeInMicroseconds,
      );
      debugPrint('${APM.tag} starting screen loading trace — screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds');
      _currentUiTrace?.didStartScreenLoading = true;
      _currentScreenLoadingTrace = trace;
      return true;
    }
    debugPrint('${APM.tag} failed to start screen loading trace — screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds');
    debugPrint('${APM.tag} didStartScreenLoading: ${_currentUiTrace?.didStartScreenLoading}, isSameName: ${screenName ==
        _currentUiTrace?.screenName}');
    return false;
  }

  Future<bool> reportScreenLoading(
    ScreenLoadingTrace? trace, {
    required int endTimeInMicroseconds,
  }) async {
    int? duration;
    final isScreenLoadingMonitoringEnabled =
        await FlagsConfig.ScreenLoading.isEnabled();
    if (!isScreenLoadingMonitoringEnabled) {
      log('Unable to report Screen loading capture, as ${FlagsConfig.ScreenLoading.name} feature is disabled.',
          name: APM.tag);
    }

    // Handles if [endScreenLoading] was called prematurely
    // As the endScreenLoading only extends the current screen loading trace
    if (trace?.endTimeInMicroseconds == 0) {
      log(
        'Ending screen loading prematurely, as Screen loading was ended before full capture.',
        name: APM.tag,
      );
      duration = 0;
    }

    if (trace?.screenName == _currentScreenLoadingTrace?.screenName &&
        _currentUiTrace.isScreenLoadingTraceReported == false) {
      _currentUiTrace.isScreenLoadingTraceReported = true;

      APM.reportScreenLoading(
        trace!.startTimeInMicroseconds,
        duration ?? trace.duration!,
        _currentUiTrace.traceId,
      );
      return true;
    } else {
      debugPrint(
        '${APM.tag} failed to report screen loading trace — screenName: ${trace?.screenName}, '
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
    return false;
  }

  void _reportScreenLoadingDroppedError(ScreenLoadingTrace trace) {
    final error = DropScreenLoadingError(
      trace,
    );
    // Todo: !IMP - Check if this should only be logged
    CrashReporting.reportHandledCrash(error, error.stackTrace);
  }

  /// Extends the already ended screen loading adding a stage to it
  Future<void> endScreenLoading() async {
    // end time -> 0
    final isScreenLoadingEnabled = await FlagsConfig.ScreenLoading.isEnabled();
    if (!isScreenLoadingEnabled) {
      log(
        "Unable to extend Screen loading capture, as ${FlagsConfig.ScreenLoading.name} feature is disabled.",
        name: APM.tag,
      );
    }

    // Handles no active screen loading trace - cannot end
    if (_currentScreenLoadingTrace?.startTimeInMicroseconds == null) {
      log("Unable to end Screen loading capture, as there is no active Screen loading capture.");
      return;
    }
    // cannot extend as the trace has not ended yet.
    // we set the end to 0 and leave it to be reported.
    if (_currentScreenLoadingTrace?.endTimeInMicroseconds == null) {
      _currentScreenLoadingTrace?.endTimeInMicroseconds = 0;
      log(
        "Ending screen loading capture prematurely, setting end time to 0",
        name: APM.tag,
      );
    }
    final extendedEndTimeInMicroseconds = DateTime.now().microsecondsSinceEpoch;
    final duration = extendedEndTimeInMicroseconds -
        _currentScreenLoadingTrace!.startTimeInMicroseconds;
    _currentScreenLoadingTrace?.duration = duration;
    log('Ending screen loading capture — duration: $duration');
    _currentScreenLoadingTrace?.endTimeInMicroseconds =
        extendedEndTimeInMicroseconds;
    // Ends screen loading trace
    APM.endScreenLoading(
      _currentScreenLoadingTrace!.endTimeInMicroseconds!,
      _currentUiTrace.traceId,
    );
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
