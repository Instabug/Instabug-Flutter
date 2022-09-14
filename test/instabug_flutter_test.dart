import 'dart:convert';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'instabug_flutter_test.mocks.dart';

@GenerateMocks([
  IBGBuildInfo,
  IBGDateTime,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  final log = <MethodCall>[];
  const appToken = '068ba9a8c3615035e163dc5f829c73be';
  final invocationEvents = <InvocationEvent>[InvocationEvent.floatingButton];
  const email = 's@nta.com';
  const name = 'santa';
  const message = 'Test Message';
  const userAttribute = '19';
  const userAttributePair = <String, String>{'gender': 'female'};
  late MockIBGBuildInfo mockBuildInfo;

  const url = 'https://jsonplaceholder.typicode.com';
  const method = 'POST';
  final startDate = DateTime.now();
  final endDate = DateTime.now().add(const Duration(hours: 1));
  const requestBody = 'requestBody';
  const responseBody = 'responseBody';
  const status = 200;
  const requestHeaders = <String, dynamic>{'request': 'request'};
  const responseHeaders = <String, dynamic>{'response': 'response'};
  const duration = 10;
  const contentType = 'contentType';
  final networkData = NetworkData(
    url: url,
    method: method,
    startTime: startDate,
    requestContentType: contentType,
    responseContentType: contentType,
    duration: duration,
    endTime: endDate,
    requestBody: requestBody,
    responseBody: responseBody,
    requestHeaders: requestHeaders,
    responseHeaders: responseHeaders,
    status: status,
  );

  setUpAll(() async {
    const MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
      switch (methodCall.method) {
        case 'getTags':
          return <String>['tag1', 'tag2'];
        case 'startExecutionTrace:id:':
          return (methodCall.arguments as List<Object?>)[0];
        case 'getUserAttributeForKey:':
          return userAttribute;
        case 'getUserAttributes':
          return userAttributePair;
        default:
          return null;
      }
    });
  });

  setUp(() {
    mockBuildInfo = MockIBGBuildInfo();
    IBGBuildInfo.setInstance(mockBuildInfo);
  });

  tearDown(() async {
    log.clear();
  });

  test('startWithToken:invocationEvents: should be called', () async {
    await Instabug.start(appToken, invocationEvents);
    final args = <dynamic>[
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
    await Instabug.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
    final args = <dynamic>[WelcomeMessageMode.beta.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'showWelcomeMessageWithMode:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test', () async {
    await Instabug.identifyUser(email, name);
    final args = <dynamic>[email, name];
    expect(log, <Matcher>[
      isMethodCall(
        'identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });

  test('identifyUserWithEmail:name: Test Optional Parameter', () async {
    await Instabug.identifyUser(email);
    final args = <dynamic>[email, null];
    expect(log, <Matcher>[
      isMethodCall(
        'identifyUserWithEmail:name:',
        arguments: args,
      )
    ]);
  });

  test('logOut Test', () async {
    await Instabug.logOut();
    expect(log, <Matcher>[isMethodCall('logOut', arguments: null)]);
  });

  test('setLocale:', () async {
    await Instabug.setLocale(IBGLocale.german);
    final args = <dynamic>[IBGLocale.german.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setLocale:',
        arguments: args,
      )
    ]);
  });

  test('setSdkDebugLogsLevel:', () async {
    await Instabug.setSdkDebugLogsLevel(IBGSDKDebugLogsLevel.verbose);
    final args = <dynamic>[IBGSDKDebugLogsLevel.verbose.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setSdkDebugLogsLevel:',
        arguments: args,
      )
    ]);
  });

  test('logVerbose: Test', () async {
    await InstabugLog.logVerbose(message);
    final args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logVerbose:',
        arguments: args,
      )
    ]);
  });

  test('logDebug: Test', () async {
    await InstabugLog.logDebug(message);
    final args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logDebug:',
        arguments: args,
      )
    ]);
  });

  test('logInfo: Test', () async {
    await InstabugLog.logInfo(message);
    final args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logInfo:',
        arguments: args,
      )
    ]);
  });

  test('clearAllLogs: Test', () async {
    await InstabugLog.clearAllLogs();
    expect(log, <Matcher>[isMethodCall('clearAllLogs', arguments: null)]);
  });

  test('logError: Test', () async {
    await InstabugLog.logError(message);
    final args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logError:',
        arguments: args,
      )
    ]);
  });

  test('logWarn: Test', () async {
    await InstabugLog.logWarn(message);
    final args = <dynamic>[message];
    expect(log, <Matcher>[
      isMethodCall(
        'logWarn:',
        arguments: args,
      )
    ]);
  });

  test('test setColorTheme should be called with argument colorTheme',
      () async {
    const colorTheme = ColorTheme.dark;
    await Instabug.setColorTheme(colorTheme);
    final args = <dynamic>[colorTheme.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setColorTheme:',
        arguments: args,
      )
    ]);
  });

  test(
      'test setFloatingButtonEdge should be called with arguments floatingButtonEdge and offsetFromTop',
      () async {
    const floatingButtonEdge = FloatingButtonEdge.left;
    const offsetFromTop = 300;
    await BugReporting.setFloatingButtonEdge(floatingButtonEdge, offsetFromTop);
    final args = <dynamic>[floatingButtonEdge.toString(), offsetFromTop];
    expect(log, <Matcher>[
      isMethodCall(
        'setFloatingButtonEdge:withTopOffset:',
        arguments: args,
      )
    ]);
  });

  test('test appendTags should be called with argument List of strings',
      () async {
    const tags = ['tag1', 'tag2'];
    await Instabug.appendTags(tags);
    final args = <dynamic>[tags];
    expect(log, <Matcher>[
      isMethodCall(
        'appendTags:',
        arguments: args,
      )
    ]);
  });

  test('test resetTags should be called with no arguments', () async {
    await Instabug.resetTags();
    expect(log, <Matcher>[isMethodCall('resetTags', arguments: null)]);
  });

  test(
      'test getTags should be called with no arguments and returns list of tags',
      () async {
    final tags = await Instabug.getTags();
    expect(log, <Matcher>[isMethodCall('getTags', arguments: null)]);
    expect(tags, ['tag1', 'tag2']);
  });

  test(
    'test addExperiments should be called with argument List of strings',
    () async {
      const experiments = ['exp1', 'exp2'];
      Instabug.addExperiments(experiments);
      final args = <dynamic>[experiments];
      expect(log, <Matcher>[
        isMethodCall(
          'addExperiments:',
          arguments: args,
        )
      ]);
    },
  );

  test(
    'test removeExperiments should be called with argument List of strings',
    () async {
      const experiments = ['exp1', 'exp2'];
      Instabug.removeExperiments(experiments);
      final args = <dynamic>[experiments];
      expect(log, <Matcher>[
        isMethodCall(
          'removeExperiments:',
          arguments: args,
        )
      ]);
    },
  );

  test(
    'test clearAllExperiments should be called with no arguments',
    () async {
      Instabug.clearAllExperiments();
      expect(log, <Matcher>[
        isMethodCall(
          'clearAllExperiments',
          arguments: null,
        )
      ]);
    },
  );

  test(
      'test setUserAttributeWithKey should be called with two string arguments',
      () async {
    const value = '19';
    const key = 'Age';
    await Instabug.setUserAttribute(value, key);
    final args = <dynamic>[value, key];
    expect(log, <Matcher>[
      isMethodCall(
        'setUserAttribute:withKey:',
        arguments: args,
      )
    ]);
  });

  test('test removeUserAttributeForKey should be called with a string argument',
      () async {
    const key = 'Age';
    await Instabug.removeUserAttribute(key);
    final args = <dynamic>[key];
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
    const key = 'Age';
    final value = await Instabug.getUserAttributeForKey(key);
    expect(log, <Matcher>[
      isMethodCall('getUserAttributeForKey:', arguments: <dynamic>[key])
    ]);
    expect(value, userAttribute);
  });

  test(
      'test getuserAttributes should be called with no arguments and returns a Map',
      () async {
    final result = await Instabug.getUserAttributes();
    expect(log, <Matcher>[isMethodCall('getUserAttributes', arguments: null)]);
    expect(result, userAttributePair);
  });

  test('show Test', () async {
    await Instabug.show();
    expect(log, <Matcher>[
      isMethodCall(
        'show',
        arguments: null,
      )
    ]);
  });

  test('logUserEventWithName: Test', () async {
    await Instabug.logUserEvent(name);
    final args = <dynamic>[name];
    expect(log, <Matcher>[
      isMethodCall(
        'logUserEventWithName:',
        arguments: args,
      )
    ]);
  });

  test('test setValueForStringWithKey should be called with two arguments',
      () async {
    const value = 'Some key';
    const key = CustomTextPlaceHolderKey.shakeHint;
    await Instabug.setValueForStringWithKey(value, key);
    final args = <dynamic>[value, key.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setValue:forStringWithKey:',
        arguments: args,
      )
    ]);
  });

  test('setSessionProfilerEnabled: Test', () async {
    const sessionProfilerEnabled = true;
    final args = <dynamic>[sessionProfilerEnabled];
    await Instabug.setSessionProfilerEnabled(sessionProfilerEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setSessionProfilerEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setDebugEnabled: Test', () async {
    when(mockBuildInfo.isAndroid).thenReturn(true);

    const debugEnabled = true;
    final args = <dynamic>[debugEnabled];
    await Instabug.setDebugEnabled(debugEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setDebugEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setPrimaryColor: Test', () async {
    const c = Color.fromRGBO(255, 0, 255, 1.0);
    final args = <dynamic>[c.value];
    await Instabug.setPrimaryColor(c);
    expect(log, <Matcher>[
      isMethodCall(
        'setPrimaryColor:',
        arguments: args,
      )
    ]);
  });

  test('setUserData: Test', () async {
    const s = 'This is a String';
    final args = <dynamic>[s];
    await Instabug.setUserData(s);
    expect(log, <Matcher>[
      isMethodCall(
        'setUserData:',
        arguments: args,
      )
    ]);
  });

  test('addFileAttachmentWithURL: Test', () async {
    const filePath = 'filePath';
    const fileName = 'fileName';
    final args = <dynamic>[filePath, fileName];

    when(mockBuildInfo.isIOS).thenReturn(false);
    await Instabug.addFileAttachmentWithURL(filePath, fileName);

    expect(log, <Matcher>[
      isMethodCall(
        'addFileAttachmentWithURL:',
        arguments: args,
      )
    ]);
  });

  test('addFileAttachmentWithData: Test', () async {
    final bdata = Uint8List(10);
    const fileName = 'fileName';
    final args = <dynamic>[bdata, fileName];

    when(mockBuildInfo.isIOS).thenReturn(false);
    await Instabug.addFileAttachmentWithData(bdata, fileName);

    expect(log, <Matcher>[
      isMethodCall(
        'addFileAttachmentWithData:',
        arguments: args,
      )
    ]);
  });

  test('clearFileAttachments Test', () async {
    await Instabug.clearFileAttachments();
    expect(log, <Matcher>[
      isMethodCall(
        'clearFileAttachments',
        arguments: null,
      )
    ]);
  });

  test('setWelcomeMessageMode Test', () async {
    final args = <dynamic>[WelcomeMessageMode.live.toString()];
    await Instabug.setWelcomeMessageMode(WelcomeMessageMode.live);
    expect(log, <Matcher>[
      isMethodCall(
        'setWelcomeMessageMode:',
        arguments: args,
      )
    ]);
  });

  test('reportScreenChange Test', () async {
    const screenName = 'screen 1';
    final args = <dynamic>[screenName];
    await Instabug.reportScreenChange(screenName);
    expect(log, <Matcher>[
      isMethodCall(
        'reportScreenChange:',
        arguments: args,
      )
    ]);
  });

  test('setReproStepsMode Test', () async {
    final args = <dynamic>[ReproStepsMode.enabled.toString()];
    await Instabug.setReproStepsMode(ReproStepsMode.enabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setReproStepsMode:',
        arguments: args,
      )
    ]);
  });

  test('setBugReportingEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await BugReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setBugReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setShakingThresholdForiPhone: Test', () async {
    const iPhoneShakingThreshold = 1.6;
    final args = <dynamic>[iPhoneShakingThreshold];

    when(mockBuildInfo.isIOS).thenReturn(true);

    await BugReporting.setShakingThresholdForiPhone(iPhoneShakingThreshold);
    expect(log, <Matcher>[
      isMethodCall(
        'setShakingThresholdForiPhone:',
        arguments: args,
      )
    ]);
  });

  test('setShakingThresholdForiPad: Test', () async {
    const iPadShakingThreshold = 1.6;
    final args = <dynamic>[iPadShakingThreshold];

    when(mockBuildInfo.isIOS).thenReturn(true);

    await BugReporting.setShakingThresholdForiPad(iPadShakingThreshold);
    expect(log, <Matcher>[
      isMethodCall(
        'setShakingThresholdForiPad:',
        arguments: args,
      )
    ]);
  });

  test('setShakingThresholdForAndroid: Test', () async {
    const androidThreshold = 1000;
    final args = <dynamic>[androidThreshold];

    when(mockBuildInfo.isAndroid).thenReturn(true);

    await BugReporting.setShakingThresholdForAndroid(androidThreshold);
    expect(log, <Matcher>[
      isMethodCall(
        'setShakingThresholdForAndroid:',
        arguments: args,
      )
    ]);
  });

  test('setOnInvokeCallback Test', () async {
    await BugReporting.setOnInvokeCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnInvokeCallback',
        arguments: null,
      )
    ]);
  });

  test('setOnDismissCallback Test', () async {
    await BugReporting.setOnDismissCallback((dismissType, reportType) => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnDismissCallback',
        arguments: null,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    await BugReporting.setInvocationEvents(
      <InvocationEvent>[InvocationEvent.floatingButton],
    );
    final args = <dynamic>[
      <String>[InvocationEvent.floatingButton.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationEvents:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    await BugReporting.setInvocationEvents(null);
    final args = <dynamic>[<String>[]];
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
    await BugReporting.setEnabledAttachmentTypes(false, false, false, false);
    final args = <dynamic>[false, false, false, false];
    expect(log, <Matcher>[
      isMethodCall(
        'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationEvents Test', () async {
    await BugReporting.setReportTypes(<ReportType>[ReportType.feedback]);
    final args = <dynamic>[
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
    await BugReporting.setExtendedBugReportMode(
      ExtendedBugReportMode.enabledWithOptionalFields,
    );
    final args = <dynamic>[
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
    await BugReporting.setInvocationOptions(
      <InvocationOption>[InvocationOption.emailFieldHidden],
    );
    final args = <dynamic>[
      <String>[InvocationOption.emailFieldHidden.toString()]
    ];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationOptions:',
        arguments: args,
      )
    ]);
  });

  test('setInvocationOptions Test: empty', () async {
    await BugReporting.setInvocationOptions(null);
    final args = <dynamic>[<String>[]];
    expect(log, <Matcher>[
      isMethodCall(
        'setInvocationOptions:',
        arguments: args,
      )
    ]);
  });

  test('showBugReportingWithReportTypeAndOptions:options Test', () async {
    await BugReporting.show(
      ReportType.bug,
      <InvocationOption>[InvocationOption.emailFieldHidden],
    );
    final args = <dynamic>[
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

  test('showBugReportingWithReportTypeAndOptions:options Test: empty options',
      () async {
    await BugReporting.show(ReportType.bug, null);
    final args = <dynamic>[ReportType.bug.toString(), <String>[]];
    expect(log, <Matcher>[
      isMethodCall(
        'showBugReportingWithReportTypeAndOptions:options:',
        arguments: args,
      )
    ]);
  });

  test('setSurveysEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await Surveys.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setSurveysEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAutoShowingSurveysEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await Surveys.setAutoShowingEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAutoShowingSurveysEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setOnShowSurveyCallback Test', () async {
    await Surveys.setOnShowCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnShowSurveyCallback',
        arguments: null,
      )
    ]);
  });

  test('setOnDismissSurveyCallback Test', () async {
    await Surveys.setOnDismissCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'setOnDismissSurveyCallback',
        arguments: null,
      )
    ]);
  });

  test('setShouldShowSurveysWelcomeScreen: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await Surveys.setShouldShowWelcomeScreen(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setShouldShowSurveysWelcomeScreen:',
        arguments: args,
      )
    ]);
  });

  test('showSurveysIfAvailable Test', () async {
    await Surveys.showSurveyIfAvailable();
    expect(log, <Matcher>[
      isMethodCall(
        'showSurveysIfAvailable',
        arguments: null,
      )
    ]);
  });

  test('showSurveyWithToken Test', () async {
    const token = 'token';
    final args = <dynamic>[token];
    await Surveys.showSurvey(token);
    expect(log, <Matcher>[
      isMethodCall(
        'showSurveyWithToken:',
        arguments: args,
      )
    ]);
  });

  test('hasRespondedToSurvey Test', () async {
    const token = 'token';
    final args = <dynamic>[token];
    await Surveys.hasRespondedToSurvey(token, (hasResponded) => () {});
    expect(log, <Matcher>[
      isMethodCall(
        'hasRespondedToSurveyWithToken:',
        arguments: args,
      )
    ]);
  });

  test('setAppStoreURL Test', () async {
    const appStoreURL = 'appStoreURL';
    final args = <dynamic>[appStoreURL];

    when(mockBuildInfo.isIOS).thenReturn(true);

    await Surveys.setAppStoreURL(appStoreURL);
    expect(log, <Matcher>[
      isMethodCall(
        'setAppStoreURL:',
        arguments: args,
      )
    ]);
  });

  test('showFeatureRequests Test', () async {
    await FeatureRequests.show();
    expect(
      log,
      <Matcher>[isMethodCall('showFeatureRequests', arguments: null)],
    );
  });

  test('setEmailFieldRequiredForFeatureRequests:forAction: Test', () async {
    const isEmailFieldRequired = false;
    final args = <dynamic>[
      isEmailFieldRequired,
      <String>[ActionType.addCommentToFeature.toString()]
    ];
    await FeatureRequests.setEmailFieldRequired(
      isEmailFieldRequired,
      [ActionType.addCommentToFeature],
    );
    expect(log, <Matcher>[
      isMethodCall(
        'setEmailFieldRequiredForFeatureRequests:forAction:',
        arguments: args,
      )
    ]);
  });

  test('setRepliesEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await Replies.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setRepliesEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setInAppNotificationSound: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];

    when(mockBuildInfo.isAndroid).thenReturn(true);

    await Replies.setInAppNotificationSound(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setEnableInAppNotificationSound:',
        arguments: args,
      )
    ]);
  });

  test('showReplies Test', () async {
    await Replies.show();
    expect(log, <Matcher>[isMethodCall('showReplies', arguments: null)]);
  });

  test('hasChats Test', () async {
    await Replies.hasChats((hasChats) => () {});
    expect(log, <Matcher>[isMethodCall('hasChats', arguments: null)]);
  });

  test('setOnNewReplyReceivedCallback Test', () async {
    await Replies.setOnNewReplyReceivedCallback(() => () {});
    expect(log, <Matcher>[
      isMethodCall('setOnNewReplyReceivedCallback', arguments: null)
    ]);
  });

  test('getUnreadRepliesCount Test', () async {
    await Replies.getUnreadRepliesCount((unreadRepliesCount) => () {});
    expect(
      log,
      <Matcher>[isMethodCall('getUnreadRepliesCount', arguments: null)],
    );
  });

  test('setChatNotificationEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await Replies.setInAppNotificationsEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setChatNotificationEnabled:',
        arguments: args,
      )
    ]);
  });

  test('networkLog: Test', () async {
    final data =
        NetworkData(method: 'method', url: 'url', startTime: DateTime.now());
    final args = <dynamic>[data.toMap()];
    final networkLogger = NetworkLogger();

    when(mockBuildInfo.isAndroid).thenReturn(false);
    await networkLogger.networkLog(data);

    expect(log, <Matcher>[
      isMethodCall(
        'networkLog:',
        arguments: args,
      )
    ]);
  });

  test('setCrashReportingEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await CrashReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setCrashReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('sendJSCrashByReflection:handled: Test', () async {
    try {
      final params = <dynamic>[1, 2];
      params[5] = 2;
    } catch (exception, stack) {
      const handled = true;
      final trace = stack_trace.Trace.from(stack);
      final frames = <ExceptionData>[];
      for (var i = 0; i < trace.frames.length; i++) {
        frames.add(
          ExceptionData(
            trace.frames[i].uri.toString(),
            trace.frames[i].member,
            trace.frames[i].line,
            trace.frames[i].column == null ? 0 : trace.frames[i].column!,
          ),
        );
      }
      when(mockBuildInfo.operatingSystem).thenReturn('test');
      final crashData = CrashData(
        exception.toString(),
        IBGBuildInfo.instance.operatingSystem,
        frames,
      );
      final args = <dynamic>[jsonEncode(crashData), handled];
      await CrashReporting.reportHandledCrash(exception, stack);
      expect(log, <Matcher>[
        isMethodCall(
          'sendJSCrashByReflection:handled:',
          arguments: args,
        )
      ]);
    }
  });
  test('Test NetworkData model ToMap', () async {
    final newNetworkData = networkData.toMap();
    expect(networkData.url, newNetworkData['url']);
    expect(networkData.method, newNetworkData['method']);
    expect(
      networkData.requestContentType,
      newNetworkData['requestContentType'],
    );
    expect(
      networkData.responseContentType,
      newNetworkData['responseContentType'],
    );
    expect(networkData.duration, newNetworkData['duration']);
    expect(networkData.requestBody, newNetworkData['requestBody']);
    expect(networkData.responseBody, newNetworkData['responseBody']);
    expect(networkData.requestHeaders, newNetworkData['requestHeaders']);
    expect(networkData.responseHeaders, newNetworkData['responseHeaders']);
  });
  test('Test NetworkData model CopyWith empty', () async {
    final newNetworkData = networkData.copyWith();
    final newNetworkDataMap = newNetworkData.toMap();
    final networkDataMap = networkData.toMap();
    networkDataMap.forEach((key, dynamic value) {
      expect(value, newNetworkDataMap[key]);
    });
  });

  test('Test NetworkData model CopyWith', () async {
    const urlCopy = 'https://jsonplaceholder.typicode.comCopy';
    const methodCopy = 'POSTCopy';
    const requestBodyCopy = 'requestBodyCopy';
    const responseBodyCopy = 'responseBodyCopy';
    const requestHeadersCopy = <String, dynamic>{'requestCopy': 'requestCopy'};
    const responseHeadersCopy = <String, dynamic>{
      'responseCopy': 'responseCopy'
    };
    const durationCopy = 20;
    const contentTypeCopy = 'contentTypeCopy';
    final startDateCopy = DateTime.now().add(const Duration(days: 1));
    final endDateCopy = DateTime.now().add(const Duration(days: 2));
    const statusCopy = 300;

    final newNetworkData = networkData.copyWith(
      url: urlCopy,
      method: methodCopy,
      requestBody: requestBodyCopy,
      requestHeaders: requestHeadersCopy,
      responseBody: responseBodyCopy,
      responseHeaders: responseHeadersCopy,
      duration: durationCopy,
      requestContentType: contentTypeCopy,
      responseContentType: contentTypeCopy,
      startTime: startDateCopy,
      endTime: endDateCopy,
      status: statusCopy,
    );

    expect(newNetworkData.url, urlCopy);
    expect(newNetworkData.method, methodCopy);
    expect(newNetworkData.requestBody, requestBodyCopy);
    expect(newNetworkData.requestHeaders, requestHeadersCopy);
    expect(newNetworkData.responseBody, responseBodyCopy);
    expect(newNetworkData.responseHeaders, responseHeadersCopy);
    expect(newNetworkData.duration, durationCopy);
    expect(newNetworkData.requestContentType, contentTypeCopy);
    expect(newNetworkData.responseContentType, contentTypeCopy);
    expect(newNetworkData.startTime, startDateCopy);
    expect(newNetworkData.endTime, endDateCopy);
    expect(newNetworkData.status, statusCopy);
  });

  test('setAPMEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await APM.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAPMEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAPMLogLevel: Test', () async {
    const level = LogLevel.error;
    final args = <dynamic>[level.toString()];
    await APM.setLogLevel(level);
    expect(log, <Matcher>[
      isMethodCall(
        'setAPMLogLevel:',
        arguments: args,
      )
    ]);
  });

  test('setColdAppLaunchEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await APM.setColdAppLaunchEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setColdAppLaunchEnabled:',
        arguments: args,
      )
    ]);
  });

  test('startExecutionTrace: Test', () async {
    const name = 'test-trace';
    final timestamp = DateTime.now();
    final args = <dynamic>[name, timestamp.toString()];

    final mockDateTime = MockIBGDateTime();
    IBGDateTime.setInstance(mockDateTime);
    when(mockDateTime.now()).thenAnswer((_) => timestamp);

    await APM.startExecutionTrace(name);

    expect(log, <Matcher>[
      isMethodCall(
        'startExecutionTrace:id:',
        arguments: args,
      )
    ]);
  });

  test('setExecutionTraceAttribute: Test', () async {
    const name = 'test_trace';
    const id = '111';
    const key = 'key';
    const value = 'value';
    final args = <dynamic>[id, key, value];
    final trace = Trace(id, name);
    trace.setAttribute(key, value);
    expect(log, <Matcher>[
      isMethodCall(
        'setExecutionTraceAttribute:key:value:',
        arguments: args,
      )
    ]);
  });

  test('setCrashReportingEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await CrashReporting.setEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setCrashReportingEnabled:',
        arguments: args,
      )
    ]);
  });

  test('setAutoUITraceEnabled: Test', () async {
    const isEnabled = false;
    final args = <dynamic>[isEnabled];
    await APM.setAutoUITraceEnabled(isEnabled);
    expect(log, <Matcher>[
      isMethodCall(
        'setAutoUITraceEnabled:',
        arguments: args,
      )
    ]);
  });

  test('startUITrace: Test', () async {
    const name = 'UI_Trace';
    final args = <dynamic>[name];
    await APM.startUITrace(name);
    expect(log, <Matcher>[
      isMethodCall(
        'startUITrace:',
        arguments: args,
      )
    ]);
  });

  test('endUITrace: Test', () async {
    await APM.endUITrace();
    expect(log, <Matcher>[isMethodCall('endUITrace', arguments: null)]);
  });

  test('endAppLaunch: Test', () async {
    await APM.endAppLaunch();
    expect(log, <Matcher>[isMethodCall('endAppLaunch', arguments: null)]);
  });
}
