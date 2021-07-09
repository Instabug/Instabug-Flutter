import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_custom_http_client.dart';
import 'package:instabug_flutter/utils/http_client_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_logger_test.mocks.dart';

@GenerateMocks([
  HttpClient,
  HttpClientLogger,
  HttpClientRequest,
  HttpClientResponse,
  HttpClientCredentials,
])
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];
  const String url = 'https://jsonplaceholder.typicode.com';
  const int port = 8888;
  const String path = '/posts';

  late InstabugCustomHttpClient instabugCustomHttpClient;
  late MockHttpClientRequest mockRequest;
  late MockHttpClientResponse mockResponse;

  setUpAll(() async {
    const MethodChannel('instabug_flutter')
        .setMockMethodCallHandler((MethodCall methodCall) async {
      log.add(methodCall);
    });
  });

  setUp(() {
    instabugCustomHttpClient = InstabugCustomHttpClient();
    instabugCustomHttpClient.client = MockHttpClient();
    instabugCustomHttpClient.logger = MockHttpClientLogger();

    mockRequest = MockHttpClientRequest();
    mockResponse = MockHttpClientResponse();

    when<dynamic>(mockRequest.close()).thenAnswer((_) async => mockResponse);
  });

  tearDown(() async {
    log.clear();
  });

  test('expect instabug custom http client GET URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).getUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.getUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client GET to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .get(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.get(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test(
      'expect instabug custom http client DELETE URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).deleteUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.deleteUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client DELETE to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .delete(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.delete(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client POST URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).postUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.postUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client POST to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .post(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.post(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client HEAD URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).headUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.headUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client HEAD to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .head(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.head(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client PATCH URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).patchUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.patchUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client PATCH to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .patch(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.patch(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client OPEN URL to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .openUrl(any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.openUrl('GET', Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client OPEN to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .open(any, any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.open('GET', url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client PUT URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).putUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.putUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client PUT to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .put(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.put(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client POST URL to return request and log',
      () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).postUrl(any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.postUrl(Uri.parse(url));

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client POST to return request and log',
      () async {
    when<dynamic>((instabugCustomHttpClient.client as MockHttpClient)
            .post(any, any, any))
        .thenAnswer((_) async => mockRequest);

    await instabugCustomHttpClient.post(url, port, path);

    verify(instabugCustomHttpClient.logger.onRequest(mockRequest));
    verify(
        instabugCustomHttpClient.logger.onResponse(mockResponse, mockRequest));
  });

  test('expect instabug custom http client to get client autoUncompress',
      () async {
    when((instabugCustomHttpClient.client as MockHttpClient).autoUncompress)
        .thenReturn(true);
    expect(instabugCustomHttpClient.autoUncompress, true);
  });

  test('expect instabug custom http client to set client autoUncompress',
      () async {
    instabugCustomHttpClient.autoUncompress = false;
    verify((instabugCustomHttpClient.client as MockHttpClient).autoUncompress =
            false)
        .called(1);
  });

  test('expect instabug custom http client to get client connectionTimout',
      () async {
    when((instabugCustomHttpClient.client as MockHttpClient).connectionTimeout)
        .thenReturn(const Duration(seconds: 2));
    expect(
        instabugCustomHttpClient.connectionTimeout, const Duration(seconds: 2));
  });

  test('expect instabug custom http client to set client connectionTimout',
      () async {
    instabugCustomHttpClient.connectionTimeout = const Duration(seconds: 5);
    verify((instabugCustomHttpClient.client as MockHttpClient)
            .connectionTimeout = const Duration(seconds: 5))
        .called(1);
  });

  test('expect instabug custom http client to get client idleTimeout',
      () async {
    when((instabugCustomHttpClient.client as MockHttpClient).idleTimeout)
        .thenReturn(const Duration(seconds: 2));
    expect(instabugCustomHttpClient.idleTimeout, const Duration(seconds: 2));
  });

  test('expect instabug custom http client to set client idleTimeout',
      () async {
    instabugCustomHttpClient.idleTimeout = const Duration(seconds: 5);
    verify((instabugCustomHttpClient.client as MockHttpClient).idleTimeout =
            const Duration(seconds: 5))
        .called(1);
  });

  test('expect instabug custom http client to get client maxConnectionsPerHost',
      () async {
    when((instabugCustomHttpClient.client as MockHttpClient)
            .maxConnectionsPerHost)
        .thenReturn(2);
    expect(instabugCustomHttpClient.maxConnectionsPerHost, 2);
  });

  test('expect instabug custom http client to set client maxConnectionsPerHost',
      () async {
    instabugCustomHttpClient.maxConnectionsPerHost = 5;
    verify((instabugCustomHttpClient.client as MockHttpClient)
            .maxConnectionsPerHost = 5)
        .called(1);
  });

  test('expect instabug custom http client to get client userAgent', () async {
    when((instabugCustomHttpClient.client as MockHttpClient).userAgent)
        .thenReturn('2');
    expect(instabugCustomHttpClient.userAgent, '2');
  });

  test('expect instabug custom http client to set client userAgent', () async {
    instabugCustomHttpClient.userAgent = 'something';
    verify((instabugCustomHttpClient.client as MockHttpClient).userAgent =
            'something')
        .called(1);
  });

  test('expect instabug custom http client to call client addClientCredentials',
      () async {
    const String realm = 'realm string';
    final MockHttpClientCredentials clientCredentials =
        MockHttpClientCredentials();
    instabugCustomHttpClient.addCredentials(
        Uri.parse(url), realm, clientCredentials);
    verify(instabugCustomHttpClient.client
            .addCredentials(Uri.parse(url), realm, clientCredentials))
        .called(1);
  });

  test('expect instabug custom http client to call client addProxyCredentials',
      () async {
    const String realm = 'realm string';
    final MockHttpClientCredentials clientCredentials =
        MockHttpClientCredentials();
    instabugCustomHttpClient.addProxyCredentials(
        url, port, realm, clientCredentials);
    verify(instabugCustomHttpClient.client
            .addProxyCredentials(url, port, realm, clientCredentials))
        .called(1);
  });

  test('expect instabug custom http client to set client authenticate',
      () async {
    final Future<bool> Function(Uri url, String scheme, String realm) f =
        (Uri url, String scheme, String realm) async => true;
    instabugCustomHttpClient.authenticate = f;
    verify((instabugCustomHttpClient.client as MockHttpClient).authenticate = f)
        .called(1);
  });

  test('expect instabug custom http client to set client authenticateProxy',
      () async {
    final Future<bool> Function(
            String host, int port, String scheme, String realm) f =
        (String host, int port, String scheme, String realm) async => true;
    instabugCustomHttpClient.authenticateProxy = f;
    verify((instabugCustomHttpClient.client as MockHttpClient)
            .authenticateProxy = f)
        .called(1);
  });

  test(
      'expect instabug custom http client to set client badCertificateCallback',
      () async {
    final bool Function(X509Certificate cert, String host, int port) f =
        (X509Certificate cert, String host, int port) => true;
    instabugCustomHttpClient.badCertificateCallback = f;
    verify((instabugCustomHttpClient.client as MockHttpClient)
            .badCertificateCallback = f)
        .called(1);
  });

  test('expect instabug custom http client to call client close', () async {
    instabugCustomHttpClient.close(force: true);
    verify((instabugCustomHttpClient.client as MockHttpClient)
            .close(force: true))
        .called(1);
  });

  test('Stress test on GET URL method', () async {
    when<dynamic>(
            (instabugCustomHttpClient.client as MockHttpClient).getUrl(any))
        .thenAnswer((_) async => mockRequest);

    for (int i = 0; i < 10000; i++) {
      await instabugCustomHttpClient.getUrl(Uri.parse(url));
    }

    verify((instabugCustomHttpClient.logger as MockHttpClientLogger)
            .onRequest(any))
        .called(10000);
    verify((instabugCustomHttpClient.logger as MockHttpClientLogger)
            .onResponse(any, any))
        .called(10000);
  });
}
