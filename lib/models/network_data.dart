class NetworkData {
  const NetworkData({
    required this.url,
    required this.method,
    this.requestBody = '',
    this.responseBody = '',
    this.status,
    this.requestHeaders = const <String, dynamic>{},
    this.responseHeaders = const <String, dynamic>{},
    this.duration,
    this.contentType = '',
    this.endTime,
    required this.startTime,
  });

  final String url;
  final String method;
  final dynamic requestBody;
  final dynamic responseBody;
  final int? status;
  final Map<String, dynamic> requestHeaders;
  final Map<String, dynamic> responseHeaders;
  final int? duration;
  final String? contentType;
  final DateTime? endTime;
  final DateTime startTime;

  NetworkData copyWith({
    String? url,
    String? method,
    dynamic requestBody,
    dynamic responseBody,
    int? status,
    Map<String, dynamic>? requestHeaders,
    Map<String, dynamic>? responseHeaders,
    int? duration,
    String? contentType,
    DateTime? endTime,
    DateTime? startTime,
  }) =>
      NetworkData(
        url: url ?? this.url,
        method: method ?? this.method,
        requestBody: requestBody ?? this.requestBody,
        responseBody: responseBody ?? this.responseBody,
        status: status ?? this.status,
        requestHeaders: requestHeaders ?? this.requestHeaders,
        responseHeaders: responseHeaders ?? this.responseHeaders,
        duration: duration ?? this.duration,
        contentType: contentType ?? this.contentType,
        endTime: endTime ?? this.endTime,
        startTime: startTime ?? this.startTime,
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
    return map;
  }
}
