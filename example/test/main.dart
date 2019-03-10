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
  String message = "Test Message";

  setUpAll(() async {
    MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'startWithToken:invocationEvents:':
          return null;
        case 'showWelcomeMessageWithMode:':
          return null;
        case 'identifyUserWithEmail:':
          return null;
        case 'logOut':
          return null;
        case 'setLocale:':
          return null;
        case 'logVerbose:':
          return null;
        case 'logDebug:':
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

  test('logOut Test', () async {
    InstabugFlutter.logOut();
    expect(log, <Matcher>[
      isMethodCall('logOut',
        arguments: <String, dynamic>{
        },
      )
    ]);
  });
  
  test('setLocale:', () async {
    InstabugFlutter.setLocale(Locale.German);
    expect(log, <Matcher>[
      isMethodCall('setLocale:',
        arguments: <String, dynamic>{
            'locale': Locale.German.toString()
        },
      )
    ]);
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
  
  test('logDebug: Test', () async {
    InstabugFlutter.logDebug(message);
    expect(log, <Matcher>[
      isMethodCall('logDebug:',
        arguments: <String, dynamic>{
          'message': message
        },
      )
    ]);
  });
}
