import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:meta/meta.dart';

typedef OnW3CFeatureFlagChange = void Function(bool isW3ExternalTraceIDEnabled,
    bool isW3ExternalGeneratedHeaderEnabled, bool isW3CaughtHeaderEnabled);

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
            .isW3FeatureFlagsEnabled())['isW3ExternalTraceIDEnabled']) ??
        false;
  }

  static Future<bool> get isW3ExternalGeneratedHeader async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3ExternalGeneratedHeader);
    }

    return ((await _host.isW3FeatureFlagsEnabled())[
            'isW3ExternalGeneratedHeaderEnabled']) ??
        false;
  }

  static Future<bool> get isW3CaughtHeader async {
    if (IBGBuildInfo.instance.isAndroid) {
      return Future.value(_isAndroidW3CaughtHeader);
    }
    return ((await _host
            .isW3FeatureFlagsEnabled())['isW3CaughtHeaderEnabled']) ??
        false;
  }

  static Future<void> registerW3CFlagsListener() async {
    FeatureFlagsFlutterApi.setup(_instance);

    final featureFlags = await _host.isW3FeatureFlagsEnabled();
    _isAndroidW3CaughtHeader = featureFlags['isW3CaughtHeaderEnabled'] ?? false;
    _isAndroidW3ExternalTraceID =
        featureFlags['isW3ExternalTraceIDEnabled'] ?? false;
    _isAndroidW3ExternalGeneratedHeader =
        featureFlags['isW3ExternalGeneratedHeaderEnabled'] ?? false;

    return _host.bindOnW3CFeatureFlagChangeCallback();
  }

  @override
  @internal
  void onW3CFeatureFlagChange(
    bool isW3ExternalTraceIDEnabled,
    bool isW3ExternalGeneratedHeaderEnabled,
    bool isW3CaughtHeaderEnabled,
  ) {
    _isAndroidW3CaughtHeader = isW3CaughtHeaderEnabled;
    _isAndroidW3ExternalTraceID = isW3ExternalTraceIDEnabled;
    _isAndroidW3ExternalGeneratedHeader = isW3ExternalGeneratedHeaderEnabled;
  }
}
