import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'instabug_flutter_ndk_method_channel.dart';

abstract class InstabugFlutterNdkPlatform extends PlatformInterface {
  /// Constructs a InstabugFlutterNdkPlatform.
  InstabugFlutterNdkPlatform() : super(token: _token);

  static final Object _token = Object();

  static InstabugFlutterNdkPlatform _instance = MethodChannelInstabugFlutterNdk();

  /// The default instance of [InstabugFlutterNdkPlatform] to use.
  ///
  /// Defaults to [MethodChannelInstabugFlutterNdk].
  static InstabugFlutterNdkPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [InstabugFlutterNdkPlatform] when
  /// they register themselves.
  static set instance(InstabugFlutterNdkPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
