import 'dart:developer';
import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/models/InstabugFrameData.dart';
import 'package:instabug_flutter/src/models/InstabugScreenRenderData.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_widget_binding_observer.dart';
import 'package:instabug_flutter/src/utils/ui_trace/flags_config.dart';
import 'package:meta/meta.dart';

@internal
enum UiTraceType {
  auto,
  custom,
}

@internal
class InstabugScreenRenderManager {
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

  InstabugScreenRenderManager._();

  static final InstabugScreenRenderManager _instance =
      InstabugScreenRenderManager._();

  /// Returns the singleton instance of [InstabugScreenRenderManager].
  static InstabugScreenRenderManager get instance => _instance;

  /// Shorthand for [instance]
  static InstabugScreenRenderManager get I => instance;

  /// Logging tag for debugging purposes.
  static const tag = "ScreenRenderManager";

  /// A named constructor used for testing purposes

  @visibleForTesting
  InstabugScreenRenderManager.init();

  /// setup function for [InstabugScreenRenderManager]
  Future<void> init() async {
    if (await FlagsConfig.screenRendering.isEnabled() &&
        (!_isTimingsListenerAttached)) {
      log("Andrew InstabugScreenRenderManager has been attached");
      _checkForWidgetBinding();
      WidgetsBinding.instance.addObserver(InstabugWidgetsBindingObserver());
      _initStaticValues();
      _initFrameTimings();
    }
  }

  /// analyze frame data in order to detect slow/frozen frame.
  void _analyzeFrameTiming(FrameTiming frameTiming) {
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
      _buildTime < _frozenFrameThresholdMs;

  bool get _isFrozen => _isUiFrozen || _isRasterFrozen || _isTotalTimeLarge;

  bool get _isTotalTimeLarge => _totalTime >= _frozenFrameThresholdMs;

  bool get _isUiFrozen => _buildTime >= _frozenFrameThresholdMs;

  bool get _isRasterFrozen => _rasterTime >= _frozenFrameThresholdMs;

  double _targetMsPerFrame(double displayRefreshRate) =>
      1 / displayRefreshRate * 1000;

  /// Safe garde check for  [WidgetsBinding.instance] initialization
  void _checkForWidgetBinding() {
    try {
      WidgetsBinding.instance;
    } catch (_) {
      WidgetsFlutterBinding.ensureInitialized();
    }
  }

  /// Checks if the Instabug SDK is built before calling API methods.
  Future<bool> _checkInstabugSDKBuilt(String apiName) async {
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

  /// check if getting from native would return different value.
  /// Platforms may limit what information is available to the application with regard to secondary displays and/or displays that do not have an active application window.
  /// Presently, on Android and Web this collection will only contain the display that the current window is on.
  /// On iOS, it will only contains the main display on the phone or tablet.
  /// On Desktop, it will contain only a main display with a valid refresh rate but invalid size and device pixel ratio values.
  double get _getDeviceRefreshRate =>
      WidgetsBinding.instance.platformDispatcher.displays.last.refreshRate;

  /// get device refresh rate from native side.
  Future<double> get _getDeviceRefreshRateFromNative =>
      APM.getDeviceRefreshRate();

  /// initialize the static variables
  void _initStaticValues() {
    _timingsCallback = (timings) {
      for (final frameTiming in timings) {
        _analyzeFrameTiming(frameTiming);
      }
    };
    _deviceRefreshRate = _getDeviceRefreshRate;
    _slowFrameThresholdMs = _targetMsPerFrame(_getDeviceRefreshRate);
    _screenRenderForAutoUiTrace = InstabugScreenRenderData(frameData: []);
    _screenRenderForCustomUiTrace = InstabugScreenRenderData(frameData: []);
  }

  /// add a frame observer by calling [WidgetsBinding.instance.addTimingsCallback]
  void _initFrameTimings() {
    WidgetsBinding.instance.addTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = true;
  }

  /// remove the running frame observer by calling [WidgetsBinding.instance.removeTimingsCallback]
  void _removeFrameTimings() {
    WidgetsBinding.instance.removeTimingsCallback(_timingsCallback);
    _isTimingsListenerAttached = false;
  }

  void startScreenRenderCollectorForTraceId(
    int traceId, [
    UiTraceType type = UiTraceType.auto,
  ]) {
    if (!_isTimingsListenerAttached) {
      _initFrameTimings();
    }

    if (_delayedFrames.isNotEmpty) {
      _saveCollectedData();
      _resetCachedFrameData();
    }
    if (type == UiTraceType.custom) {
      if (_screenRenderForCustomUiTrace.isNotEmpty) {
        _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);
        _screenRenderForCustomUiTrace.clear();
      }
      _screenRenderForCustomUiTrace.traceId = traceId;
    }
    if (type == UiTraceType.auto) {
      if (_screenRenderForAutoUiTrace.isNotEmpty) {
        _reportScreenRenderForAutoUiTrace(_screenRenderForAutoUiTrace);
        _screenRenderForAutoUiTrace.clear();
      }
      _screenRenderForAutoUiTrace.traceId = traceId;
    }
  }

  void stopScreenRenderCollector([UiTraceType? type]) {
    _saveCollectedData();
    if (_screenRenderForCustomUiTrace.isNotEmpty) {
      _reportScreenRenderForCustomUiTrace(_screenRenderForCustomUiTrace);
    }
    if (_screenRenderForAutoUiTrace.isNotEmpty) {
      _reportScreenRenderForAutoUiTrace(_screenRenderForAutoUiTrace);
    }

    _removeFrameTimings();
    _resetCachedFrameData();
  }

  void _resetCachedFrameData() {
    _slowFramesTotalDuration = 0;
    _frozenFramesTotalDuration = 0;
    _delayedFrames.clear();
  }

  /// Save Slow/Frozen Frames data
  void _onDelayedFrameDetected(int startTime, int duration) {
    _delayedFrames.add(InstabugFrameData(startTime, duration));
  }

  //todo: to be removed
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

  Future<void> _reportScreenRenderForCustomUiTrace(
      InstabugScreenRenderData screenRenderData) async {
    log("ReportedData: $screenRenderData", name: tag);
  }

  Future<void> _reportScreenRenderForAutoUiTrace(
      InstabugScreenRenderData screenRenderData) async {
    log("ReportedData: $screenRenderData", name: tag);
  }

  void _saveCollectedData() {
    if (_screenRenderForAutoUiTrace.isNotEmpty) {
      _screenRenderForAutoUiTrace.totalSlowFramesDurations +=
          _slowFramesTotalDuration;
      _screenRenderForAutoUiTrace.totalFrozenFramesDurations +=
          _frozenFramesTotalDuration;
      _screenRenderForAutoUiTrace.frameData.addAll(_delayedFrames);
    }
    if (_screenRenderForCustomUiTrace.isNotEmpty) {
      _screenRenderForCustomUiTrace.totalSlowFramesDurations +=
          _slowFramesTotalDuration;
      _screenRenderForCustomUiTrace.totalFrozenFramesDurations +=
          _frozenFramesTotalDuration;
      _screenRenderForCustomUiTrace.frameData.addAll(_delayedFrames);
    }
  }
}

extension on int {
  int get inMicro => this * 1000;
}
