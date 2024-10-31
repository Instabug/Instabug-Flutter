import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

class MockAdapter implements HttpClientAdapter {
  static const String mockHost = 'mockserver';
  static const String mockBase = 'http://$mockHost';
  final IOHttpClientAdapter _adapter = IOHttpClientAdapter();

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<dynamic>? cancelFuture,
  ) async {
    final uri = options.uri;

    if (uri.host == mockHost) {
      switch (uri.path) {
        case '/test':
          return ResponseBody.fromString(
            jsonEncode(<String, dynamic>{
              'errCode': 0,
              'data': <String, dynamic>{'path': uri.path},
            }),
            200,
          );

        default:
          return ResponseBody.fromString('', 404);
      }
    }
    return _adapter.fetch(options, requestStream, cancelFuture);
  }

  @override
  void close({bool force = false}) {
    _adapter.close(force: force);
  }
}
