import 'dart:async';

import 'package:flutter/services.dart';

import '../models/network_data.dart';
import 'apm.dart';

class NetworkLogger {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  Future<bool?> networkLog(NetworkData data) async {
    final params = <dynamic>[data.toMap()];
    await _channel.invokeMethod<bool>('networkLog:', params);
    await APM.networkLogAndroid(data);
  }
}
