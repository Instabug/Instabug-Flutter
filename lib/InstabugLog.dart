import 'dart:async';

import 'package:flutter/services.dart';

class InstabugLog {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logError(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logError:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logWarn(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logWarn:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logVerbose(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logVerbose:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logDebug(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logDebug:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static Future<void> logInfo(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logInfo:', params);
  }

  /// Clears Instabug internal log
  static Future<void> clearAllLogs() async {
    await _channel.invokeMethod<Object>('clearAllLogs');
  }
}
