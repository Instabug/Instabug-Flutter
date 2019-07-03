import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:instabug/models/network_data.dart';
import 'package:instabug/utils/http_client_parser.dart';

class NetworkLogger {

  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Attaches request data for a network request performed by httpClient.
  /// [HttpClientRequest] request
  /// [dynamic] requestBody 
  static void logHttpClientRequest(HttpClientRequest request, { dynamic requestBody }) {   
    HttpClientParser.onRequest(request, requestBody: requestBody);
  }

   /// Attaches response data for a network request performed by httpClient.
  /// [HttpClientResponse] response
  /// [HttpClientRequest] request
  /// [dynamic] responseBody
  static void logHttpClientResponse(HttpClientResponse response,  HttpClientRequest request, { dynamic responseBody }) async {
    final NetworkData data = HttpClientParser.onResponse(response, request, responseBody: responseBody);
    networkLog(data);
  }

  static Future<bool> networkLog(NetworkData data) async {
    final List<dynamic> params = <dynamic>[data.toMap()];
    return await _channel.invokeMethod<Object>('networkLog:', params);
  }

}
