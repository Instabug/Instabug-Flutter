import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/instabug_custom_http_client.dart';
import 'package:instabug_flutter/models/network_data.dart';
import 'package:instabug_flutter/utils/http_client_logger.dart';
import 'package:mockito/mockito.dart';
// import 'package:test_api/test_api.dart';

class MockHttpClient extends Mock implements HttpClient {}

class MockHttpClientRequest extends Mock implements HttpClientRequest {}

class MockHttpClientResponse extends Mock implements HttpClientResponse {}

class MockHttpClientLogger extends Mock implements HttpClientLogger {}

class MockHttpClientCredentials extends Mock implements HttpClientCredentials {}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final List<MethodCall> log = <MethodCall>[];
  const String url = 'https://jsonplaceholder.typicode.com';
  const int port = 8888;
  const String path = '/posts';
  const String body = 'some request body';

  InstabugCustomHttpClient instabugCustomHttpClient;

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
  });

  tearDown(() async {
    log.clear();
  });

  test('expect instabug custom http client GET URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.getUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.getUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client GET to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.get(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.get(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test(
      'expect instabug custom http client DELETE URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.deleteUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.deleteUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client DELETE to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.delete(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.delete(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client POST URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.postUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.postUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client POST to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.post(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.post(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client HEAD URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.headUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.headUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client HEAD to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.head(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.head(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client PATCH URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.patchUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.patchUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client PATCH to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.patch(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.patch(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client OPEN URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.openUrl(any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request =
        await instabugCustomHttpClient.openUrl('GET', Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client OPEN to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.open(any, any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.open('GET', url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client PUT URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.putUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.putUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client PUT to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.put(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.put(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client POST URL to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.postUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.postUrl(Uri.parse(url));
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client POST to return request and log',
      () async {
    when<dynamic>(instabugCustomHttpClient.client.post(any, any, any))
        .thenAnswer((_) async => MockHttpClientRequest());

    final request = await instabugCustomHttpClient.post(url, port, path);
    final response = await request.close();
    expect(request, isInstanceOf<HttpClientRequest>());
    verify(instabugCustomHttpClient.logger.onRequest(request)).called(1);
    verify(instabugCustomHttpClient.logger.onResponse(response, request))
        .called(1);
  });

  test('expect instabug custom http client to get client autoUncompress',
      () async {
    when(instabugCustomHttpClient.client.autoUncompress).thenReturn(true);
    expect(instabugCustomHttpClient.autoUncompress, true);
  });

  test('expect instabug custom http client to set client autoUncompress',
      () async {
    instabugCustomHttpClient.autoUncompress = false;
    verify(instabugCustomHttpClient.client.autoUncompress = false).called(1);
  });

  test('expect instabug custom http client to get client connectionTimout',
      () async {
    when(instabugCustomHttpClient.client.connectionTimeout)
        .thenReturn(Duration(seconds: 2));
    expect(instabugCustomHttpClient.connectionTimeout, Duration(seconds: 2));
  });

  test('expect instabug custom http client to set client connectionTimout',
      () async {
    instabugCustomHttpClient.connectionTimeout = Duration(seconds: 5);
    verify(instabugCustomHttpClient.client.connectionTimeout =
            Duration(seconds: 5))
        .called(1);
  });

  test('expect instabug custom http client to get client idleTimeout',
      () async {
    when(instabugCustomHttpClient.client.idleTimeout)
        .thenReturn(Duration(seconds: 2));
    expect(instabugCustomHttpClient.idleTimeout, Duration(seconds: 2));
  });

  test('expect instabug custom http client to set client idleTimeout',
      () async {
    instabugCustomHttpClient.idleTimeout = Duration(seconds: 5);
    verify(instabugCustomHttpClient.client.idleTimeout = Duration(seconds: 5))
        .called(1);
  });

  test('expect instabug custom http client to get client maxConnectionsPerHost',
      () async {
    when(instabugCustomHttpClient.client.maxConnectionsPerHost).thenReturn(2);
    expect(instabugCustomHttpClient.maxConnectionsPerHost, 2);
  });

  test('expect instabug custom http client to set client maxConnectionsPerHost',
      () async {
    instabugCustomHttpClient.maxConnectionsPerHost = 5;
    verify(instabugCustomHttpClient.client.maxConnectionsPerHost = 5).called(1);
  });

  test('expect instabug custom http client to get client userAgent', () async {
    when(instabugCustomHttpClient.client.userAgent).thenReturn('2');
    expect(instabugCustomHttpClient.userAgent, '2');
  });

  test('expect instabug custom http client to set client userAgent', () async {
    instabugCustomHttpClient.userAgent = 'something';
    verify(instabugCustomHttpClient.client.userAgent = 'something').called(1);
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
        (Uri url, String scheme, String realm) {};
    instabugCustomHttpClient.authenticate = f;
    verify(instabugCustomHttpClient.client.authenticate = f).called(1);
  });

  test('expect instabug custom http client to set client authenticateProxy',
      () async {
    final Future<bool> Function(
            String host, int port, String scheme, String realm) f =
        (String host, int port, String scheme, String realm) {};
    instabugCustomHttpClient.authenticateProxy = f;
    verify(instabugCustomHttpClient.client.authenticateProxy = f).called(1);
  });

  test(
      'expect instabug custom http client to set client badCertificateCallback',
      () async {
    final Function(X509Certificate cert, String host, int port) f =
        (X509Certificate cert, String host, int port) {};
    instabugCustomHttpClient.badCertificateCallback = f;
    verify(instabugCustomHttpClient.client.badCertificateCallback = f)
        .called(1);
  });

  test('expect instabug custom http client to call client close', () async {
    instabugCustomHttpClient.close(force: true);
    verify(instabugCustomHttpClient.client.close(force: true)).called(1);
  });

  test('Stress test on GET URL method', () async {
    when<dynamic>(instabugCustomHttpClient.client.getUrl(any))
        .thenAnswer((_) async => MockHttpClientRequest());

    for (int i = 0; i < 10000; i++) {
      await instabugCustomHttpClient.getUrl(Uri.parse(url));
    }

    verify(instabugCustomHttpClient.logger.onRequest(any)).called(10000);
    verify(instabugCustomHttpClient.logger.onResponse(any, any)).called(10000);
  });
}
