// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';

class NetworkLogger {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion =>
      _channel.invokeMethod<String>('getPlatformVersion');

  Future<bool?> networkLog(NetworkData data) async {
    final params = <dynamic>[data.toMap()];
    await _channel.invokeMethod<bool>('networkLog:', params);
    await APM.networkLogAndroid(data);
  }
}
