class NetworkData {
  String url;
  String method;
  dynamic requestBody = '';
  dynamic responseBody = '';
  int status;
  Map<String, dynamic> requestHeaders = <String, dynamic>{};
  Map<String, dynamic> responseHeaders = <String, dynamic>{};
  int duration;
  String contentType = '';
  DateTime endTime;
  DateTime startTime;

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = <String, dynamic>{};
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