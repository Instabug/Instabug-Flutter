import 'dart:convert';

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

  test(
      'test setVideoRecordingFloatingButtonPosition should be called with argument position',
      () async {
    const position = Position.topRight;
    await BugReporting.setVideoRecordingFloatingButtonPosition(position);
    final args = <dynamic>[position.toString()];
    expect(log, <Matcher>[
      isMethodCall(
        'setVideoRecordingFloatingButtonPosition:',
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

}
