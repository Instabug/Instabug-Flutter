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
        case 'invokeWithMode:options:':
          return null;
        case 'LogUserEventWithName:':
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
    final List<dynamic> args = <dynamic>[appToken, <String>[InvocationEvent.floatingButton.toString()]];
    expect(log, <Matcher>[
      isMethodCall('startWithToken:invocationEvents:',
        arguments: args,
      )
    ]);
  });
  
  test('showWelcomeMessageWithMode: Test', () async {
    InstabugFlutter.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
    final List<dynamic> args = <dynamic>[WelcomeMessageMode.beta.toString()];
    expect(log, <Matcher>[
      isMethodCall('showWelcomeMessageWithMode:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test', () async {
    InstabugFlutter.identifyUserWithEmail(email, name);
    final List<dynamic> args = <dynamic>[email, name];
    expect(log, <Matcher>[
      isMethodCall('identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });
  
  test('identifyUserWithEmail:name: Test Optional Parameter', () async {
    InstabugFlutter.identifyUserWithEmail(email);
    final List<dynamic> args = <dynamic>[email, null];
    expect(log, <Matcher>[
      isMethodCall('identifyUserWithEmail:name:',
        arguments:args,
      )
    ]);
  });

  test('logOut Test', () async {
    InstabugFlutter.logOut();
    expect(log, <Matcher>[
      isMethodCall('logOut',
        arguments: null)
    ]);
  });
  
  test('setLocale:', () async {
    InstabugFlutter.setLocale(Locale.German);
    final List<dynamic> args = <dynamic>[Locale.German.toString()];
    expect(log, <Matcher>[
      isMethodCall('setLocale:',
        arguments: args,
      )
    ]);
  });


  test('logVerbose: Test', () async {
    InstabugFlutter.logVerbose(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logVerbose:',
        arguments: args,
      )
    ]);
  });
  
  test('logDebug: Test', () async {
    InstabugFlutter.logDebug(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logDebug:',
        arguments: args,
      )
    ]);
  });
  
  test('logInfo: Test', () async {
    InstabugFlutter.logInfo(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logInfo:',
        arguments: args,
      )
    ]);
  });

  test('clearAllLogs: Test', () async {
    InstabugFlutter.clearAllLogs();
    expect(log, <Matcher>[
      isMethodCall('clearAllLogs',
        arguments: null)
    ]);
  });

  test('logError: Test', () async {
    InstabugFlutter.logError(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logError:',
        arguments: args,
      )
    ]);
  });
  
  test('logWarn: Test', () async {
    InstabugFlutter.logWarn(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logWarn:',
        arguments: args,
      )
    ]);
  });

  test('test setColorTheme should be called with argument colorTheme', () async {
    const ColorTheme colorTheme = ColorTheme.dark;
    InstabugFlutter.setColorTheme(colorTheme);
    final List<dynamic> args = <dynamic>[colorTheme.toString()];
    expect(log, <Matcher>[
      isMethodCall('setColorTheme:',
        arguments: args,
      )
    ]);
  });

  test('test appendTags should be called with argument List of strings', () async {
    const List<String> tags = ['tag1', 'tag2'];
    InstabugFlutter.appendTags(tags);
    final List<dynamic> args = <dynamic>[tags];
    expect(log, <Matcher>[
      isMethodCall('appendTags:',
        arguments: args,
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
    final List<dynamic> args = <dynamic>[value, key];
    expect(log, <Matcher>[
      isMethodCall('setUserAttribute:withKey:',
        arguments: args,
      )
    ]);
  });

  test('test removeUserAttributeForKey should be called with a string argument', () async {
    const String key = 'Age';
    InstabugFlutter.removeUserAttributeForKey(key);
    final List<dynamic> args = <dynamic>[key];
    expect(log, <Matcher>[
      isMethodCall('removeUserAttributeForKey:',
        arguments: args,
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

  
  test('invokeWithMode:options: Test', () async {
    InstabugFlutter.invokeWithMode(InvocationMode.BUG, [InvocationOption.COMMENT_FIELD_REQUIRED]);
    final List<dynamic> args = <dynamic>[InvocationMode.BUG.toString(), <String>[InvocationOption.COMMENT_FIELD_REQUIRED.toString()]];
    expect(log, <Matcher>[
      isMethodCall('invokeWithMode:options:',
        arguments: args,
      )
    ]);
  });

  test('logUserEventWithName: Test', () async {
    InstabugFlutter.logUserEventWithName(name);
    final List<dynamic> args = <dynamic>[name];
    expect(log, <Matcher>[
      isMethodCall('logUserEventWithName:',
        arguments: args,
      )
    ]);
  });

}


