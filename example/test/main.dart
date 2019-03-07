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
        case 'identifyUserWithEmail:':
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() async {
      log.clear();
    });

  test('identifyUserWithEmail:name: Test', () async {
    InstabugFlutter.identifyUserWithEmail(email, name);
    expect(log, <Matcher>[
      isMethodCall('identifyUserWithEmail:name:',
        arguments: <String, dynamic>{
          'email': email,
          'name': name
        },
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test Optional Parameter', () async {
    InstabugFlutter.identifyUserWithEmail(email);
    expect(log, <Matcher>[
      isMethodCall('identifyUserWithEmail:name:',
        arguments: <String, dynamic>{
          'email': email,
          'name': null
        },
      )
    ]);
  });
}
