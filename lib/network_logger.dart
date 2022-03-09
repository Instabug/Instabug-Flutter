import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/apm.dart';
import 'package:instabug_flutter/models/network_data.dart';

class NetworkLogger {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  Future<bool?> networkLog(NetworkData data) async {
    final params = <dynamic>[data.toMap()];
    await _channel.invokeMethod<bool>('networkLog:', params);
    await APM.networkLogAndroid(data);
  }
}
