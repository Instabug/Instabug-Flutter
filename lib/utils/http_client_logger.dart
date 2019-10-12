import 'dart:io';

import 'package:instabug_flutter/NetworkLogger.dart';
import 'package:instabug_flutter/models/network_data.dart';


class HttpClientLogger {

  Future<void> logNetworkIoRequest(HttpClientRequest request, {
    DateTime startTime,
    dynamic requestBody,
    dynamic responseBody,
  }) async {
    final NetworkData networkData = NetworkData();
    networkData.method = request.method;
    networkData.url = request.uri.toString();
    request.headers.forEach((String header, dynamic value) {
      networkData.requestHeaders[header] = value[0];
    });
    networkData.requestBody = requestBody ?? networkData.requestBody;

    networkData.startTime = startTime ?? DateTime.now();
    final HttpClientResponse response = await request.done;
    final DateTime endTime = DateTime.now();

    networkData.status = response.statusCode;
    networkData.duration = endTime.difference(networkData.startTime).inMilliseconds;
    if (response.headers.contentType != null) {
      networkData.contentType = response.headers.contentType.value;
    }

    response.headers.forEach((String header, dynamic value) {
      networkData.responseHeaders[header] = value[0];
    });

    networkData.responseBody = responseBody ?? networkData.responseBody;

    NetworkLogger.networkLog(networkData);
  }

}