import 'dart:io';

import 'package:flutter/foundation.dart';

/// Mockable class that contains info about the
/// [Platform], the OS and build modes.
class IBGBuildInfo {
  IBGBuildInfo._();

  static IBGBuildInfo _instance = IBGBuildInfo._();
  static IBGBuildInfo get instance => _instance;

  /// Shorthand for [instance]
  static IBGBuildInfo get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(IBGBuildInfo instance) {
    _instance = instance;
  }

  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;

  String get operatingSystem => Platform.operatingSystem;

  bool get isReleaseMode => kReleaseMode;
  bool get isDebugMode => kDebugMode;
}
