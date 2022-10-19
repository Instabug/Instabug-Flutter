// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';

class NetworkLogger {
  static final _native = InstabugHostApi();

  Future<void> networkLog(NetworkData data) async {
    await _native.networkLog(data.toMap());
    await APM.networkLogAndroid(data);
  }
}
