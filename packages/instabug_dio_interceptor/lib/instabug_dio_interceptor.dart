import 'package:dio/dio.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

class InstabugDioInterceptor extends Interceptor {
  static final Map<int, NetworkData> _requests = <int, NetworkData>{};
  static final NetworkLogger _networklogger = NetworkLogger();
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final NetworkData data = NetworkData(
        startTime: DateTime.now(),
        url: options.uri.toString(),
        method: options.method);
    _requests[options.hashCode] = data;
    handler.next(options);
  }

  @override
  void onResponse(
      Response<dynamic> response, ResponseInterceptorHandler handler) {
    final NetworkData data = _map(response);
    _networklogger.networkLog(data);
    handler.next(response);
  }

  @override
  // Keep `DioError` instead of `DioException` for backward-compatibility, for now.
  // ignore: deprecated_member_use
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (err.response != null) {
      final NetworkData data = _map(err.response!);
      _networklogger.networkLog(data);
    }

    handler.next(err);
  }

  static NetworkData _getRequestData(int requestHashCode) {
    final NetworkData data = _requests[requestHashCode]!;
    _requests.remove(requestHashCode);
    return data;
  }

  NetworkData _map(Response<dynamic> response) {
    final NetworkData data = _getRequestData(response.requestOptions.hashCode);
    final Map<String, dynamic> responseHeaders = <String, dynamic>{};
    final DateTime endTime = DateTime.now();

    response.headers
        .forEach((String name, dynamic value) => responseHeaders[name] = value);

    String responseContentType = '';
    if (responseHeaders.containsKey('content-type')) {
      responseContentType = responseHeaders['content-type'].toString();
    }

    int requestBodySize = 0;
    if (response.requestOptions.headers.containsKey('content-length')) {
      requestBodySize =
          int.parse(response.requestOptions.headers['content-length'] ?? '0');
    } else if (response.requestOptions.data != null) {
      requestBodySize = response.requestOptions.data.toString().length;
    }

    int responseBodySize = 0;
    if (responseHeaders.containsKey('content-length')) {
      responseBodySize = int.parse(responseHeaders['content-length'][0] ?? '0');
    } else if (response.data != null) {
      responseBodySize = response.data.toString().length;
    }

    return data.copyWith(
      endTime: endTime,
      duration: endTime.difference(data.startTime).inMicroseconds,
      url: response.requestOptions.uri.toString(),
      method: response.requestOptions.method,
      requestBody: response.requestOptions.data.toString(),
      requestHeaders: response.requestOptions.headers,
      requestContentType: response.requestOptions.contentType,
      requestBodySize: requestBodySize,
      status: response.statusCode,
      responseBody: response.data.toString(),
      responseHeaders: responseHeaders,
      responseContentType: responseContentType,
      responseBodySize: responseBodySize,
    );
  }
}
