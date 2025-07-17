import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter_ndk/instabug_flutter_ndk_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelInstabugFlutterNdk platform = MethodChannelInstabugFlutterNdk();
  const MethodChannel channel = MethodChannel('instabug_flutter_ndk');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
