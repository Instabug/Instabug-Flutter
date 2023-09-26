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
  /// Session Replay allows you to capture user interactions with your app
  /// for analysis and debugging. By default, Session Replay is enabled if
  /// it is available in your current plan.
  ///
  /// Example:
  ///
  /// ```dart
  /// SessionReplay.setEnabled(true); // Enable Session Replay
  /// SessionReplay.setEnabled(false); // Disable Session Replay
  /// ```
  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  /// Enables or disables network logs for Session Replay.
  ///
  /// Network logs include details of network requests and responses made
  /// during a session. By default, network logs are enabled.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setNetworkLogsEnabled(true); // Enable network logs
  /// await SessionReplay.setNetworkLogsEnabled(false); // Disable network logs
  /// ```
  static Future<void> setNetworkLogsEnabled(bool isEnabled) async {
    return _host.setNetworkLogsEnabled(isEnabled);
  }

  /// Enables or disables Instabug internal logs for Session Replay.
  ///
  /// Instabug logs include internal debugging information. By default,
  /// Instabug logs are enabled.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setInstabugLogsEnabled(true); // Enable Instabug logs
  /// await SessionReplay.setInstabugLogsEnabled(false); // Disable Instabug logs
  /// ```
  static Future<void> setInstabugLogsEnabled(bool isEnabled) async {
    return _host.setInstabugLogsEnabled(isEnabled);
  }

  /// Enables or disables capturing of user steps  for Session Replay.
  ///
  /// User steps are a sequence of interactions performed by the user
  /// within the app. By default, user steps are enabled.
  ///
  /// Example:
  ///
  /// ```dart
  /// await SessionReplay.setUserStepsEnabled(true); // Enable user steps
  /// await SessionReplay.setUserStepsEnabled(false); // Disable user steps
  /// ```
  static Future<void> setUserStepsEnabled(bool isEnabled) async {
    return _host.setUserStepsEnabled(isEnabled);
  }
}
