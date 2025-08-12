import 'dart:convert';
import 'dart:io';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_http_client/instabug_http_client.dart';
import 'package:instabug_http_client/instabug_http_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_http_client_test.mocks.dart';

@GenerateMocks(<Type>[
  InstabugHttpLogger,
  InstabugHttpClient,
  InstabugHostApi,
])
Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  final mHost = MockInstabugHostApi();

  setUpAll(() {
    Instabug.$setHostApi(mHost);
    NetworkLogger.$setHostApi(mHost);
    when(mHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future<Map<String, bool>>.value(<String, bool>{
        'isW3cCaughtHeaderEnabled': true,
        'isW3cExternalGeneratedHeaderEnabled': false,
        'isW3cExternalTraceIDEnabled': true,
      }),
    );
  });

  const fakeResponse = <String, String>{
    'id': '123',
    'activationCode': '111111',
  };
  late Uri url;
  final mockedResponse = http.Response(json.encode(fakeResponse), 200);

  late InstabugHttpClient instabugHttpClient;

  setUp(() {
    url = Uri.parse('http://www.instabug.com');
    instabugHttpClient = InstabugHttpClient();
    instabugHttpClient.client = MockInstabugHttpClient();
    instabugHttpClient.logger = MockInstabugHttpLogger();
  });

  test('expect instabug http client GET to return response', () async {
    when<dynamic>(
      instabugHttpClient.client.get(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    final result = await instabugHttpClient.get(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(1);
  });

  test('expect instabug http client HEAD to return response', () async {
    when<dynamic>(
      instabugHttpClient.client.head(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    final result = await instabugHttpClient.head(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(1);
  });

  test('expect instabug http client DELETE to return response', () async {
    when<dynamic>(
      instabugHttpClient.client.delete(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    final result = await instabugHttpClient.delete(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(1);
  });

  test('expect instabug http client PATCH to return response', () async {
    when<dynamic>(
      instabugHttpClient.client.patch(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    final result = await instabugHttpClient.patch(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(1);
  });

  test('expect instabug http client POST to return response', () async {
    when<dynamic>(
      instabugHttpClient.client.post(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    final result = await instabugHttpClient.post(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(1);
  });

  test('expect instabug http client PUT to return response', () async {
    when<dynamic>(
      instabugHttpClient.client.put(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    final result = await instabugHttpClient.put(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result.body, mockedResponse.body);
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(1);
  });

  test('expect instabug http client READ to return response', () async {
    const response = 'Some response string';
    when<dynamic>(
      instabugHttpClient.client.read(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => response);

    final result = await instabugHttpClient.read(url);
    expect(result, isInstanceOf<String>());
    expect(result, response);
  });

  test('expect instabug http client READBYTES to return response', () async {
    final response = Uint8List(3);
    instabugHttpClient.client =
        MockClient((_) async => http.Response.bytes(response, 200));

    final result = await instabugHttpClient.readBytes(url);
    expect(result, isInstanceOf<Uint8List>());
    expect(result, response);
  });

  test('expect instabug http client SEND to return response', () async {
    final response = http.StreamedResponse(
      const Stream<List<int>>.empty(),
      200,
      contentLength: 0,
    );
    final request = http.StreamedRequest('POST', url)
      ..headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=utf-8'
      ..headers[HttpHeaders.userAgentHeader] = 'Dart';
    when<dynamic>(instabugHttpClient.client.send(request))
        .thenAnswer((_) async => response);
    final responseFuture = instabugHttpClient.send(request);
    request
      ..sink.add('{"hello": "world"}'.codeUnits)
      ..sink.close();

    final result = await responseFuture;
    expect(result, isInstanceOf<http.StreamedResponse>());
    expect(result.headers, response.headers);
    expect(result.statusCode, response.statusCode);
    expect(result.contentLength, response.contentLength);
    expect(result.isRedirect, response.isRedirect);
    expect(result.persistentConnection, response.persistentConnection);
    expect(result.reasonPhrase, response.reasonPhrase);
    expect(result.request, response.request);
    expect(
      await result.stream.bytesToString(),
      await response.stream.bytesToString(),
    );
    final logger = instabugHttpClient.logger as MockInstabugHttpLogger;
    verify(logger.onLogger(any, startTime: anyNamed('startTime'))).called(1);
  });

  test('expect instabug http client CLOSE to be called', () async {
    instabugHttpClient.close();

    verify(instabugHttpClient.client.close());
  });

  test('stress test for GET method', () async {
    when<dynamic>(
      instabugHttpClient.client.get(url, headers: anyNamed('headers')),
    ).thenAnswer((_) async => mockedResponse);
    for (var i = 0; i < 10000; i++) {
      await instabugHttpClient.get(url);
    }
    verify(
      instabugHttpClient.logger
          .onLogger(mockedResponse, startTime: anyNamed('startTime')),
    ).called(10000);
  });
}
