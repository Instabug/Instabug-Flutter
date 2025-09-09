import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

class InstabugDioInterceptor extends Interceptor {
  static final Map<int, NetworkData> _requests = <int, NetworkData>{};
  static final NetworkLogger _networklogger = NetworkLogger();

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final headers = options.headers;
    final startTime = DateTime.now();
    // ignore: invalid_use_of_internal_member
    final w3Header = await _networklogger.getW3CHeader(
      headers,
      startTime.millisecondsSinceEpoch,
    );
    if (w3Header?.isW3cHeaderFound == false &&
        w3Header?.w3CGeneratedHeader != null) {
      headers['traceparent'] = w3Header?.w3CGeneratedHeader;
    }
    options.headers = headers;
    final data = NetworkData(
      startTime: startTime,
      url: options.uri.toString(),
      w3cHeader: w3Header,
      method: options.method,
    );
    _requests[options.hashCode] = data;
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    final data = _map(response);
    _networklogger.networkLog(data);
    handler.next(response);
  }

  @override
  // Keep `DioError` instead of `DioException` for backward-compatibility, for now.
  // ignore: deprecated_member_use
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final data = _map(err.response!);
      _networklogger.networkLog(data);
    }

    handler.next(err);
  }

  static NetworkData _getRequestData(int requestHashCode) {
    final data = _requests[requestHashCode];
    if(data==null){
      if (kDebugMode) {
        print("IBG: No request Data for this Response");
      }
      return  NetworkData(
        startTime: DateTime.now(),
        url: "No request Data",
        method: "No Request Data",
      );
    }
    // _requests.remove(requestHashCode);
    return data;
  }

  NetworkData _map(Response<dynamic> response) {
    final data = _getRequestData(response.requestOptions.hashCode);
    final responseHeaders = <String, dynamic>{};
    final endTime = DateTime.now();

    response.headers
        .forEach((String name, dynamic value) => responseHeaders[name] = value);

    var responseContentType = '';
    if (responseHeaders.containsKey('content-type')) {
      responseContentType = responseHeaders['content-type'].toString();
    }

    var requestBodySize = 0;
    if (response.requestOptions.headers.containsKey('content-length')) {
      requestBodySize =
          int.parse(response.requestOptions.headers['content-length'] ?? '0');
    } else if (response.requestOptions.data != null) {
      // Calculate actual byte size for more accurate size estimation
      requestBodySize = _calculateBodySize(response.requestOptions.data);
    }

    var responseBodySize = 0;
    if (responseHeaders.containsKey('content-length')) {
      // ignore: avoid_dynamic_calls
      responseBodySize = int.parse(responseHeaders['content-length'][0] ?? '0');
    } else if (response.data != null) {
      // Calculate actual byte size for more accurate size estimation
      responseBodySize = _calculateBodySize(response.data);
    }

    return data.copyWith(
      endTime: endTime,
      duration: endTime.difference(data.startTime).inMicroseconds,
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      requestBody: parseBody(response.requestOptions.data),
      requestHeaders: response.requestOptions.headers,
      requestContentType: response.requestOptions.contentType,
      requestBodySize: requestBodySize,
      status: response.statusCode,
      responseBody: parseBody(response.data),
      responseHeaders: responseHeaders,
      responseContentType: responseContentType,
      responseBodySize: responseBodySize,
    );
  }

  String parseBody(dynamic data) {
    try {
      return jsonEncode(data);
    } catch (e) {
      return data.toString();
    }
  }

  /// Calculates the actual byte size of the body data
  int _calculateBodySize(dynamic data) {
    if (data == null) return 0;

    try {
      // For string data, get UTF-8 byte length
      if (data is String) {
        return data.codeUnits.length;
      }

      // For other types, try to encode as JSON and get byte length
      final jsonString = jsonEncode(data);
      return jsonString.codeUnits.length;
    } catch (e) {
      // Fallback to string conversion if JSON encoding fails
      return data.toString().codeUnits.length;
    }
  }
}
