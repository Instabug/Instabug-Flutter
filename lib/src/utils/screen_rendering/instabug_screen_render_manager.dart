import 'dart:async';
import 'dart:ui';

import 'package:flutter/widgets.dart';
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
  late int _buildTime;
  late int _rasterTime;
  late int _totalTime;
  late TimingsCallback _timingsCallback;
  late InstabugScreenRenderData _screenRenderForAutoUiTrace;
  late InstabugScreenRenderData _screenRenderForCustomUiTrace;
  int _slowFramesTotalDurationMs = 0;
  int _frozenFramesTotalDurationMs = 0;
  int? _epochOffset;
  bool _isTimingsListenerAttached = false;
  bool screenRenderEnabled = false;
  bool _isWidgetBindingObserverAdded = false;

  final List<InstabugFrameData> _delayedFrames = [];

  /// 1 / DeviceRefreshRate * 1000
  double _deviceRefreshRate = 60;

  /// Default refresh rate for 60 FPS displays in milliseconds (16.67ms)
  double _slowFrameThresholdMs = 16.67;

  /// Default frozen frame threshold in milliseconds (700ms)
  final _frozenFrameThresholdMs = 700;

  final _microsecondsPerMillisecond = 1000;

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

  /// analyze frame data in order to detect slow/frozen frame.
  @visibleForTesting
  void analyzeFrameTiming(FrameTiming frameTiming) {
    _buildTime = frameTiming.buildDuration.inMilliseconds;
    _rasterTime = frameTiming.rasterDuration.inMilliseconds;
    _totalTime = frameTiming.totalSpan.inMilliseconds;

    if (_isUiFrozen) {
      _frozenFramesTotalDurationMs += _buildTime;
    } else if (_isRasterFrozen) {
      _frozenFramesTotalDurationMs += _rasterTime;
    } else if (_isTotalTimeLarge) {
      _frozenFramesTotalDurationMs += _totalTime;
    }
    if (_isUiSlow) {
      _slowFramesTotalDurationMs += _buildTime;
    } else if (_isRasterSlow) {
      _slowFramesTotalDurationMs += _rasterTime;
    }

    if (_isUiDelayed) {
      _onDelayedFrameDetected(
        _getMicrosecondsSinceEpoch(
          frameTiming.timestampInMicroseconds(FramePhase.buildStart),
        ),
        _buildTime,
      );
    } else if (_isRasterDelayed) {
      _onDelayedFrameDetected(
        _getMicrosecondsSinceEpoch(
          frameTiming.timestampInMicroseconds(FramePhase.rasterStart),
        ),
        _rasterTime,
      );
    } else if (_isTotalTimeLarge) {
      _onDelayedFrameDetected(
        _getMicrosecondsSinceEpoch(
          frameTiming.timestampInMicroseconds(FramePhase.vsyncStart),
        ),
        _totalTime,
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
    try {
      // Return if frameTimingListener not attached
      if (!screenRenderEnabled || !_isTimingsListenerAttached) {
        return;
      }

      //Save the memory cached data to be sent to native side
      if (_delayedFrames.isNotEmpty) {
        _saveCollectedData();
        _resetCachedFrameData();
      }

      //Sync the captured screen render data of the Custom UI trace when starting new one
      if (type == UiTraceType.custom) {
        // Report only if the collector was active
        if (_screenRenderForCustomUiTrace.isActive) {
          _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);
          _screenRenderForCustomUiTrace.clear();
        }
        _screenRenderForCustomUiTrace.traceId = traceId;
      }

      //Sync the captured screen render data of the Auto UI trace when starting new one
      if (type == UiTraceType.auto) {
        // Report only if the collector was active
        if (_screenRenderForAutoUiTrace.isActive) {
          _reportScreenRenderForAutoUiTrace(_screenRenderForAutoUiTrace);
          _screenRenderForAutoUiTrace.clear();
        }
        _screenRenderForAutoUiTrace.traceId = traceId;
      }
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// Stop screen render collector and sync the captured data.
  @internal
  void stopScreenRenderCollector() {
    try {
      if (_delayedFrames.isNotEmpty) {
        _saveCollectedData();
      }

      // Sync Screen Render data for custom ui trace if exists
      if (_screenRenderForCustomUiTrace.isActive) {
        _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);
      }

      // Sync Screen Render data for auto ui trace if exists
      if (_screenRenderForAutoUiTrace.isActive) {
        _reportScreenRenderForAutoUiTrace(_screenRenderForAutoUiTrace);
      }
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// Sync the capture screen render data of the custom UI trace without stopping the collector.
  @internal
  void endScreenRenderCollectorForCustomUiTrace() {
    try {
      if (!_screenRenderForCustomUiTrace.isActive) {
        return;
      }

      // Save the captured screen rendering data to be synced
      _updateCustomUiData();

      // Sync the saved screen rendering data
      _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);

      _screenRenderForCustomUiTrace.clear();
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// Dispose InstabugScreenRenderManager by removing timings callback and cashed data.
  void dispose() {
    _resetCachedFrameData();
    _removeFrameTimings();
    _removeWidgetBindingObserver();
    _widgetsBinding = null;
    screenRenderEnabled = false;
  }

  /// --------------------------- private methods ---------------------

  bool get _isUiDelayed => _isUiSlow || _isUiFrozen;

  bool get _isRasterDelayed => _isRasterSlow || _isRasterFrozen;

  bool get _isUiSlow =>
      _buildTime > _slowFrameThresholdMs &&
      _buildTime < _frozenFrameThresholdMs;

  bool get _isRasterSlow =>
      _rasterTime > _slowFrameThresholdMs &&
      _rasterTime < _frozenFrameThresholdMs;

  bool get _isTotalTimeLarge => _totalTime >= _frozenFrameThresholdMs;

  bool get _isUiFrozen => _buildTime >= _frozenFrameThresholdMs;

  bool get _isRasterFrozen => _rasterTime >= _frozenFrameThresholdMs;

  /// Calculate the target time for the frame to be drawn in milliseconds based on the device refresh rate.
  double _targetMsPerFrame(double displayRefreshRate) =>
      1 / displayRefreshRate * 1000;

  /// Get device refresh rate from native side.
  Future<double> get _getDeviceRefreshRateFromNative =>
      APM.getDeviceRefreshRate();

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
    _deviceRefreshRate = await _getDeviceRefreshRateFromNative;
    _slowFrameThresholdMs = _targetMsPerFrame(_deviceRefreshRate);
    _screenRenderForAutoUiTrace = InstabugScreenRenderData(frameData: []);
    _screenRenderForCustomUiTrace = InstabugScreenRenderData(frameData: []);
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
    _slowFramesTotalDurationMs = 0;
    _frozenFramesTotalDurationMs = 0;
    _delayedFrames.clear();
  }

  /// Save Slow/Frozen Frames data
  void _onDelayedFrameDetected(int startTime, int durationInMilliseconds) {
    _delayedFrames.add(
      InstabugFrameData(
        startTime,
        durationInMilliseconds *
            _microsecondsPerMillisecond, // Convert duration from milliseconds to microSeconds
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
        _slowFramesTotalDurationMs * _microsecondsPerMillisecond;
    _screenRenderForCustomUiTrace.frozenFramesTotalDurationMicro +=
        _frozenFramesTotalDurationMs * _microsecondsPerMillisecond;
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
        _slowFramesTotalDurationMs * _microsecondsPerMillisecond;
    _screenRenderForAutoUiTrace.frozenFramesTotalDurationMicro +=
        _frozenFramesTotalDurationMs * _microsecondsPerMillisecond;
    _screenRenderForAutoUiTrace.frameData.addAll(_delayedFrames);
  }

  /// @nodoc
  void _logExceptionErrorAndStackTrace(Object error, StackTrace stackTrace) {
    InstabugLogger.I.e(
      '[Error]:$error \n'
      '[StackTrace]: $stackTrace',
      tag: tag,
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
    _frozenFramesTotalDurationMs =
        data.frozenFramesTotalDurationMicro ~/ _microsecondsPerMillisecond;
    _slowFramesTotalDurationMs =
        data.slowFramesTotalDurationMicro ~/ _microsecondsPerMillisecond;
  }
}
