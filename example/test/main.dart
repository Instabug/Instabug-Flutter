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
        case 'logInfo:':
          return null; 
        case 'clearAllLogs:':
          return null;
        case 'logError:':
          return null;
        case 'logWarn:':
          return null;
        case 'setColorTheme:':
          return null; 
        case 'getTags':
          return ['tag1', 'tag2']; 
        case 'setUserAttribute:withKey:':
          return null;  
        case 'removeUserAttributeForKey:':
          return null;
        case 'show':
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
  
  test('logInfo: Test', () async {
    InstabugFlutter.logInfo(message);
    expect(log, <Matcher>[
      isMethodCall('logInfo:',
        arguments: <String, dynamic>{
          'message': message
        },
      )
    ]);
  });

  test('clearAllLogs: Test', () async {
    InstabugFlutter.clearAllLogs();
    expect(log, <Matcher>[
      isMethodCall('clearAllLogs',
        arguments: null,
      )
    ]);
  });

  test('logError: Test', () async {
    InstabugFlutter.logError(message);
    expect(log, <Matcher>[
      isMethodCall('logError:',
        arguments: <String, dynamic>{
          'message': message
            },
      )
    ]);
  });
  
  test('logWarn: Test', () async {
    InstabugFlutter.logWarn(message);
    expect(log, <Matcher>[
      isMethodCall('logWarn:',
        arguments: <String, dynamic>{
          'message': message
          },
      )
    ]);
  });

  test('test setColorTheme should be called with argument colorTheme', () async {
    const ColorTheme colorTheme = ColorTheme.dark;
    InstabugFlutter.setColorTheme(colorTheme);
    expect(log, <Matcher>[
      isMethodCall('setColorTheme:',
        arguments: <String, dynamic>{
          'colorTheme': colorTheme.toString()
        },
      )
    ]);
  });

  test('test appendTags should be called with argument List of strings', () async {
    const List<String> tags = ['tag1', 'tag2'];
    InstabugFlutter.appendTags(tags);
    expect(log, <Matcher>[
      isMethodCall('appendTags:',
        arguments: <String, dynamic>{
          'tags': tags
        },
      )
    ]);
  });

  test('test resetTags should be called with no arguments', () async {
    InstabugFlutter.resetTags();
    expect(log, <Matcher>[
      isMethodCall('resetTags',
        arguments: null
      )
    ]);
  });

  test('test getTags should be called with no arguments and returns list of tags', () async {
    List<String> tags = await InstabugFlutter.getTags();
    expect(log, <Matcher>[
      isMethodCall('getTags',
        arguments: null
      )
    ]);
    expect(tags, ['tag1','tag2']);
  });

  test('test setUserAttributeWithKey should be called with two string arguments', () async {
    const String value = '19';
    const String key = 'Age';
    InstabugFlutter.setUserAttributeWithKey(value, key);
    expect(log, <Matcher>[
      isMethodCall('setUserAttribute:withKey:',
        arguments: <String, dynamic>{
          'value': value,
          'key': key
        },
      )
    ]);
  });

  test('test removeUserAttributeForKey should be called with a string argument', () async {
    const String key = 'Age';
    InstabugFlutter.removeUserAttributeForKey(key);
    expect(log, <Matcher>[
      isMethodCall('removeUserAttributeForKey:',
        arguments: <String, dynamic>{
          'key': key
        },
      )
    ]);
  });

  test('show Test', () async {
    InstabugFlutter.show();
    expect(log, <Matcher>[
      isMethodCall('show',
        arguments: null,
      )
    ]);
  });

  test('logUserEventWithName: Test', () async {
    InstabugFlutter.logUserEventWithName(name);
    final List<dynamic> args = new List<dynamic>();
    args.add(name);
    expect(log, <Matcher>[
      isMethodCall('logUserEventWithName:',
        arguments: args,
      )
    ]);
  });

}


