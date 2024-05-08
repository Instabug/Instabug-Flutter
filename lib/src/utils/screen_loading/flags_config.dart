import 'package:instabug_flutter/instabug_flutter.dart';

enum FlagsConfig {
  apm,
  uiTrace,
  screenLoading,
}

extension FeatureExtensions on FlagsConfig {
  Future<bool> isEnabled() async {
    switch (this) {
      case FlagsConfig.apm:
        return APM.isEnabled();
      case FlagsConfig.screenLoading:
        return APM.isScreenLoadingEnabled();
      default:
        return false;
    }
  }
}