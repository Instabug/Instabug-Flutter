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

}
