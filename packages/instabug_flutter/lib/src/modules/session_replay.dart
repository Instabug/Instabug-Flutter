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

  /// Enables or disables Session Replay for your Instabug integration.
  ///
  /// By default, Session Replay is enabled if it is available in your current plan.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setEnabled(true);
  /// ```
  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  /// Enables or disables network logs for Session Replay.
  /// By default, network logs are enabled.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setNetworkLogsEnabled(true);
  /// ```
  static Future<void> setNetworkLogsEnabled(bool isEnabled) async {
    return _host.setNetworkLogsEnabled(isEnabled);
  }

  /// Enables or disables Instabug logs for Session Replay.
  /// By default, Instabug logs are enabled.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setInstabugLogsEnabled(true);
  /// ```
  static Future<void> setInstabugLogsEnabled(bool isEnabled) async {
    return _host.setInstabugLogsEnabled(isEnabled);
  }

  /// Enables or disables capturing of user steps  for Session Replay.
  /// By default, user steps are enabled.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setUserStepsEnabled(true);
  /// ```
  static Future<void> setUserStepsEnabled(bool isEnabled) async {
    return _host.setUserStepsEnabled(isEnabled);
  }

  /// Retrieves current session's replay link.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.getSessionReplayLink();
  /// ```
  static Future<String> getSessionReplayLink() async {
    return _host.getSessionReplayLink();
  }
}
