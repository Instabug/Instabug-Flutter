import 'package:instabug_flutter/instabug_flutter.dart';

enum FlagsConfig {
  Apm,
  UiTrace,
  ScreenLoading,
}

extension FeatureExtensions on FlagsConfig {
  String get name => _getName();

  Future<bool> isEnabled() async {
    switch (this) {
      case FlagsConfig.Apm:
        return await APM.isEnabled();
      case FlagsConfig.ScreenLoading:
        return await APM.isScreenLoadingEnabled();
      default:
        return false;
    }
  }

  String _getName() {
    switch (this) {
      case FlagsConfig.Apm:
        return 'APM';
      case FlagsConfig.ScreenLoading:
        return 'Screen Loading';
      case FlagsConfig.UiTrace:
        return 'Ui Traces';
    }
  }

  String _getAndroidName() {
    switch (this) {
      case FlagsConfig.Apm:
        return 'apm';
      case FlagsConfig.UiTrace:
        return 'ui_traces';
      case FlagsConfig.ScreenLoading:
        return 'screen_loading';
    }
  }
}
