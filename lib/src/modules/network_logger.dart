// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:meta/meta.dart';

class NetworkLogger {
  static var _host = InstabugHostApi();

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(InstabugHostApi host) {
    _host = host;
  }

  Future<void> networkLog(NetworkData data) async {
    await _host.networkLog(data.toJson());
    await APM.networkLogAndroid(data);
  }
}
