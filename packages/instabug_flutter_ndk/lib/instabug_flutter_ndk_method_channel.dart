import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'instabug_flutter_ndk_platform_interface.dart';

/// An implementation of [InstabugFlutterNdkPlatform] that uses method channels.
class MethodChannelInstabugFlutterNdk extends InstabugFlutterNdkPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('instabug_flutter_ndk');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
