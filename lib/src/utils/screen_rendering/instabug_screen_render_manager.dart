import 'dart:developer';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/models/InstabugFrameData.dart';
import 'package:instabug_flutter/src/models/InstabugScreenRenderData.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_widget_binding_observer.dart';
import 'package:meta/meta.dart';

//todo: remove logs
extension on int {
  int get inMicro => this * 1000;
}

@internal
enum UiTraceType {
  auto,
  custom,
}

@internal
class InstabugScreenRenderManager {
  late final WidgetsBinding _widgetsBinding;
  late int _buildTime;
  late int _rasterTime;
  late int _totalTime;
  late TimingsCallback _timingsCallback;
  late InstabugScreenRenderData _screenRenderForAutoUiTrace;
  late InstabugScreenRenderData _screenRenderForCustomUiTrace;

  final List<InstabugFrameData> _delayedFrames = [];

  double _deviceRefreshRate = 60;
  double _slowFrameThresholdMs = 16.67;
  final _frozenFrameThresholdMs = 700;
  int _slowFramesTotalDuration = 0;
  int _frozenFramesTotalDuration = 0;

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
  void init(WidgetsBinding widgetBinding, [double? refreshRate]) {
    if (!_isTimingsListenerAttached) {
      _widgetsBinding = widgetBinding;
      _addWidgetBindingObserver();
      _initStaticValues(refreshRate);
      _initFrameTimings();
      screenRenderEnabled = true;
    }
  }

  /// nodoc

  void _addWidgetBindingObserver() =>
      _widgetsBinding.addObserver(InstabugWidgetsBindingObserver.instance);

  /// analyze frame data in order to detect slow/frozen frame.
  @visibleForTesting
  void analyzeFrameTiming(FrameTiming frameTiming) {
    _buildTime = frameTiming.buildDuration.inMilliseconds;
    _rasterTime = frameTiming.rasterDuration.inMilliseconds;
    _totalTime = frameTiming.totalSpan.inMilliseconds;

    _displayFrameTimingDetails(frameTiming);
    if (_isUiSlow) {
      _slowFramesTotalDuration +=
          _buildTime.inMicro; //convert from milliseconds to microseconds
    } else if (_isRasterSlow) {
      _slowFramesTotalDuration +=
          _rasterTime.inMicro; //convert from milliseconds to microseconds
    }

    if (_isUiFrozen) {
      _frozenFramesTotalDuration += _buildTime.inMicro;
    } else if (_isRasterFrozen) {
      _frozenFramesTotalDuration += _rasterTime.inMicro;
    } else if (_isFrozen) {
      _frozenFramesTotalDuration += _totalTime.inMicro;
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

  /// Check if getting from native would return different value.
  /// Platforms may limit what information is available to the application with regard to secondary displays and/or displays that do not have an active application window.
  /// Presently, on Android and Web this collection will only contain the display that the current window is on.
  /// On iOS, it will only contains the main display on the phone or tablet.
  /// On Desktop, it will contain only a main display with a valid refresh rate but invalid size and device pixel ratio values.
  //todo: will be compared with value from native side after it's implemented.
  double get _getDeviceRefreshRate =>
      _widgetsBinding.platformDispatcher.displays.first.refreshRate;

  /// Get device refresh rate from native side.
  //todo: will be compared with value from native side after it's implemented.
  // ignore: unused_element
  Future<double> get _getDeviceRefreshRateFromNative =>
      APM.getDeviceRefreshRate();

  /// Initialize the static variables
  void _initStaticValues(double? refreshRate) {
    _timingsCallback = (timings) {
      for (final frameTiming in timings) {
        analyzeFrameTiming(frameTiming);
      }
    };
    _deviceRefreshRate = refreshRate ?? _getDeviceRefreshRate;
    _slowFrameThresholdMs = _targetMsPerFrame(_deviceRefreshRate);
    _screenRenderForAutoUiTrace = InstabugScreenRenderData(frameData: []);
    _screenRenderForCustomUiTrace = InstabugScreenRenderData(frameData: []);
  }

  /// Add a frame observer by calling [WidgetsBinding.instance.addTimingsCallback]

  void _initFrameTimings() {
    _widgetsBinding.addTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = true;
  }

  /// Remove the running frame observer by calling [_widgetsBinding.removeTimingsCallback]
  void _removeFrameTimings() {
    _widgetsBinding.removeTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = false;
  }

  /// Start collecting screen render data for the running [UITrace].
  /// It ends the running collector when starting a new one of the same type [UiTraceType].
  @internal
  void startScreenRenderCollectorForTraceId(
    int traceId, [
    UiTraceType type = UiTraceType.auto,
  ]) {
    // Attach frameTimingListener if not attached
    if (!_isTimingsListenerAttached) {
      _initFrameTimings();
    }

    //Save the memory cached data to be sent to native side
    if (_delayedFrames.isNotEmpty) {
      _saveCollectedData();
      _resetCachedFrameData();
    }

    //Sync the captured screen render data of the Custom UI trace when starting new one
    if (type == UiTraceType.custom) {
      if (_screenRenderForCustomUiTrace.isNotEmpty) {
        reportScreenRending(_screenRenderForCustomUiTrace, UiTraceType.custom);
        _screenRenderForCustomUiTrace.clear();
      }
      _screenRenderForCustomUiTrace.traceId = traceId;
    }

    //Sync the captured screen render data of the Auto UI trace when starting new one
    if (type == UiTraceType.auto) {
      if (_screenRenderForAutoUiTrace.isNotEmpty) {
        reportScreenRending(_screenRenderForAutoUiTrace);
        _screenRenderForAutoUiTrace.clear();
      }
      _screenRenderForAutoUiTrace.traceId = traceId;
    }
  }

  /// Stop screen render collector and sync the captured data.
  @internal
  void stopScreenRenderCollector() {
    _saveCollectedData();

    if (_screenRenderForCustomUiTrace.isNotEmpty) {
      reportScreenRending(_screenRenderForCustomUiTrace, UiTraceType.custom);
    }
    if (_screenRenderForAutoUiTrace.isNotEmpty) {
      reportScreenRending(_screenRenderForAutoUiTrace);
    }

    _removeFrameTimings();

    _resetCachedFrameData();
  }

  /// Sync the capture screen render data of the custom UI trace without stopping the collector.
  @internal
  void endScreenRenderCollectorForCustomUiTrace() {
    if (_screenRenderForCustomUiTrace.isNotEmpty) {
      // Save the captured screen rendering data to be synced
      _screenRenderForCustomUiTrace.slowFramesTotalDuration +=
          _slowFramesTotalDuration;
      _screenRenderForCustomUiTrace.frozenFramesTotalDuration +=
          _frozenFramesTotalDuration;
      _screenRenderForCustomUiTrace.frameData.addAll(_delayedFrames);

      // Sync the saved screen rendering data
      reportScreenRending(_screenRenderForCustomUiTrace, UiTraceType.custom);
      _screenRenderForCustomUiTrace.clear();
    }
  }

  /// Reset the memory cashed data
  void _resetCachedFrameData() {
    _slowFramesTotalDuration = 0;
    _frozenFramesTotalDuration = 0;
    _delayedFrames.clear();
  }

  /// Save Slow/Frozen Frames data
  void _onDelayedFrameDetected(int startTime, int duration) {
    _delayedFrames.add(InstabugFrameData(startTime, duration));
  }

  //todo: will be removed
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
      debugPrint("{\n\t$frameTiming\n\t"
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
          ")\n}\n");
      debugPrint("Device refresh rate: $_deviceRefreshRate FPS");
      debugPrint("Threshold: $_slowFrameThresholdMs ms\n"
          "===============================================================================");
    }
  }

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
      "Reported Data (${type == UiTraceType.auto ? 'auto' : 'custom'}): $screenRenderData",
      name: tag,
    );
  }

  Future<void> _reportScreenRenderForCustomUiTrace(
    InstabugScreenRenderData screenRenderData,
  ) async {
    //todo: Will be implemented in next sprint
  }

  Future<void> _reportScreenRenderForAutoUiTrace(
    InstabugScreenRenderData screenRenderData,
  ) async {
    //todo: Will be implemented in next sprint
  }

  /// Add the memory cashed data to the objects that will be synced asynchronously to the native side.
  void _saveCollectedData() {
    if (_screenRenderForAutoUiTrace.isNotEmpty) {
      _screenRenderForAutoUiTrace.slowFramesTotalDuration +=
          _slowFramesTotalDuration;
      _screenRenderForAutoUiTrace.frozenFramesTotalDuration +=
          _frozenFramesTotalDuration;
      _screenRenderForAutoUiTrace.frameData.addAll(_delayedFrames);
    }
    if (_screenRenderForCustomUiTrace.isNotEmpty) {
      _screenRenderForCustomUiTrace.slowFramesTotalDuration +=
          _slowFramesTotalDuration;
      _screenRenderForCustomUiTrace.frozenFramesTotalDuration +=
          _frozenFramesTotalDuration;
      _screenRenderForCustomUiTrace.frameData.addAll(_delayedFrames);
    }
  }

  /// --------------------------- testing helper functions ---------------------

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
