import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter_ndk/instabug_flutter_ndk.dart';
import 'package:instabug_flutter_ndk/instabug_flutter_ndk_platform_interface.dart';
import 'package:instabug_flutter_ndk/instabug_flutter_ndk_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockInstabugFlutterNdkPlatform
    with MockPlatformInterfaceMixin
    implements InstabugFlutterNdkPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final InstabugFlutterNdkPlatform initialPlatform = InstabugFlutterNdkPlatform.instance;

  test('$MethodChannelInstabugFlutterNdk is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelInstabugFlutterNdk>());
  });

  test('getPlatformVersion', () async {
    InstabugFlutterNdk instabugFlutterNdkPlugin = InstabugFlutterNdk();
    MockInstabugFlutterNdkPlatform fakePlatform = MockInstabugFlutterNdkPlatform();
    InstabugFlutterNdkPlatform.instance = fakePlatform;

    expect(await instabugFlutterNdkPlugin.getPlatformVersion(), '42');
  });
}
