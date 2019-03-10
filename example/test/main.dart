import 'dart:io';

import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final List<MethodCall> log = <MethodCall>[];
  String message = "Test Message";

  setUpAll(() async {
    MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'startWithToken:invocationEvents:':
          return null;
        default:
          return null;
      }
    });
  });

  tearDown(() async {
      log.clear();
    });

  test('logVerbose: Test', () async {
    InstabugFlutter.logVerbose(message);
    expect(log, <Matcher>[
      isMethodCall('logVerbose:',
        arguments: <String, dynamic>{
          'message': message
        },
      )
    ]);
  });
}
