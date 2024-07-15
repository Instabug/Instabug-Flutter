class NetworkData {
  const NetworkData({
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
    this.isW3cHeaderFound,
    this.partialId,
    this.networkStartTimeInSeconds,
    this.w3CGeneratedHeader,
    this.w3CCaughtHeader,
  });

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

  final bool? isW3cHeaderFound;
  final num? partialId;
  final num? networkStartTimeInSeconds;
  final String? w3CGeneratedHeader;
  final String? w3CCaughtHeader;

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
    bool? isW3cHeaderFound,
    num? partialId,
    num? networkStartTimeInSeconds,
    String? w3CGeneratedHeader,
    String? w3CCaughtHeader,
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
        isW3cHeaderFound: isW3cHeaderFound ?? this.isW3cHeaderFound,
        partialId: partialId ?? this.partialId,
        networkStartTimeInSeconds:
            networkStartTimeInSeconds ?? this.networkStartTimeInSeconds,
        w3CCaughtHeader: w3CGeneratedHeader ?? this.w3CCaughtHeader,
        w3CGeneratedHeader: w3CGeneratedHeader ?? this.w3CGeneratedHeader,);
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
      "isW3cHeaderFound": isW3cHeaderFound,
      "partialId": partialId,
      "networkStartTimeInSeconds": networkStartTimeInSeconds,
      "w3CGeneratedHeader": w3CGeneratedHeader,
      "w3CCaughtHeader": w3CCaughtHeader,
    };
  }
}
