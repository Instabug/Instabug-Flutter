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

  static bool _isAndroidW3ExternalTraceID = false;
  static bool _isAndroidW3ExternalGeneratedHeader = false;
  static bool _isAndroidW3CaughtHeader = false;

  static Future<bool> get isW3ExternalTraceID async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3ExternalTraceID);
    }
    return ((await _host
            .isW3CFeatureFlagsEnabled())['isW3cExternalTraceIDEnabled']) ??
        false;
  }

  static Future<bool> get isW3ExternalGeneratedHeader async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3ExternalGeneratedHeader);
    }

    return ((await _host.isW3CFeatureFlagsEnabled())[
            'isW3cExternalGeneratedHeaderEnabled']) ??
        false;
  }

  static Future<bool> get isW3CaughtHeader async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3CaughtHeader);
    }
    return ((await _host
            .isW3CFeatureFlagsEnabled())['isW3cCaughtHeaderEnabled']) ??
        false;
  }

  static Future<void> registerW3CFlagsListener() async {
    FeatureFlagsFlutterApi.setup(_instance);

    final featureFlags = await _host.isW3CFeatureFlagsEnabled();
    _isAndroidW3CaughtHeader =
        featureFlags['isW3cCaughtHeaderEnabled'] ?? false;
    _isAndroidW3ExternalTraceID =
        featureFlags['isW3cExternalTraceIDEnabled'] ?? false;
    _isAndroidW3ExternalGeneratedHeader =
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
    _isAndroidW3CaughtHeader = isW3cCaughtHeaderEnabled;
    _isAndroidW3ExternalTraceID = isW3cExternalTraceIDEnabled;
    _isAndroidW3ExternalGeneratedHeader = isW3cExternalGeneratedHeaderEnabled;
  }
}
