import 'dart:async';

import 'package:flutter/services.dart';

import '../models/network_data.dart';
import 'apm.dart';

class NetworkLogger {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  Future<bool?> networkLog(NetworkData data) async {
    await _channel.invokeMethod<bool>(
      'networkLog:',
      [data.toMap()],
    );
    
    return APM.networkLogAndroid(data);
  }
}
