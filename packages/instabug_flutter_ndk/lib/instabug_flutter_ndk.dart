
import 'instabug_flutter_ndk_platform_interface.dart';

class InstabugFlutterNdk {
  Future<String?> getPlatformVersion() {
    return InstabugFlutterNdkPlatform.instance.getPlatformVersion();
  }
}
