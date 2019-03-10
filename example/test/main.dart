import 'dart:io';

import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final List<MethodCall> log = <MethodCall>[];
  final appToken = '068ba9a8c3615035e163dc5f829c73be';
  final invocationEvents = [InvocationEvent.floatingButton];
  final email = "s@nta.com";
  final name = "santa";

  setUpAll(() async {
    MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'startWithToken:invocationEvents:':
          return null;
        case 'showWelcomeMessageWithMode:':
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() async {
      log.clear();
    });


  test('startWithToken:invocationEvents: Test', () async {
    InstabugFlutter.start(appToken, invocationEvents);
    expect(log, <Matcher>[
      isMethodCall('startWithToken:invocationEvents:',
        arguments: <String, dynamic>{
          'token': appToken,
          'invocationEvents': [InvocationEvent.floatingButton.toString()]
        },
      )
    ]);
  });
  
  test('showWelcomeMessageWithMode: Test', () async {
    InstabugFlutter.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
    expect(log, <Matcher>[
      isMethodCall('showWelcomeMessageWithMode:',
        arguments: <String, dynamic>{
          'welcomeMessageMode': WelcomeMessageMode.beta.toString()
        },
      )
    ]);
  });
}
