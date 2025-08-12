import 'dart:async';
import 'dart:ui' show TimingsCallback, FrameTiming, FramePhase;

import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/instabug_flutter.dart' show CrashReporting;
import 'package:instabug_flutter/src/models/instabug_frame_data.dart';
import 'package:instabug_flutter/src/models/instabug_screen_render_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_widget_binding_observer.dart';
import 'package:meta/meta.dart';

@internal
enum UiTraceType {
  auto,
  custom,
}

@internal
class InstabugScreenRenderManager {
  WidgetsBinding? _widgetsBinding;
  late int _buildTimeMs;
  late int _rasterTimeMs;
  late int _totalTimeMs;
  late TimingsCallback _timingsCallback;
  late InstabugScreenRenderData _screenRenderForAutoUiTrace;
  late InstabugScreenRenderData _screenRenderForCustomUiTrace;
  int _slowFramesTotalDurationMicro = 0;
  int _frozenFramesTotalDurationMicro = 0;
  int? _epochOffset;
  bool _isTimingsListenerAttached = false;
  bool screenRenderEnabled = false;
  bool _isWidgetBindingObserverAdded = false;

  final List<InstabugFrameData> _delayedFrames = [];

  /// Default refresh rate for 60 FPS displays in milliseconds (16.67ms)
  double _slowFrameThresholdMs = 16.67;

  /// Default frozen frame threshold in milliseconds (700ms)
  final _frozenFrameThresholdMs = 700;

  InstabugScreenRenderManager._();

  static InstabugScreenRenderManager _instance =
      InstabugScreenRenderManager._();

  /// Returns the singleton instance of [InstabugScreenRenderManager].
  static InstabugScreenRenderManager get instance => _instance;

  /// Shorthand for [instance]
  static InstabugScreenRenderManager get I => instance;

  /// Logging tag for debugging purposes.
  static const tag = "ScreenRenderManager";

  /// setup function for [InstabugScreenRenderManager]
  @internal
  Future<void> init(WidgetsBinding? widgetBinding) async {
    try {
      // passing WidgetsBinding? (nullable) for flutter versions prior than 3.x
      if (!screenRenderEnabled && widgetBinding != null) {
        _widgetsBinding = widgetBinding;
        _addWidgetBindingObserver();
        await _initStaticValues();
        _initFrameTimings();
        screenRenderEnabled = true;
      }
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// Analyze frame data to detect slow or frozen frames efficiently.
  @visibleForTesting
  void analyzeFrameTiming(FrameTiming frameTiming) {
    _buildTimeMs = frameTiming.buildDuration.inMilliseconds;
    _rasterTimeMs = frameTiming.rasterDuration.inMilliseconds;
    _totalTimeMs = frameTiming.totalSpan.inMilliseconds;

    if (_isTotalTimeLarge) {
      final micros = frameTiming.totalSpan.inMicroseconds;
      _frozenFramesTotalDurationMicro += micros;
      _onDelayedFrameDetected(
        _getMicrosecondsSinceEpoch(
          frameTiming.timestampInMicroseconds(FramePhase.vsyncStart),
        ),
        micros,
      );
      return;
    }

    if (_isUiSlow) {
      final micros = frameTiming.buildDuration.inMicroseconds;
      _slowFramesTotalDurationMicro += micros;
      _onDelayedFrameDetected(
        _getMicrosecondsSinceEpoch(
          frameTiming.timestampInMicroseconds(FramePhase.buildStart),
        ),
        micros,
      );
      return;
    }

    if (_isRasterSlow) {
      final micros = frameTiming.rasterDuration.inMicroseconds;
      _slowFramesTotalDurationMicro += micros;
      _onDelayedFrameDetected(
        _getMicrosecondsSinceEpoch(
          frameTiming.timestampInMicroseconds(FramePhase.rasterStart),
        ),
        micros,
      );
    }
  }

  /// Start collecting screen render data for the running [UITrace].
  /// It ends the running collector when starting a new one of the same type [UiTraceType].
  @internal
  void startScreenRenderCollectorForTraceId(
    int traceId, [
    UiTraceType type = UiTraceType.auto,
  ]) {
    // Return if frameTimingListener not attached
    if (frameCollectorIsNotActive) return;

    if (type == UiTraceType.custom) {
      _screenRenderForCustomUiTrace.traceId = traceId;
    }

    if (type == UiTraceType.auto) {
      _screenRenderForAutoUiTrace.traceId = traceId;
    }
  }

  @internal
  void endScreenRenderCollector([
    UiTraceType type = UiTraceType.auto,
  ]) {
    // Return if frameTimingListener not attached
    if (frameCollectorIsNotActive) return;

    //Save the memory cached data to be sent to native side
    if (_delayedFrames.isNotEmpty) {
      _saveCollectedData();
      _resetCachedFrameData();
    }

    //Sync the captured screen render data of the Custom UI trace if the collector was active
    if (type == UiTraceType.custom && _screenRenderForCustomUiTrace.isActive) {
      _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);
      _screenRenderForCustomUiTrace.clear();
    }

    //Sync the captured screen render data of the Auto UI trace if the collector was active
    if (type == UiTraceType.auto && _screenRenderForAutoUiTrace.isActive) {
      _reportScreenRenderForAutoUiTrace(_screenRenderForAutoUiTrace);
      _screenRenderForAutoUiTrace.clear();
    }
  }

  /// Stop screen render collector and sync the captured data.
  @internal
  void stopScreenRenderCollector() {
    // Return if frameTimingListener not attached
    if (frameCollectorIsNotActive) return;

    if (_delayedFrames.isNotEmpty) {
      _saveCollectedData();
      _resetCachedFrameData();
    }

    // Sync Screen Render data for custom ui trace if exists
    if (_screenRenderForCustomUiTrace.isActive) {
      _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);
      _screenRenderForCustomUiTrace.clear();
    }

    // Sync Screen Render data for auto ui trace if exists
    if (_screenRenderForAutoUiTrace.isActive) {
      _reportScreenRenderForAutoUiTrace(_screenRenderForAutoUiTrace);
      _screenRenderForAutoUiTrace.clear();
    }
  }

  bool get frameCollectorIsNotActive =>
      !screenRenderEnabled || !_isTimingsListenerAttached;

  /// Dispose InstabugScreenRenderManager by removing timings callback and cashed data.
  void dispose() {
    try {
      _resetCachedFrameData();
      _removeFrameTimings();
      _removeWidgetBindingObserver();
      _widgetsBinding = null;
      screenRenderEnabled = false;
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// --------------------------- private methods ---------------------

  bool get _isUiSlow =>
      _buildTimeMs > _slowFrameThresholdMs &&
      _buildTimeMs < _frozenFrameThresholdMs;

  bool get _isRasterSlow =>
      _rasterTimeMs > _slowFrameThresholdMs &&
      _rasterTimeMs < _frozenFrameThresholdMs;

  bool get _isTotalTimeLarge => _totalTimeMs >= _frozenFrameThresholdMs;

  /// Calculate the target time for the frame to be drawn in milliseconds based on the device refresh rate.
  double _targetMsPerFrame(double displayRefreshRate) =>
      1 / displayRefreshRate * 1000;

  /// Get device refresh rate from native side.
  Future<List<double?>> get _getDeviceRefreshRateAndToleranceFromNative =>
      APM.getDeviceRefreshRateAndTolerance();

  /// add new [WidgetsBindingObserver] to track app lifecycle.
  void _addWidgetBindingObserver() {
    if (_widgetsBinding == null) {
      return;
    }
    if (!_isWidgetBindingObserverAdded) {
      _widgetsBinding!.addObserver(InstabugWidgetsBindingObserver.instance);
      _isWidgetBindingObserverAdded = true;
    }
  }

  /// remove [WidgetsBindingObserver] from [WidgetsBinding]
  void _removeWidgetBindingObserver() {
    if (_widgetsBinding == null) {
      return;
    }
    if (_isWidgetBindingObserverAdded) {
      _widgetsBinding!.removeObserver(InstabugWidgetsBindingObserver.instance);
      _isWidgetBindingObserverAdded = false;
    }
  }

  /// Initialize the static variables
  Future<void> _initStaticValues() async {
    _timingsCallback = (timings) {
      // Establish the offset on the first available timing.
      _epochOffset ??= _getEpochOffset(timings.first);

      for (final frameTiming in timings) {
        analyzeFrameTiming(frameTiming);
      }
    };
    _slowFrameThresholdMs = await _getSlowFrameThresholdMs;
    _screenRenderForAutoUiTrace = InstabugScreenRenderData(frameData: []);
    _screenRenderForCustomUiTrace = InstabugScreenRenderData(frameData: []);
  }

  Future<double> get _getSlowFrameThresholdMs async {
    final deviceRefreshRateAndTolerance =
        await _getDeviceRefreshRateAndToleranceFromNative;
    final deviceRefreshRate = deviceRefreshRateAndTolerance[0] ??
        60; // default to 60 FPS if not available
    final toleranceMs = (deviceRefreshRateAndTolerance[1] ?? 10) /
        1000; // convert the tolerance from microseconds to milliseconds
    final targetMsPerFrame = _targetMsPerFrame(deviceRefreshRate);
    return double.parse(
      (targetMsPerFrame + toleranceMs).toStringAsFixed(
        2,
      ),
    ); // round the result to the nearest 2 precision digits
  }

  int _getEpochOffset(FrameTiming firstPatchedFrameTiming) {
    return DateTime.now().microsecondsSinceEpoch -
        firstPatchedFrameTiming.timestampInMicroseconds(FramePhase.vsyncStart);
  }

  /// Add a frame observer by calling [WidgetsBinding.instance.addTimingsCallback]
  void _initFrameTimings() {
    if (_isTimingsListenerAttached) {
      return; // A timings callback is already attached
    }
    _widgetsBinding?.addTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = true;
  }

  /// Remove the running frame observer by calling [_widgetsBinding.removeTimingsCallback]
  void _removeFrameTimings() {
    if (!_isTimingsListenerAttached) return; // No timings callback attached.
    _widgetsBinding?.removeTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = false;
  }

  /// Reset the memory cashed data
  void _resetCachedFrameData() {
    _slowFramesTotalDurationMicro = 0;
    _frozenFramesTotalDurationMicro = 0;
    _delayedFrames.clear();
  }

  /// Save Slow/Frozen Frames data
  void _onDelayedFrameDetected(int startTime, int durationInMicroseconds) {
    _delayedFrames.add(
      InstabugFrameData(
        startTime,
        durationInMicroseconds,
      ),
    );
  }

  /// Ends custom ui trace with the screen render data that has been collected for it.
  /// params:
  ///   [InstabugScreenRenderData] screenRenderData.
  Future<bool> _reportScreenRenderForCustomUiTrace(
    InstabugScreenRenderData screenRenderData,
  ) async {
    try {
      screenRenderData.saveEndTime();
      await APM.endScreenRenderForCustomUiTrace(screenRenderData);
      return true;
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
      return false;
    }
  }

  /// Ends auto ui trace with the screen render data that has been collected for it.
  /// params:
  ///   [InstabugScreenRenderData] screenRenderData.
  Future<bool> _reportScreenRenderForAutoUiTrace(
    InstabugScreenRenderData screenRenderData,
  ) async {
    try {
      // Save the end time for the running ui trace, it's only needed in Android SDK.
      screenRenderData.saveEndTime();
      await APM.endScreenRenderForAutoUiTrace(screenRenderData);

      return true;
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
      return false;
    }
  }

  /// Add the memory cashed data to the objects that will be synced asynchronously to the native side.
  void _saveCollectedData() {
    if (_screenRenderForAutoUiTrace.isActive) {
      _updateAutoUiData();
    }
    if (_screenRenderForCustomUiTrace.isActive) {
      _updateCustomUiData();
    }
  }

  /// Updates the custom UI trace screen render data with the currently collected
  /// frame information and durations.
  ///
  /// This method accumulates the total duration of slow and frozen frames (in microseconds)
  /// for the custom UI trace, and appends the list of delayed frames collected so far
  /// to the trace's frame data. This prepares the custom UI trace data to be reported
  /// or synced with the native side.
  void _updateCustomUiData() {
    _screenRenderForCustomUiTrace.slowFramesTotalDurationMicro +=
        _slowFramesTotalDurationMicro;
    _screenRenderForCustomUiTrace.frozenFramesTotalDurationMicro +=
        _frozenFramesTotalDurationMicro;
    _screenRenderForCustomUiTrace.frameData.addAll(_delayedFrames);
  }

  /// Updates the auto UI trace screen render data with the currently collected
  /// frame information and durations.
  ///
  /// This method accumulates the total duration of slow and frozen frames (in microseconds)
  /// for the auto UI trace, and appends the list of delayed frames collected so far
  /// to the trace's frame data. This prepares the auto UI trace data to be reported
  /// or synced with the native side.
  void _updateAutoUiData() {
    _screenRenderForAutoUiTrace.slowFramesTotalDurationMicro +=
        _slowFramesTotalDurationMicro;
    _screenRenderForAutoUiTrace.frozenFramesTotalDurationMicro +=
        _frozenFramesTotalDurationMicro;
    _screenRenderForAutoUiTrace.frameData.addAll(_delayedFrames);
  }

  /// @nodoc
  void _logExceptionErrorAndStackTrace(Object error, StackTrace stackTrace) {
    //Log the crash details to the user.
    InstabugLogger.I.e(
      '[Error]:$error \n'
      '[StackTrace]: $stackTrace',
      tag: tag,
    );

    //Report nonfatal for the crash details.
    CrashReporting.reportHandledCrash(
      error,
      stackTrace,
    );
  }

  /// @nodoc
  int _getMicrosecondsSinceEpoch(int timeInMicroseconds) =>
      timeInMicroseconds + (_epochOffset ?? 0);

  /// --------------------------- testing helper methods ---------------------

  @visibleForTesting
  InstabugScreenRenderManager.init();

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(InstabugScreenRenderManager instance) {
    _instance = instance;
  }

  @visibleForTesting
  InstabugScreenRenderData get screenRenderForAutoUiTrace =>
      _screenRenderForAutoUiTrace;

  @visibleForTesting
  InstabugScreenRenderData get screenRenderForCustomUiTrace =>
      _screenRenderForCustomUiTrace;

  @visibleForTesting
  void setFrameData(InstabugScreenRenderData data) {
    _delayedFrames.addAll(data.frameData);
    _frozenFramesTotalDurationMicro = data.frozenFramesTotalDurationMicro;
    _slowFramesTotalDurationMicro = data.slowFramesTotalDurationMicro;
  }
}
