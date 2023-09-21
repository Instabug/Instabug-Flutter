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
  /// Instabug.setEnabled(true); // Enable Session Replay
  /// Instabug.setEnabled(false); // Disable Session Replay
  /// ```
  ///
  /// For more information, see [Enabling/Disabling Session Replay](https://docs.instabug.com/docs/android-session-replay#enablingdisabling-session-replay).
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
  /// await Instabug.setNetworkLogsEnabled(true); // Enable network logs
  /// await Instabug.setNetworkLogsEnabled(false); // Disable network logs
  /// ```
  ///
  /// For more information, see [Network Logs](https://docs.instabug.com/docs/android-session-replay#network).
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
  /// await Instabug.setInstabugLogsEnabled(true); // Enable Instabug logs
  /// await Instabug.setInstabugLogsEnabled(false); // Disable Instabug logs
  /// ```
  ///
  /// For more information, see [Instabug Logs](https://docs.instabug.com/docs/android-session-replay#instabug-logs).
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
  /// await Instabug.setUserStepsEnabled(true); // Enable user steps
  /// await Instabug.setUserStepsEnabled(false); // Disable user steps
  /// ```
  ///
  /// For more information, see [User Steps](https://docs.instabug.com/docs/android-session-replay#user-steps).
  static Future<void> setUserStepsEnabled(bool isEnabled) async {
    return _host.setUserStepsEnabled(isEnabled);
  }
}
