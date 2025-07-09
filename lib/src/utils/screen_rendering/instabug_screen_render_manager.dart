import 'dart:async';
import 'dart:developer';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/models/instabug_frame_data.dart';
import 'package:instabug_flutter/src/models/instabug_screen_render_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_widget_binding_observer.dart';
import 'package:meta/meta.dart';

//todo: remove logs

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

  final List<InstabugFrameData> _delayedFrames = [];

  double _deviceRefreshRate = 60;

  /// Default refresh rate for 60 FPS displays
  double _slowFrameThresholdMs = 16.67;

  /// 1/DeviceRefreshRate * 1000
  final _frozenFrameThresholdMs = 700;

  /// Default frozen frame threshold in milliseconds (700ms)
  int _slowFramesTotalDuration = 0;
  int _frozenFramesTotalDuration = 0;
  final int _microsecondsPerMillisecond = 1000;

  bool _isTimingsListenerAttached = false;
  bool screenRenderEnabled = false;

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
        log("$tag: init", name: 'andrew');
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

    _displayFrameTimingDetails(frameTiming);
    if (_isUiSlow) {
      _slowFramesTotalDuration += _buildTime *
          _microsecondsPerMillisecond; //convert from milliseconds to microseconds
    } else if (_isRasterSlow) {
      _slowFramesTotalDuration += _rasterTime *
          _microsecondsPerMillisecond; //convert from milliseconds to microseconds
    }

    if (_isUiFrozen) {
      _frozenFramesTotalDuration += _buildTime * _microsecondsPerMillisecond;
    } else if (_isRasterFrozen) {
      _frozenFramesTotalDuration += _rasterTime * _microsecondsPerMillisecond;
    } else if (_isFrozen) {
      _frozenFramesTotalDuration += _totalTime * _microsecondsPerMillisecond;
    }

    if (_isUiDelayed) {
      _onDelayedFrameDetected(
        frameTiming.timestampInMicroseconds(FramePhase.buildStart),
        frameTiming.buildDuration.inMicroseconds,
      );
    } else if (_isRasterDelayed) {
      _onDelayedFrameDetected(
        frameTiming.timestampInMicroseconds(FramePhase.rasterStart),
        frameTiming.rasterDuration.inMicroseconds,
      );
    } else if (_isTotalTimeLarge) {
      // todo what to do?
      _onDelayedFrameDetected(
        frameTiming.timestampInMicroseconds(FramePhase.vsyncStart),
        frameTiming.totalSpan.inMicroseconds,
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
        log(
          "$tag: startScreenRenderCollectorForTraceId returned",
          name: 'andrew',
        );
        return;
      }
      log(
        "$tag: startScreenRenderCollectorForTraceId $traceId (${type.name})",
        name: 'andrew',
      );

      //Save the memory cached data to be sent to native side
      if (_delayedFrames.isNotEmpty) {
        _saveCollectedData();
        _resetCachedFrameData();
      }

      //Sync the captured screen render data of the Custom UI trace when starting new one
      if (type == UiTraceType.custom) {
        // Report only if the collector was active and has captured data
        if (_screenRenderForCustomUiTrace.isActive &&
            _screenRenderForCustomUiTrace.isNotEmpty) {
          reportScreenRending(
            _screenRenderForCustomUiTrace,
            UiTraceType.custom,
          );
          _screenRenderForCustomUiTrace.clear();
        }
        _screenRenderForCustomUiTrace.traceId = traceId;
      }

      //Sync the captured screen render data of the Auto UI trace when starting new one
      if (type == UiTraceType.auto) {
        // Report only if the collector was active and has captured data
        if (_screenRenderForAutoUiTrace.isActive &&
            _screenRenderForAutoUiTrace.isNotEmpty) {
          reportScreenRending(_screenRenderForAutoUiTrace);
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
      if (_screenRenderForCustomUiTrace.isActive &&
          _screenRenderForCustomUiTrace.isNotEmpty) {
        reportScreenRending(_screenRenderForCustomUiTrace, UiTraceType.custom);
      }

      // Sync Screen Render data for auto ui trace if exists
      if (_screenRenderForAutoUiTrace.isActive &&
          _screenRenderForAutoUiTrace.isNotEmpty) {
        reportScreenRending(_screenRenderForAutoUiTrace);
      }

      // Dispose Screen Render Manager
      dispose();
      log("$tag: stopScreenRenderCollector", name: 'andrew');
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
      _screenRenderForCustomUiTrace.slowFramesTotalDuration +=
          _slowFramesTotalDuration;
      _screenRenderForCustomUiTrace.frozenFramesTotalDuration +=
          _frozenFramesTotalDuration;
      _screenRenderForCustomUiTrace.frameData.addAll(_delayedFrames);

      // Sync the saved screen rendering data
      reportScreenRending(_screenRenderForCustomUiTrace, UiTraceType.custom);
      _screenRenderForCustomUiTrace.clear();
      log("$tag: endCustom", name: 'andrew');
    } catch (error, stackTrace) {
      _logExceptionErrorAndStackTrace(error, stackTrace);
    }
  }

  /// Sync captures screen render data based on their type.
  @visibleForTesting
  Future<void> reportScreenRending(
    InstabugScreenRenderData screenRenderData, [
    UiTraceType type = UiTraceType.auto,
  ]) async {
    if (type == UiTraceType.auto) {
      _reportScreenRenderForAutoUiTrace(screenRenderData);
    } else {
      _reportScreenRenderForCustomUiTrace(screenRenderData);
    }

    log(
      "$tag: Report ${type == UiTraceType.auto ? 'auto' : 'custom'} Data: $screenRenderData",
      name: 'andrew',
    );
  }

  /// Dispose InstabugScreenRenderManager by removing timings callback and cashed data.
  void dispose() {
    _resetCachedFrameData();
    _removeFrameTimings();
    _widgetsBinding = null;
    screenRenderEnabled = false;
    log("$tag: dispose", name: 'andrew');
  }

  /// --------------------------- private methods ---------------------

  bool get _isSlow => _isUiSlow || _isRasterSlow;

  bool get _isUiDelayed => _isUiSlow || _isUiFrozen;

  bool get _isRasterDelayed => _isRasterSlow || _isRasterFrozen;

  bool get _isUiSlow =>
      _buildTime > _slowFrameThresholdMs &&
      _buildTime < _frozenFrameThresholdMs;

  bool get _isRasterSlow =>
      _rasterTime > _slowFrameThresholdMs &&
      _rasterTime < _frozenFrameThresholdMs;

  bool get _isFrozen => _isUiFrozen || _isRasterFrozen || _isTotalTimeLarge;

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
  void _addWidgetBindingObserver() =>
      _widgetsBinding?.addObserver(InstabugWidgetsBindingObserver.instance);

  /// Initialize the static variables
  Future<void> _initStaticValues() async {
    _timingsCallback = (timings) {
      for (final frameTiming in timings) {
        analyzeFrameTiming(frameTiming);
      }
    };
    _deviceRefreshRate = await _getDeviceRefreshRateFromNative;
    _slowFrameThresholdMs = _targetMsPerFrame(_deviceRefreshRate);
    _screenRenderForAutoUiTrace = InstabugScreenRenderData(frameData: []);
    _screenRenderForCustomUiTrace = InstabugScreenRenderData(frameData: []);
    log("$tag: _initStaticValues ", name: 'andrew');
  }

  /// Add a frame observer by calling [WidgetsBinding.instance.addTimingsCallback]
  void _initFrameTimings() {
    if (_isTimingsListenerAttached) {
      return; // A timings callback is already attached
    }
    _widgetsBinding?.addTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = true;
    log("$tag: _initFrameTimings ", name: 'andrew');
  }

  /// Remove the running frame observer by calling [_widgetsBinding.removeTimingsCallback]
  void _removeFrameTimings() {
    if (!_isTimingsListenerAttached) return; // No timings callback attached.
    _widgetsBinding?.removeTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = false;
    log(
      "$tag: _removeFrameTimings ",
      name: 'andrew',
    );
  }

  /// Reset the memory cashed data
  void _resetCachedFrameData() {
    _slowFramesTotalDuration = 0;
    _frozenFramesTotalDuration = 0;
    _delayedFrames.clear();
    log(
      "$tag: _resetCachedFrameData ",
      name: 'andrew',
    );
  }

  /// Save Slow/Frozen Frames data
  void _onDelayedFrameDetected(int startTime, int duration) {
    _delayedFrames.add(InstabugFrameData(startTime, duration));
  }

  //todo: will be removed (is used for debugging)
  void _displayFrameTimingDetails(FrameTiming frameTiming) {
    if (_isSlow) {
      debugPrint(
        '========================= Slow frame detected ⚠️ =========================',
      );
    }
    if (_isFrozen) {
      debugPrint(
        '========================= Frozen frame detected 🚨 =========================',
      );
    }

    if (_isFrozen || _isSlow) {
      debugPrint(
        "{\n\t$frameTiming\n\t"
        "Timestamps(${frameTiming.timestampInMicroseconds(
          FramePhase.buildStart,
        )}, ${frameTiming.timestampInMicroseconds(
          FramePhase.buildFinish,
        )}, ${frameTiming.timestampInMicroseconds(
          FramePhase.rasterStart,
        )}, ${frameTiming.timestampInMicroseconds(
          FramePhase.rasterFinish,
        )}, ${frameTiming.timestampInMicroseconds(
          FramePhase.vsyncStart,
        )}, ${frameTiming.timestampInMicroseconds(
          FramePhase.rasterFinishWallTime,
        )}"
        ")\n}\n",
      );
      debugPrint("Device refresh rate: $_deviceRefreshRate FPS");
      debugPrint(
        "Threshold: $_slowFrameThresholdMs ms\n"
        "===============================================================================",
      );
    }
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
      _screenRenderForAutoUiTrace.slowFramesTotalDuration +=
          _slowFramesTotalDuration;
      _screenRenderForAutoUiTrace.frozenFramesTotalDuration +=
          _frozenFramesTotalDuration;
      _screenRenderForAutoUiTrace.frameData.addAll(_delayedFrames);
    }
    if (_screenRenderForCustomUiTrace.isActive) {
      _screenRenderForCustomUiTrace.slowFramesTotalDuration +=
          _slowFramesTotalDuration;
      _screenRenderForCustomUiTrace.frozenFramesTotalDuration +=
          _frozenFramesTotalDuration;
      _screenRenderForCustomUiTrace.frameData.addAll(_delayedFrames);
    }
    log(
      "$tag: Captured data is saved ",
      name: 'andrew',
    );
  }

  /// @nodoc
  void _logExceptionErrorAndStackTrace(Object error, StackTrace stackTrace) {
    InstabugLogger.I.e(
      '[Error]:$error \n'
      '[StackTrace]: $stackTrace',
      tag: tag,
    );
  }

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
    _frozenFramesTotalDuration = data.frozenFramesTotalDuration;
    _slowFramesTotalDuration = data.slowFramesTotalDuration;
  }
}
