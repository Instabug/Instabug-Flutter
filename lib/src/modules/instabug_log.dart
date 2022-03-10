import 'dart:async';

import 'package:flutter/services.dart';

class InstabugLog {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logError(String message) async {
    return _channel.invokeMethod(
      'logError:',
      [message],
    );
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logWarn(String message) async {
    return _channel.invokeMethod(
      'logWarn:',
      [message],
    );
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logVerbose(String message) async {
    return _channel.invokeMethod(
      'logVerbose:',
      [message],
    );
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logDebug(String message) async {
    return _channel.invokeMethod(
      'logDebug:',
      [message],
    );
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logInfo(String message) async {
    return _channel.invokeMethod(
      'logInfo:',
      [message],
    );
  }

  /// Clears Instabug internal log
  static Future<void> clearAllLogs() async {
    return _channel.invokeMethod('clearAllLogs');
  }
}
