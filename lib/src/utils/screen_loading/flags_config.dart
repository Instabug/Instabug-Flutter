import 'package:instabug_flutter/instabug_flutter.dart';

enum FlagsConfig {
  apm,
  uiTrace,
  screenLoading,
  endScreenLoading,
}

extension FeatureExtensions on FlagsConfig {
  Future<bool> isEnabled() async {
    switch (this) {
      case FlagsConfig.apm:
        return APM.isEnabled();
      case FlagsConfig.screenLoading:
        return APM.isScreenLoadingEnabled();
      case FlagsConfig.endScreenLoading:
        return APM.isEndScreenLoadingEnabled();
      default:
        return false;
    }
  }
}
