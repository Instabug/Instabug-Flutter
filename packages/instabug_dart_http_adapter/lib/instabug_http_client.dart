library instabug_http_client;

import 'dart:convert';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:instabug_http_client/instabug_http_logger.dart';
import 'package:meta/meta.dart';

class InstabugHttpClient extends InstabugHttpLogger implements http.Client {
  InstabugHttpClient() : client = http.Client() {
    logger = this;
  }
  @visibleForTesting
  http.Client client;

  @visibleForTesting
  late InstabugHttpLogger logger;

  @override
  void close() => client.close();

  @override
  Future<http.Response> delete(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    final DateTime startTime = DateTime.now();
    return client
        .delete(url, body: body, headers: headers, encoding: encoding)
        .then((http.Response response) {
      logger.onLogger(response, startTime: startTime);
      return response;
    });
  }

  @override
  Future<http.Response> get(Uri url, {Map<String, String>? headers}) {
    final DateTime startTime = DateTime.now();
    return client.get(url, headers: headers).then((http.Response response) {
      logger.onLogger(response, startTime: startTime);
      return response;
    });
  }

  @override
  Future<http.Response> head(Uri url, {Map<String, String>? headers}) {
    final DateTime startTime = DateTime.now();
    return client.head(url, headers: headers).then((http.Response response) {
      logger.onLogger(response, startTime: startTime);
      return response;
    });
  }

  @override
  Future<http.Response> patch(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    final DateTime startTime = DateTime.now();
    return client
        .patch(url, headers: headers, body: body, encoding: encoding)
        .then((http.Response response) {
      logger.onLogger(response, startTime: startTime);
      return response;
    });
  }

  @override
  Future<http.Response> post(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    final DateTime startTime = DateTime.now();
    return client
        .post(url, headers: headers, body: body, encoding: encoding)
        .then((http.Response response) {
      logger.onLogger(response, startTime: startTime);
      return response;
    });
  }

  @override
  Future<http.Response> put(Uri url,
      {Map<String, String>? headers, Object? body, Encoding? encoding}) {
    final DateTime startTime = DateTime.now();
    return client
        .put(url, headers: headers, body: body, encoding: encoding)
        .then((http.Response response) {
      logger.onLogger(response, startTime: startTime);
      return response;
    });
  }

  @override
  Future<String> read(Uri url, {Map<String, String>? headers}) =>
      client.read(url, headers: headers);

  @override
  Future<Uint8List> readBytes(Uri url, {Map<String, String>? headers}) =>
      client.readBytes(url, headers: headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    final DateTime startTime = DateTime.now();
    return client.send(request).then((http.StreamedResponse streamedResponse) =>
        http.Response.fromStream(streamedResponse)
            .then((http.Response response) {
          logger.onLogger(response, startTime: startTime);
          // Need to return new StreamedResponse, as body only can be listened once
          return http.StreamedResponse(
            Stream<List<int>>.value(response.bodyBytes),
            response.statusCode,
            contentLength: response.contentLength,
            request: response.request,
            headers: response.headers,
            isRedirect: response.isRedirect,
            persistentConnection: response.persistentConnection,
            reasonPhrase: response.reasonPhrase,
          );
        }));
  }
}
