import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:instabug_flutter/instabug_flutter.dart';

class InstabugHttpLogger {
  void onLogger(
    http.Response response, {
    DateTime? startTime,
    W3CHeader? w3CHeader,
  }) {
    final networkLogger = NetworkLogger();

    final requestHeaders = <String, dynamic>{};
    response.request?.headers.forEach((String header, dynamic value) {
      requestHeaders[header] = value;
    });

    final request = response.request;

    if (request == null) {
      return;
    }
    final requestBody = request is http.MultipartRequest
        ? json.encode(request.fields)
        : request is http.Request
            ? request.body
            : '';

    final requestData = NetworkData(
      startTime: startTime!,
      method: request.method,
      url: request.url.toString(),
      requestHeaders: requestHeaders,
      requestBody: requestBody,
      w3cHeader: w3CHeader,
    );

    final endTime = DateTime.now();

    final responseHeaders = <String, dynamic>{};
    response.headers.forEach((String header, dynamic value) {
      responseHeaders[header] = value;
    });
    var requestBodySize = 0;
    if (requestHeaders.containsKey('content-length')) {
      requestBodySize = int.parse(requestHeaders['content-length'] ?? '0');
    } else {
      // Calculate actual byte size for more accurate size estimation
      requestBodySize = _calculateBodySize(requestBody);
    }

    var responseBodySize = 0;
    if (responseHeaders.containsKey('content-length')) {
      responseBodySize = int.parse(responseHeaders['content-length'] ?? '0');
    } else {
      // Calculate actual byte size for more accurate size estimation
      responseBodySize = _calculateBodySize(response.body);
    }

    networkLogger.networkLog(
      requestData.copyWith(
        status: response.statusCode,
        duration: endTime.difference(requestData.startTime).inMicroseconds,
        responseContentType: response.headers.containsKey('content-type')
            ? response.headers['content-type']
            : '',
        responseHeaders: responseHeaders,
        responseBody: response.body,
        requestBodySize: requestBodySize,
        responseBodySize: responseBodySize,
        requestContentType: request.headers.containsKey('content-type')
            ? request.headers['content-type']
            : '',
      ),
    );
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
