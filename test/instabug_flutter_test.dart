import 'dart:io';

import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {

  final List<MethodCall> log = <MethodCall>[];
  final appToken = '068ba9a8c3615035e163dc5f829c73be';
  final List<InvocationEvent> invocationEvents = <InvocationEvent>[InvocationEvent.floatingButton];
  final email = "s@nta.com";
  final name = "santa";
  String message = "Test Message";
  const String userAttribute = '19';
  const Map<String, String> userAttributePair = <String, String>{'gender': 'female'};

  setUpAll(() async {
    MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getTags':
          return <String>['tag1', 'tag2']; 
        case 'getUserAttributeForKey:':
          return userAttribute;
        case 'getUserAttributes':
          return userAttributePair;
        default:
          return null;
      }
    });
  });

  tearDown(() async {
      log.clear();
    });

test('startWithToken:invocationEvents: Test', () async {
    Instabug.start(appToken, invocationEvents);
    final List<dynamic> args = <dynamic>[appToken, <String>[InvocationEvent.floatingButton.toString()]];
    expect(log, <Matcher>[
      isMethodCall('startWithToken:invocationEvents:',
        arguments: args,
      )
    ]);
  });
  
  test('showWelcomeMessageWithMode: Test', () async {
    Instabug.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
    final List<dynamic> args = <dynamic>[WelcomeMessageMode.beta.toString()];
    expect(log, <Matcher>[
      isMethodCall('showWelcomeMessageWithMode:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test', () async {
    Instabug.identifyUserWithEmail(email, name);
    final List<dynamic> args = <dynamic>[email, name];
    expect(log, <Matcher>[
      isMethodCall('identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });
  
  test('identifyUserWithEmail:name: Test Optional Parameter', () async {
    Instabug.identifyUserWithEmail(email);
    final List<dynamic> args = <dynamic>[email, null];
    expect(log, <Matcher>[
      isMethodCall('identifyUserWithEmail:name:',
        arguments:args,
      )
    ]);
  });

  test('logOut Test', () async {
    Instabug.logOut();
    expect(log, <Matcher>[
      isMethodCall('logOut',
        arguments: null)
    ]);
  });
  
  test('setLocale:', () async {
    Instabug.setLocale(Locale.German);
    final List<dynamic> args = <dynamic>[Locale.German.toString()];
    expect(log, <Matcher>[
      isMethodCall('setLocale:',
        arguments: args,
      )
    ]);
  });


  test('logVerbose: Test', () async {
    InstabugLog.logVerbose(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logVerbose:',
        arguments: args,
      )
    ]);
  });
  
  test('logDebug: Test', () async {
    InstabugLog.logDebug(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logDebug:',
        arguments: args,
      )
    ]);
  });
  
  test('logInfo: Test', () async {
    InstabugLog.logInfo(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logInfo:',
        arguments: args,
      )
    ]);
  });

  test('clearAllLogs: Test', () async {
    InstabugLog.clearAllLogs();
    expect(log, <Matcher>[
      isMethodCall('clearAllLogs',
        arguments: null
      )
    ]);
  });

  test('logError: Test', () async {
    InstabugLog.logError(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logError:',
        arguments: args,
      )
    ]);
  });
  
  test('logWarn: Test', () async {
    InstabugLog.logWarn(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall('logWarn:',
        arguments: args,
      )
    ]);
  });

  test('test setColorTheme should be called with argument colorTheme', () async {
    const ColorTheme colorTheme = ColorTheme.dark;
    Instabug.setColorTheme(colorTheme);
    final List<dynamic> args = <dynamic>[colorTheme.toString()];
    expect(log, <Matcher>[
      isMethodCall('setColorTheme:',
        arguments: args,
      )
    ]);
  });

  test('test appendTags should be called with argument List of strings', () async {
    const List<String> tags = ['tag1', 'tag2'];
    Instabug.appendTags(tags);
    final List<dynamic> args = <dynamic>[tags];
    expect(log, <Matcher>[
      isMethodCall('appendTags:',
        arguments: args,
      )
    ]);
  });

  test('test resetTags should be called with no arguments', () async {
    Instabug.resetTags();
    expect(log, <Matcher>[
      isMethodCall('resetTags',
        arguments: null
      )
    ]);
  });

  test('test getTags should be called with no arguments and returns list of tags', () async {
    List<String> tags = await Instabug.getTags();
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
    Instabug.setUserAttributeWithKey(value, key);
    final List<dynamic> args = <dynamic>[value, key];
    expect(log, <Matcher>[
      isMethodCall('setUserAttribute:withKey:',
        arguments: args,
      )
    ]);
  });

  test('test removeUserAttributeForKey should be called with a string argument', () async {
    const String key = 'Age';
    Instabug.removeUserAttributeForKey(key);
    final List<dynamic> args = <dynamic>[key];
    expect(log, <Matcher>[
      isMethodCall('removeUserAttributeForKey:',
        arguments: args,
      )
    ]);
  });

  test('test getUserAttributeForKey should be called with a string argument and return a string', () async {
    const String key = 'Age';
    final String value = await Instabug.getUserAttributeForKey(key);
    expect(log, <Matcher>[
      isMethodCall('getUserAttributeForKey:',
        arguments: <dynamic>[key]
      )
    ]);
    expect(value, userAttribute);
  });

  test('test getuserAttributes should be called with no arguments and returns a Map', () async {
    final Map<String, String> result = await Instabug.getUserAttributes();
    expect(log, <Matcher>[
      isMethodCall('getUserAttributes',
        arguments: null
      )
    ]);
    expect(result, userAttributePair);
  });
  
  test('show Test', () async {
    Instabug.show();
    expect(log, <Matcher>[
      isMethodCall('show',
        arguments: null,
      )
    ]);
  });

  
  test('invokeWithMode:options: Test', () async {
    BugReporting.invokeWithMode(InvocationMode.BUG, [InvocationOption.COMMENT_FIELD_REQUIRED]);
    final List<dynamic> args = <dynamic>[InvocationMode.BUG.toString(), <String>[InvocationOption.COMMENT_FIELD_REQUIRED.toString()]];
    expect(log, <Matcher>[
      isMethodCall('invokeWithMode:options:',
        arguments: args,
      )
    ]);
  });

  test('logUserEventWithName: Test', () async {
    Instabug.logUserEventWithName(name);
    final List<dynamic> args = <dynamic>[name];
    expect(log, <Matcher>[
      isMethodCall('logUserEventWithName:',
        arguments: args,
      )
    ]);
  });

  test('test setValueForStringWithKey should be called with two arguments', () async {
    const String value = 'Some key';
    const IBGCustomTextPlaceHolderKey key = IBGCustomTextPlaceHolderKey.SHAKE_HINT;
    Instabug.setValueForStringWithKey(value, key);
    final List<dynamic> args = <dynamic>[value, key.toString()];
    expect(log, <Matcher>[
      isMethodCall('setValue:forStringWithKey:',
        arguments: args,
      )
    ]);
  });

}


