import 'dart:io';

import 'package:flutter/foundation.dart';

/// Mockable class that contains info about the
/// [Platform], the OS and build modes.
class InstaBuildInfo {
  InstaBuildInfo._();

  static InstaBuildInfo _instance = InstaBuildInfo._();
  static InstaBuildInfo get instance => _instance;

  @visibleForTesting
  static void setInstance(InstaBuildInfo instance) {
    _instance = instance;
  }

  bool get isAndroid => Platform.isAndroid;
  bool get isIOS => Platform.isIOS;

  String get operatingSystem => Platform.operatingSystem;

  bool get isReleaseMode => kReleaseMode;
  bool get isDebugMode => kDebugMode;
}
