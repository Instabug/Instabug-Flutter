import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:instabug_flutter/CrashReporting.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'package:instabug_flutter/BugReporting.dart';
import 'package:instabug_flutter/InstabugLog.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/Surveys.dart';
import 'package:instabug_flutter/FeatureRequests.dart';
import 'package:instabug_flutter/Chats.dart';
import 'package:instabug_flutter/Replies.dart';
import 'package:instabug_flutter/models/crash_data.dart';
import 'package:instabug_flutter/models/exception_data.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final List<MethodCall> log = <MethodCall>[];
  final appToken = '068ba9a8c3615035e163dc5f829c73be';
  final List<InvocationEvent> invocationEvents = <InvocationEvent>[
    InvocationEvent.floatingButton
  ];
  final email = "s@nta.com";
  final name = "santa";
  String message = "Test Message";
  const String userAttribute = '19';
  const Map<String, String> userAttributePair = <String, String>{
    'gender': 'female'
  };

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
    final List<dynamic> args = <dynamic>[
      appToken,
      <String>[InvocationEvent.floatingButton.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'startWithToken:invocationEvents:',
        arguments: args,
      )
    ]);
  });

  test('showWelcomeMessageWithMode: Test', () async {
    Instabug.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
    final List<dynamic> args = <dynamic>[WelcomeMessageMode.beta.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'showWelcomeMessageWithMode:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test', () async {
    Instabug.identifyUser(email, name);
    final List<dynamic> args = <dynamic>[email, name];
    expect(log, <Matcher>[
      isMethodCall(
        'identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test Optional Parameter', () async {
    Instabug.identifyUser(email);
    final List<dynamic> args = <dynamic>[email, null];
    expect(log, <Matcher>[
      isMethodCall(
        'identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });

  test('logOut Test', () async {
    Instabug.logOut();
    expect(log, <Matcher>[isMethodCall('logOut', arguments: null)]);
  });

  test('setLocale:', () async {
    Instabug.setLocale(IBGLocale.german);
    final List<dynamic> args = <dynamic>[IBGLocale.german.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setLocale:',
        arguments: args,
      )
    ]);
  });

  test('logVerbose: Test', () async {
    InstabugLog.logVerbose(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logVerbose:',
        arguments: args,
      )
    ]);
  });

  test('logDebug: Test', () async {
    InstabugLog.logDebug(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logDebug:',
        arguments: args,
      )
    ]);
  });

  test('logInfo: Test', () async {
    InstabugLog.logInfo(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logInfo:',
        arguments: args,
      )
    ]);
  });

  test('clearAllLogs: Test', () async {
    InstabugLog.clearAllLogs();
    expect(log, <Matcher>[isMethodCall('clearAllLogs', arguments: null)]);
  });

  test('logError: Test', () async {
    InstabugLog.logError(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logError:',
        arguments: args,
      )
    ]);
  });

  test('logWarn: Test', () async {
    InstabugLog.logWarn(message);
    final List<dynamic> args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logWarn:',
        arguments: args,
      )
    ]);
  });

  test('test setColorTheme should be called with argument colorTheme',
      () async {
    const ColorTheme colorTheme = ColorTheme.dark;
    Instabug.setColorTheme(colorTheme);
    final List<dynamic> args = <dynamic>[colorTheme.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setColorTheme:',
        arguments: args,
      )
    ]);
  });

  test('test appendTags should be called with argument List of strings',
      () async {
    const List<String> tags = ['tag1', 'tag2'];
    Instabug.appendTags(tags);
    final List<dynamic> args = <dynamic>[tags];
    expect(log, <Matcher>[
      isMethodCall(
        'appendTags:',
        arguments: args,
      )
    ]);
  });

  test('test resetTags should be called with no arguments', () async {
    Instabug.resetTags();
    expect(log, <Matcher>[isMethodCall('resetTags', arguments: null)]);
  });

  test(
      'test getTags should be called with no arguments and returns list of tags',
      () async {
    List<String> tags = await Instabug.getTags();
    expect(log, <Matcher>[isMethodCall('getTags', arguments: null)]);
    expect(tags, ['tag1', 'tag2']);
  });

  test(
      'test setUserAttributeWithKey should be called with two string arguments',
      () async {
    const String value = '19';
    const String key = 'Age';
    Instabug.setUserAttribute(value, key);
    final List<dynamic> args = <dynamic>[value, key];
    expect(log, <Matcher>[
      isMethodCall(
        'setUserAttribute:withKey:',
        arguments: args,
      )
    ]);
  });

  test('test removeUserAttributeForKey should be called with a string argument',
      () async {
    const String key = 'Age';
    Instabug.removeUserAttribute(key);
    final List<dynamic> args = <dynamic>[key];
    expect(log, <Matcher>[
      isMethodCall(
        'removeUserAttributeForKey:',
        arguments: args,
      )
    ]);
  });

  test(
      'test getUserAttributeForKey should be called with a string argument and return a string',
      () async {
    const String key = 'Age';
    final String value = await Instabug.getUserAttributeForKey(key);
    expect(log, <Matcher>[
      isMethodCall('getUserAttributeForKey:', arguments: <dynamic>[key])
    ]);
    expect(value, userAttribute);
  });

  test(
      'test getuserAttributes should be called with no arguments and returns a Map',
      () async {
    final Map<String, String> result = await Instabug.getUserAttributes();
    expect(log, <Matcher>[isMethodCall('getUserAttributes', arguments: null)]);
    expect(result, userAttributePair);
  });

  test('show Test', () async {
    Instabug.show();
    expect(log, <Matcher>[
      isMethodCall(
        'show',
        arguments: null,
      )
    ]);
  });

  test('logUserEventWithName: Test', () async {
    Instabug.logUserEvent(name);
    final List<dynamic> args = <dynamic>[name];
    expect(log, <Matcher>[
      isMethodCall(
        'logUserEventWithName:',
        arguments: args,
      )
    ]);
  });

  test('test setValueForStringWithKey should be called with two arguments',
      () async {
    const String value = 'Some key';
    const CustomTextPlaceHolderKey key = CustomTextPlaceHolderKey.shakeHint;
    Instabug.setValueForStringWithKey(value, key);
    final List<dynamic> args = <dynamic>[value, key.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setValue:forStringWithKey:',
        arguments: args,
      )
    ]);
  });

  test('setSessionProfilerEnabled: Test', () async {
    const bool sessionProfilerEnabled = true;
    final List<dynamic> args = <dynamic>[sessionProfilerEnabled];
    Instabug.setSessionProfilerEnabled(sessionProfilerEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setSessionProfilerEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setPrimaryColor: Test', () async {
    Color c = const Color.fromRGBO(255, 0, 255, 1.0);
    final List<dynamic> args = <dynamic>[c.value];
    Instabug.setPrimaryColor(c);
    expect(log, <Matcher>[
      isMethodCall(
        'setPrimaryColor:',
        arguments: args,
      )
    ]);
  });

  test('setUserData: Test', () async {
    String s = "This is a String";
    final List<dynamic> args = <dynamic>[s];
    Instabug.setUserData(s);
    expect(log, <Matcher>[
      isMethodCall(
        'setUserData:',
        arguments: args,
      )
    ]);
  });

  test('addFileAttachmentWithURL: Test', () async {
    String filePath = "filePath";
    String fileName = "fileName";
    final List<dynamic> args = <dynamic>[filePath, fileName];
    Instabug.addFileAttachmentWithURL(filePath, fileName);
    expect(log, <Matcher>[
      isMethodCall(
        'addFileAttachmentWithURL:',
        arguments: args,
      )
    ]);
  });

  test('addFileAttachmentWithData: Test', () async {
    var bdata = new Uint8List(10);
    String fileName = "fileName";
    final List<dynamic> args = <dynamic>[bdata, fileName];
    Instabug.addFileAttachmentWithData(bdata, fileName);
    expect(log, <Matcher>[
      isMethodCall(
        'addFileAttachmentWithData:',
        arguments: args,
      )
    ]);
  });

  test('clearFileAttachments Test', () async {
    Instabug.clearFileAttachments();
    expect(log, <Matcher>[
      isMethodCall(
        'clearFileAttachments',
        arguments: null,
      )
    ]);
  });

  test('setWelcomeMessageMode Test', () async {
    final List<dynamic> args = <dynamic>[WelcomeMessageMode.live.toString()];
    Instabug.setWelcomeMessageMode(WelcomeMessageMode.live);
    expect(log, <Matcher>[
      isMethodCall(
        'setWelcomeMessageMode:',
        arguments: args,
      )
    ]);
  });

  test('reportScreenChange Test', () async {
    const String screenName = 'screen 1';
    final List<dynamic> args = <dynamic>[screenName];
    Instabug.reportScreenChange(screenName);
    expect(log, <Matcher>[
      isMethodCall('reportScreenChange:',
        arguments: args,
      )
    ]);
  });

  test('setReproStepsMode Test', () async {
    final List<dynamic> args = <dynamic>[ReproStepsMode.enabled.toString()];
    Instabug.setReproStepsMode(ReproStepsMode.enabled);
    expect(log, <Matcher>[
      isMethodCall('setReproStepsMode:',
        arguments: args,
      )
    ]);
  });

  test('setBugReportingEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    BugReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setBugReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setOnInvokeCallback Test', () async {
    BugReporting.setOnInvokeCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnInvokeCallback',
        arguments: null,
      )
    ]);
  });

  test('setOnDismissCallback Test', () async {
    BugReporting.setOnDismissCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnDismissCallback',
        arguments: null,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setInvocationEvents(
        <InvocationEvent>[InvocationEvent.floatingButton]);
    final List<dynamic> args = <dynamic>[
      <String>[InvocationEvent.floatingButton.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationEvents:',
        arguments: args,
      )
    ]);
  });

  test(
      'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording: Test',
      () async {
    BugReporting.setEnabledAttachmentTypes(false, false, false, false);
    final List<dynamic> args = <dynamic>[false, false, false, false];
    expect(log, <Matcher>[
      isMethodCall(
        'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setReportTypes(<ReportType>[ReportType.feedback]);
    final List<dynamic> args = <dynamic>[
      <String>[ReportType.feedback.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setReportTypes:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    BugReporting.setExtendedBugReportMode(
        ExtendedBugReportMode.enabledWithOptionalFields);
    final List<dynamic> args = <dynamic>[
      ExtendedBugReportMode.enabledWithOptionalFields.toString()
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setExtendedBugReportMode:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationOptions Test', () async {
    BugReporting.setInvocationOptions(
        <InvocationOption>[InvocationOption.emailFieldHidden]);
    final List<dynamic> args = <dynamic>[
      <String>[InvocationOption.emailFieldHidden.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationOptions:',
        arguments: args,
      )
    ]);
  });

  test('showBugReportingWithReportTypeAndOptions:options Test', () async {
    BugReporting.show(
        ReportType.bug, <InvocationOption>[InvocationOption.emailFieldHidden]);
    final List<dynamic> args = <dynamic>[
      ReportType.bug.toString(),
      <String>[InvocationOption.emailFieldHidden.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'showBugReportingWithReportTypeAndOptions:options:',
        arguments: args,
      )
    ]);
  });

  test('setSurveysEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Surveys.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setSurveysEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAutoShowingSurveysEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Surveys.setAutoShowingEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAutoShowingSurveysEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setOnShowSurveyCallback Test', () async {
    Surveys.setOnShowCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnShowSurveyCallback',
        arguments: null,
      )
    ]);
  });

  test('setOnDismissSurveyCallback Test', () async {
    Surveys.setOnDismissCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnDismissSurveyCallback',
        arguments: null,
      )
    ]);
  });

  test('setShouldShowSurveysWelcomeScreen: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Surveys.setShouldShowWelcomeScreen(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setShouldShowSurveysWelcomeScreen:',
        arguments: args,
      )
    ]);
  });

  test('showSurveysIfAvailable Test', () async {
    Surveys.showSurveyIfAvailable();
    expect(log, <Matcher>[
      isMethodCall(
        'showSurveysIfAvailable',
      )
    ]);
  });

  test('showSurveyWithToken Test', () async {
    String token = "token";
    final List<dynamic> args = <dynamic>[token];
    Surveys.showSurvey(token);
    expect(log, <Matcher>[
      isMethodCall(
        'showSurveyWithToken:',
        arguments: args,
      )
    ]);
  });

  test('hasRespondedToSurvey Test', () async {
    String token = "token";
    final List<dynamic> args = <dynamic>[token];
    Surveys.hasRespondedToSurvey(token, () => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'hasRespondedToSurveyWithToken:',
        arguments: args,
      )
    ]);
  });

  test('showFeatureRequests Test', () async {
    FeatureRequests.show();
    expect(log, <Matcher>[isMethodCall('showFeatureRequests')]);
  });

  test('setEmailFieldRequiredForFeatureRequests:forAction: Test', () async {
    bool isEmailFieldRequired = false;
    final List<dynamic> args = <dynamic>[
      isEmailFieldRequired,
      <String>[ActionType.addCommentToFeature.toString()]
    ];
    FeatureRequests.setEmailFieldRequired(
        isEmailFieldRequired, [ActionType.addCommentToFeature]);
    expect(log, <Matcher>[
      isMethodCall(
        'setEmailFieldRequiredForFeatureRequests:forAction:',
        arguments: args,
      )
    ]);
  });

  test('showChats Test', () async {
    Chats.show();
    expect(log, <Matcher>[isMethodCall('showChats')]);
  });

  test('setChatsEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Chats.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setChatsEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setRepliesEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Replies.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setRepliesEnabled:',
        arguments: args,
      )
    ]);
  });

  test('showReplies Test', () async {
    Replies.show();
    expect(log, <Matcher>[isMethodCall('showReplies')]);
  });

  test('hasChats Test', () async {
    Replies.hasChats(() => () {});
    expect(log, <Matcher>[isMethodCall('hasChats')]);
  });

  test('setOnNewReplyReceivedCallback Test', () async {
    Replies.setOnNewReplyReceivedCallback(() => () {});
    expect(log, <Matcher>[isMethodCall('setOnNewReplyReceivedCallback')]);
  });

  test('getUnreadRepliesCount Test', () async {
    Replies.getUnreadRepliesCount(() => () {});
    expect(log, <Matcher>[isMethodCall('getUnreadRepliesCount')]);
  });

  test('setChatNotificationEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    Replies.setInAppNotificationsEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setChatNotificationEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setCrashReportingEnabled: Test', () async {
    bool isEnabled = false;
    final List<dynamic> args = <dynamic>[isEnabled];
    CrashReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setCrashReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('sendJSCrashByReflection:handled: Test', () async {
    try {
      final List<dynamic> params = <dynamic>[1, 2];
      params[5] = 2;
    } catch (exception, stack) {
      const bool handled = true;
      final Trace trace = Trace.from(stack);
      final List<ExceptionData> frames = <ExceptionData>[];
      for (int i = 0; i < trace.frames.length; i++) {
        frames.add(ExceptionData(
            trace.frames[i].uri.toString(),
            trace.frames[i].member,
            trace.frames[i].line,
            trace.frames[i].column == null ? 0 : trace.frames[i].column));
      }
      CrashData crashData = CrashData(
          exception.toString(), Platform.operatingSystem.toString(), frames);
      final List<dynamic> args = <dynamic>[jsonEncode(crashData), handled];
      CrashReporting.reportHandledCrash(exception, stack);
      expect(log, <Matcher>[
        isMethodCall(
          'sendJSCrashByReflection:handled:',
          arguments: args,
        )
      ]);
    }
  });

  ///Since the below method only runs on android and has the [Platform.isAndroid] condition in it, it will fail when running outside android,
  /// therefore its commented.
  // test('setEnableInAppNotificationSound: Test', () async {
  //   bool isEnabled = false;
  //   final List<dynamic> args = <dynamic>[isEnabled];
  //   Replies.setInAppNotificationSound(isEnabled);
  //   expect(log, <Matcher>[
  //     isMethodCall('setEnableInAppNotificationSound:',
  //       arguments: args,
  //     )
  //   ]);
  // });
}
