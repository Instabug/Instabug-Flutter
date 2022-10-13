// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/generated/instabug_log.api.g.dart';

class InstabugLog {
  static final _native = InstabugLogApi();

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logVerbose(String message) async {
    return _native.logVerbose(message);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logDebug(String message) async {
    return _native.logDebug(message);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logInfo(String message) async {
    return _native.logInfo(message);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logWarn(String message) async {
    return _native.logWarn(message);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logError(String message) async {
    return _native.logError(message);
  }

  /// Clears Instabug internal log
  static Future<void> clearAllLogs() async {
    return _native.clearAllLogs();
  }
}
