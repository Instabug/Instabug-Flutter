import 'package:instabug_flutter/instabug_flutter.dart';

enum FlagsConfig {
  apm,
  uiTrace,
  screenLoading,
  endScreenLoading,
  screenRendering,
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
      case FlagsConfig.screenRendering:
        return APM.isScreenRenderEnabled();
      default:
        return false;
    }
  }
}
