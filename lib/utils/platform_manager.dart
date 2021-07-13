
import 'dart:io';

class PlatformManager {
  static PlatformManager _platform = PlatformManager();

  static PlatformManager get instance => _platform;

  static void setPlatformInstance(PlatformManager platform) {
    _platform = platform;
  }

  bool isAndroid() => Platform.isAndroid;
  bool isIOS() => Platform.isIOS;
}