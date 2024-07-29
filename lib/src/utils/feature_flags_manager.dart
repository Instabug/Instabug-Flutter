import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:meta/meta.dart';

typedef OnW3CFeatureFlagChange = void Function(
  bool isW3cExternalTraceIDEnabled,
  bool isW3cExternalGeneratedHeaderEnabled,
  bool isW3cCaughtHeaderEnabled,
);

class FeatureFlagsManager implements FeatureFlagsFlutterApi {
  static InstabugHostApi _host = InstabugHostApi();
  static FeatureFlagsManager _instance = FeatureFlagsManager();

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(InstabugHostApi host) {
    _host = host;
  }

  // FeatureFlagsManager({InstabugHostApi? instabugHostApi}) {
  //   if (instabugHostApi != null) {
  //     _host = instabugHostApi;
  //   }
  // }

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setFeatureFlagsManager(FeatureFlagsManager featureFlagsManager) {
    _instance = featureFlagsManager;
  }

  static bool _isAndroidW3CExternalTraceID = false;
  static bool _isAndroidW3CExternalGeneratedHeader = false;
  static bool _isAndroidW3CCaughtHeader = false;

  static Future<bool> get isW3CExternalTraceID async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3CExternalTraceID);
    }
    return ((await _host
            .isW3CFeatureFlagsEnabled())['isW3cExternalTraceIDEnabled']) ??
        false;
  }

  static Future<bool> get isW3CExternalGeneratedHeader async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3CExternalGeneratedHeader);
    }

    return ((await _host.isW3CFeatureFlagsEnabled())[
            'isW3cExternalGeneratedHeaderEnabled']) ??
        false;
  }

  static Future<bool> get isW3CCaughtHeader async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3CCaughtHeader);
    }
    return ((await _host
            .isW3CFeatureFlagsEnabled())['isW3cCaughtHeaderEnabled']) ??
        false;
  }

  static Future<void> registerW3CFlagsListener() async {
    FeatureFlagsFlutterApi.setup(_instance);

    final featureFlags = await _host.isW3CFeatureFlagsEnabled();
    _isAndroidW3CCaughtHeader =
        featureFlags['isW3cCaughtHeaderEnabled'] ?? false;
    _isAndroidW3CExternalTraceID =
        featureFlags['isW3cExternalTraceIDEnabled'] ?? false;
    _isAndroidW3CExternalGeneratedHeader =
        featureFlags['isW3cExternalGeneratedHeaderEnabled'] ?? false;

    return _host.bindOnW3CFeatureFlagChangeCallback();
  }

  @override
  @internal
  void onW3CFeatureFlagChange(
    bool isW3cExternalTraceIDEnabled,
    bool isW3cExternalGeneratedHeaderEnabled,
    bool isW3cCaughtHeaderEnabled,
  ) {
    _isAndroidW3CCaughtHeader = isW3cCaughtHeaderEnabled;
    _isAndroidW3CExternalTraceID = isW3cExternalTraceIDEnabled;
    _isAndroidW3CExternalGeneratedHeader = isW3cExternalGeneratedHeaderEnabled;
  }
}
