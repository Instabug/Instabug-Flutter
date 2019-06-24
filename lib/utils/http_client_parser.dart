import 'dart:io';

import 'package:instabug/models/network_data.dart';


class HttpClientParser {

  static List<NetworkData> requests = <NetworkData>[];

  static NetworkData _getRequestData(int requestHashCode) {
    for (NetworkData request in requests) {
      if (request.requestHashCode == requestHashCode) {
        return request;
      }
    }
    return null;
  }

  static void onRequest(HttpClientRequest request, { dynamic requestBody }) {
    final NetworkData requestData = NetworkData();
    requestData.startTime = DateTime.now();
    requestData.requestHashCode = request.hashCode;
    requestData.method = request.method;
    requestData.url = request.uri.toString();
    request.headers.forEach((String header, dynamic value) {
      requestData.requestHeaders[header] = value[0];
    });
    if (requestBody != null) {
      requestData.requestBody = requestBody;
    }
    requests.add(requestData);
  }

  static NetworkData onResponse(HttpClientResponse response, HttpClientRequest request, {dynamic responseBody}) {
    final DateTime endTime = DateTime.now();
    final NetworkData networkData = _getRequestData(request.hashCode);

    if (networkData == null) {
      return null;
    }

    networkData.status = response.statusCode;
    networkData.duration = endTime.difference(networkData.startTime).inMilliseconds;
    if (response.headers.contentType != null) {
      networkData.contentType = response.headers.contentType.value;
    }

    response.headers.forEach((String header, dynamic value) {
      networkData.responseHeaders[header] = value[0];
    });

    if (responseBody != null) {
      networkData.responseBody = responseBody;
    }

    return networkData;

  }

}