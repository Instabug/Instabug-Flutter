import 'package:instabug_flutter/src/models/w3c_header.dart';

class NetworkData {
  NetworkData({
    required this.url,
    required this.method,
    this.requestBody = '',
    this.responseBody = '',
    this.requestBodySize = 0,
    this.responseBodySize = 0,
    this.status,
    this.requestHeaders = const <String, dynamic>{},
    this.responseHeaders = const <String, dynamic>{},
    this.duration,
    this.requestContentType = '',
    this.responseContentType = '',
    this.endTime,
    required this.startTime,
    this.errorCode = 0,
    this.errorDomain = '',
    W3CHeader? w3cHeader,
  }) {
    _w3cHeader = w3cHeader;
  }

  final String url;
  final String method;
  final String requestBody;
  final String responseBody;
  final int requestBodySize;
  final int responseBodySize;
  final int? status;
  final Map<String, dynamic> requestHeaders;
  final Map<String, dynamic> responseHeaders;
  final int? duration;
  final String? requestContentType;
  final String? responseContentType;
  final DateTime? endTime;
  final DateTime startTime;
  final int errorCode;
  final String errorDomain;
  W3CHeader? _w3cHeader;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NetworkData &&
          runtimeType == other.runtimeType &&
          url == other.url &&
          method == other.method &&
          requestBody == other.requestBody &&
          responseBody == other.responseBody &&
          requestBodySize == other.requestBodySize &&
          responseBodySize == other.responseBodySize &&
          status == other.status &&
          requestHeaders == other.requestHeaders &&
          responseHeaders == other.responseHeaders &&
          duration == other.duration &&
          requestContentType == other.requestContentType &&
          responseContentType == other.responseContentType &&
          endTime == other.endTime &&
          startTime == other.startTime &&
          errorCode == other.errorCode &&
          errorDomain == other.errorDomain &&
          _w3cHeader == other._w3cHeader;

  @override
  int get hashCode =>
      url.hashCode ^
      method.hashCode ^
      requestBody.hashCode ^
      responseBody.hashCode ^
      requestBodySize.hashCode ^
      responseBodySize.hashCode ^
      status.hashCode ^
      requestHeaders.hashCode ^
      responseHeaders.hashCode ^
      duration.hashCode ^
      requestContentType.hashCode ^
      responseContentType.hashCode ^
      endTime.hashCode ^
      startTime.hashCode ^
      errorCode.hashCode ^
      errorDomain.hashCode ^
      _w3cHeader.hashCode;

  NetworkData copyWith({
    String? url,
    String? method,
    String? requestBody,
    String? responseBody,
    int? requestBodySize,
    int? responseBodySize,
    int? status,
    Map<String, dynamic>? requestHeaders,
    Map<String, dynamic>? responseHeaders,
    int? duration,
    String? requestContentType,
    String? responseContentType,
    DateTime? endTime,
    DateTime? startTime,
    int? errorCode,
    String? errorDomain,
    W3CHeader? w3cHeader,
  }) {
    return NetworkData(
      url: url ?? this.url,
      method: method ?? this.method,
      requestBody: requestBody ?? this.requestBody,
      responseBody: responseBody ?? this.responseBody,
      requestBodySize: requestBodySize ?? this.requestBodySize,
      responseBodySize: responseBodySize ?? this.responseBodySize,
      status: status ?? this.status,
      requestHeaders: requestHeaders ?? this.requestHeaders,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      duration: duration ?? this.duration,
      requestContentType: requestContentType ?? this.requestContentType,
      responseContentType: responseContentType ?? this.responseContentType,
      endTime: endTime ?? this.endTime,
      startTime: startTime ?? this.startTime,
      errorCode: errorCode ?? this.errorCode,
      errorDomain: errorDomain ?? this.errorDomain,
      w3cHeader: w3cHeader ?? _w3cHeader,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
      'method': method,
      'requestBody': requestBody,
      'responseBody': responseBody,
      'responseCode': status,
      'requestHeaders':
          requestHeaders.map((key, value) => MapEntry(key, value.toString())),
      'responseHeaders':
          responseHeaders.map((key, value) => MapEntry(key, value.toString())),
      'requestContentType': requestContentType,
      'responseContentType': responseContentType,
      'duration': duration,
      'startTime': startTime.millisecondsSinceEpoch,
      'requestBodySize': requestBodySize,
      'responseBodySize': responseBodySize,
      'errorDomain': errorDomain,
      'errorCode': errorCode,
      "isW3cHeaderFound": _w3cHeader?.isW3cHeaderFound,
      "partialId": _w3cHeader?.partialId,
      "networkStartTimeInSeconds": _w3cHeader?.networkStartTimeInSeconds,
      "w3CGeneratedHeader": _w3cHeader?.w3CGeneratedHeader,
      "w3CCaughtHeader": _w3cHeader?.w3CCaughtHeader,
    };
  }
}
