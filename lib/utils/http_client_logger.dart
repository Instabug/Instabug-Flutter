import 'dart:io';

import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/models/network_data.dart';


class HttpClientLogger {

  Map<int, NetworkData> requests = <int, NetworkData>{};

  NetworkData _getRequestData(int requestHashCode) {
    if (requests[requestHashCode] != null) {
      return requests.remove(requestHashCode);
    }
    return null;
  }

  void onRequest(HttpClientRequest request, { dynamic requestBody }) {
    final NetworkData requestData = NetworkData();
    requestData.startTime = DateTime.now();
    requestData.method = request.method;
    requestData.url = request.uri.toString();
    request.headers.forEach((String header, dynamic value) {
      requestData.requestHeaders[header] = value[0];
    });
    if (requestBody != null) {
      requestData.requestBody = requestBody;
    }
    requests[request.hashCode] = requestData;
  }

  void onResponse(HttpClientResponse response, HttpClientRequest request, {dynamic responseBody}) {
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

    NetworkLogger.networkLog(networkData);

  }

}