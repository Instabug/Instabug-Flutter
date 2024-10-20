import 'dart:convert';
import 'dart:io';

// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:instabug_http_client/instabug_http_client.dart';
import 'package:instabug_http_client/instabug_http_logger.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_http_client_test.mocks.dart';

@GenerateMocks(<Type>[
  InstabugHttpLogger,
  InstabugHttpClient,
])
Future<void> main() async {
  const Map<String, String> fakeResponse = <String, String>{
    'id': '123',
    'activationCode': '111111',
  };
  late Uri url;
  final http.Response mockedResponse =
      http.Response(json.encode(fakeResponse), 200);

  setUp(() {
    url = Uri.parse('http://www.instabug.com');
  });

  InstabugHttpClient buildClient({http.Client? mockClient}) {
    final InstabugHttpClient instabugHttpClient =
        InstabugHttpClient(client: mockClient ?? MockInstabugHttpClient());
    instabugHttpClient.logger = MockInstabugHttpLogger();

    return instabugHttpClient;
  }

  test('expect instabug http client GET to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.get(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.get(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client HEAD to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.head(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.head(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client DELETE to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.delete(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.delete(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client PATCH to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.patch(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.patch(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client POST to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.post(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.post(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result, mockedResponse);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client PUT to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.put(url))
        .thenAnswer((_) async => mockedResponse);
    final http.Response result = await instabugHttpClient.put(url);
    expect(result, isInstanceOf<http.Response>());
    expect(result.body, mockedResponse.body);
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(1);
  });

  test('expect instabug http client READ to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    const String response = 'Some response string';
    when<dynamic>(instabugHttpClient.client.read(url))
        .thenAnswer((_) async => response);

    final String result = await instabugHttpClient.read(url);
    expect(result, isInstanceOf<String>());
    expect(result, response);
  });

  test('expect instabug http client READBYTES to return response', () async {
    final Uint8List response = Uint8List(3);
    final InstabugHttpClient instabugHttpClient = buildClient(mockClient: MockClient((_) async => http.Response.bytes(response, 200)));

    final Uint8List result = await instabugHttpClient.readBytes(url);
    expect(result, isInstanceOf<Uint8List>());
    expect(result, response);
  });

  test('expect instabug http client SEND to return response', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    final http.StreamedResponse response = http.StreamedResponse(
        const Stream<List<int>>.empty(), 200,
        contentLength: 0);
    final http.StreamedRequest request = http.StreamedRequest('POST', url)
      ..headers[HttpHeaders.contentTypeHeader] =
          'application/json; charset=utf-8'
      ..headers[HttpHeaders.userAgentHeader] = 'Dart';
    when<dynamic>(instabugHttpClient.client.send(request))
        .thenAnswer((_) async => response);
    final Future<http.StreamedResponse> responseFuture =
        instabugHttpClient.send(request);
    request
      ..sink.add('{"hello": "world"}'.codeUnits)
      ..sink.close();

    final http.StreamedResponse result = await responseFuture;
    expect(result, isInstanceOf<http.StreamedResponse>());
    expect(result.headers, response.headers);
    expect(result.statusCode, response.statusCode);
    expect(result.contentLength, response.contentLength);
    expect(result.isRedirect, response.isRedirect);
    expect(result.persistentConnection, response.persistentConnection);
    expect(result.reasonPhrase, response.reasonPhrase);
    expect(result.request, response.request);
    expect(await result.stream.bytesToString(),
        await response.stream.bytesToString());
    final MockInstabugHttpLogger logger =
        instabugHttpClient.logger as MockInstabugHttpLogger;
    verify(logger.onLogger(any, startTime: anyNamed('startTime'))).called(1);
  });

  test('expect instabug http client CLOSE to be called', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    instabugHttpClient.close();

    verify(instabugHttpClient.client.close());
  });

  test('stress test for GET method', () async {
    final InstabugHttpClient instabugHttpClient = buildClient();
    when<dynamic>(instabugHttpClient.client.get(url))
        .thenAnswer((_) async => mockedResponse);
    for (int i = 0; i < 10000; i++) {
      await instabugHttpClient.get(url);
    }
    verify(instabugHttpClient.logger
            .onLogger(mockedResponse, startTime: anyNamed('startTime')))
        .called(10000);
  });
}
