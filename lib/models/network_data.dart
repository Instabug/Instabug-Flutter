class NetworkData {
  const NetworkData(
      {required this.url,
      required this.method,
      this.requestBody = '',
      this.responseBody = '',
      this.requestBodySize = 0,
      this.responseBodySize = 0,
      this.status,
      this.requestHeaders = const <String, dynamic>{},
      this.responseHeaders = const <String, dynamic>{},
      this.duration,
      this.contentType = '',
      this.endTime,
      required this.startTime,
      this.errorCode = 0,
      this.errorDomain = ''});

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
  final String? contentType;
  final DateTime? endTime;
  final DateTime startTime;
  final int errorCode;
  final String errorDomain;

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
    String? contentType,
    DateTime? endTime,
    DateTime? startTime,
    int? errorCode,
    String? errorDomain,
  }) =>
      NetworkData(
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
        contentType: contentType ?? this.contentType,
        endTime: endTime ?? this.endTime,
        startTime: startTime ?? this.startTime,
        errorCode: errorCode ?? this.errorCode,
        errorDomain: errorDomain ?? this.errorDomain,
      );

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['url'] = url;
    map['method'] = method;
    map['requestBody'] = requestBody;
    map['responseBody'] = responseBody;
    map['responseCode'] = status;
    map['requestHeaders'] = requestHeaders;
    map['responseHeaders'] = responseHeaders;
    map['contentType'] = contentType;
    map['duration'] = duration;
    map['startTime'] = startTime.millisecondsSinceEpoch;
    map['requestBodySize'] = requestBodySize;
    map['responseBodySize'] = responseBodySize;
    map['errorDomain'] = errorDomain;
    map['errorCode'] = errorCode;
    return map;
  }
}
