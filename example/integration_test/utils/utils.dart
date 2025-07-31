import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_example/main.dart';
import 'package:patrol/patrol.dart';

Future<void> init(PatrolIntegrationTester $) async {
  Instabug.init(
    token: 'ed6f659591566da19b67857e1b9d40ab',
    invocationEvents: [InvocationEvent.floatingButton],
    debugLogsLevel: LogLevel.verbose,
  );

  Instabug.setWelcomeMessageMode(WelcomeMessageMode.disabled);

  await $.pumpWidgetAndSettle(const MyApp());
  await $.native2.initialize();

  await wait(second: 2);
}

Future<void> wait({int? second, int? miliSeconds}) {
  return Future.delayed(
      Duration(seconds: second ?? 0, milliseconds: miliSeconds ?? 0));
}

Future<GetNativeViewsResult> getNativeView(PatrolIntegrationTester $,
    {required String android,
    required String ios,
    bool waitUntilVisible = true}) async {
  final nativeView = NativeSelector(
      ios: IOSSelector(identifier: ios),
      android: AndroidSelector(
          resourceName: 'com.instabug.flutter.example:id/${android}'));
  if (waitUntilVisible) {
    await $.native2
        .waitUntilVisible(nativeView, timeout: const Duration(seconds: 8));
  }

  return await $.native2.getNativeViews(nativeView);
}

Future<void> tapNativeView(PatrolIntegrationTester $,
    {required NativeSelector nativeView, bool waitUntilVisible = true}) async {
  if (waitUntilVisible) {
    await $.native2
        .waitUntilVisible(nativeView, timeout: const Duration(seconds: 8));
  }

  await $.native2.tap(nativeView);
}

Future<GetNativeViewsResult> getFAB(PatrolIntegrationTester $,
    {bool waitUntilVisible = true}) {
  return getNativeView($,
      android: 'instabug_floating_button',
      ios: 'IBGFloatingButtonAccessibilityIdentifier',
      waitUntilVisible: waitUntilVisible);
}

bool get isAndroid {
  return defaultTargetPlatform == TargetPlatform.android;
}
