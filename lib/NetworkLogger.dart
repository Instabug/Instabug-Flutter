import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/models/network_data.dart';

class NetworkLogger {

  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<bool> networkLog(NetworkData data) async {
    final List<dynamic> params = <dynamic>[data.toMap()];
    return await _channel.invokeMethod<Object>('networkLog:', params);
  }

}
