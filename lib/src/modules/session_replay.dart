// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/generated/session_replay.api.g.dart';

class SessionReplay {
  static var _host = SessionReplayHostApi();

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(SessionReplayHostApi host) {
    _host = host;
  }

  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  static Future<void> setNetworkLogsEnabled(bool isEnabled) async {
    return _host.setNetworkLogsEnabled(isEnabled);
  }

  static Future<void> setInstabugLogsEnabled(bool isEnabled) async {
    return _host.setInstabugLogsEnabled(isEnabled);
  }

  static Future<void> setUserStepsEnabled(bool isEnabled) async {
    return _host.setUserStepsEnabled(isEnabled);
  }
}
