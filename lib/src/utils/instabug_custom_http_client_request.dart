import 'dart:convert';
import 'dart:io';

import 'package:instabug_flutter/src/utils/http_client_logger.dart';

class InstabugCustomHttpClientRequest implements HttpClientRequest {
  InstabugCustomHttpClientRequest(this._originalClientRequest, this.logger) {
    bufferOutput = _originalClientRequest.bufferOutput;
    contentLength = _originalClientRequest.contentLength;
    encoding = _originalClientRequest.encoding;
    followRedirects = _originalClientRequest.followRedirects;
    maxRedirects = _originalClientRequest.maxRedirects;
    persistentConnection = _originalClientRequest.persistentConnection;
  }

  HttpClientRequest _originalClientRequest;

  StringBuffer _requestBody = StringBuffer();

  late HttpClientLogger logger;

  @override
  bool bufferOutput = true;

  @override
  int contentLength = -1;

  @override
  late Encoding encoding;

  @override
  bool followRedirects = true;

  @override
  int maxRedirects = 5;

  @override
  late bool persistentConnection;

  @override
  void abort([Object? exception, StackTrace? stackTrace]) {
    _originalClientRequest.abort([exception, stackTrace]);
  }

  @override
  void add(List<int> data) {
    _originalClientRequest.add(data);
  }

  @override
  void addError(Object error, [StackTrace? stackTrace]) {
    _originalClientRequest.addError(error, stackTrace);
  }

  @override
  Future addStream(Stream<List<int>> stream) {
    return _originalClientRequest.addStream(stream);
  }

  @override
  Future<HttpClientResponse> close() async {
    final response = await _originalClientRequest.close();
    logger.onResponse(response, _originalClientRequest);
    return response;
  }

  @override
  HttpConnectionInfo? get connectionInfo =>
      _originalClientRequest.connectionInfo;

  @override
  List<Cookie> get cookies => _originalClientRequest.cookies;

  @override
  Future<HttpClientResponse> get done => _originalClientRequest.done;

  @override
  Future flush() {
    return _originalClientRequest.flush();
  }

  @override
  HttpHeaders get headers => _originalClientRequest.headers;

  @override
  String get method => _originalClientRequest.method;

  @override
  Uri get uri => _originalClientRequest.uri;

  @override
  void write(Object? object) {
    _originalClientRequest.write(object);
    _requestBody.write(object);
    logger.onRequestUpdate(_originalClientRequest,
        requestBody: _requestBody.toString());
  }

  @override
  void writeAll(Iterable objects, [String separator = '']) {
    _originalClientRequest.writeAll(objects, separator);
    _requestBody.writeAll(objects, separator);
    logger.onRequestUpdate(_originalClientRequest,
        requestBody: _requestBody.toString());
  }

  @override
  void writeCharCode(int charCode) {
    _originalClientRequest.writeCharCode(charCode);
    _requestBody.writeCharCode(charCode);
    logger.onRequestUpdate(_originalClientRequest,
        requestBody: _requestBody.toString());
  }

  @override
  void writeln([Object? object = '']) {
    _originalClientRequest.writeln(object);
    _requestBody.writeln(object);
    logger.onRequestUpdate(_originalClientRequest,
        requestBody: _requestBody.toString());
  }
}
