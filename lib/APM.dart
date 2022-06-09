// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/models/network_data.dart';
import 'package:instabug_flutter/models/trace.dart';
import 'package:instabug_flutter/utils/ibg_build_info.dart';
import 'package:instabug_flutter/utils/ibg_date_time.dart';

enum LogLevel {
  none,
  error,
  warning,
  info,
  debug,
  verbose,
}

class APM {
  static Function _startExecutionTraceCallback = () {};
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion async =>
      await _channel.invokeMethod<String>('getPlatformVersion');

  /// Enables or disables APM feature.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setAPMEnabled:', params);
  }

  /// Sets log Level to determine level of details in a log
  /// [logLevel] Enum value to determine the level
  static Future<void> setLogLevel(LogLevel logLevel) async {
    final List<dynamic> params = <dynamic>[logLevel.toString()];
    await _channel.invokeMethod<Object>('setAPMLogLevel:', params);
  }

  /// Enables or disables cold app launch tracking.
  /// [boolean] isEnabled
  static Future<void> setColdAppLaunchEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setColdAppLaunchEnabled:', params);
  }

  /// Starts an execution trace.
  /// [String] name of the trace.
  static Future<Trace> startExecutionTrace(String name) async {
    final DateTime id = IBGDateTime.instance.now();
    final List<dynamic> params = <dynamic>[name, id.toString()];
    final traceId =
        await _channel.invokeMethod<String?>('startExecutionTrace:id:', params);

    if (traceId == null) {
      return Future.error(
        "Execution trace $name wasn't created. Please make sure to enable APM first by following "
        'the instructions at this link: https://docs.instabug.com/reference#enable-or-disable-apm',
      );
    }

    return Trace(traceId, name);
  }

  /// Sets attribute of an execution trace.
  /// [String] id of the trace.
  /// [String] key of attribute.
  /// [String] value of attribute.
  static Future<void> setExecutionTraceAttribute(
      String id, String key, String value) async {
    final List<dynamic> params = <dynamic>[
      id.toString(),
      key.toString(),
      value.toString(),
    ];
    await _channel.invokeMethod<Object>(
        'setExecutionTraceAttribute:key:value:', params);
  }

  /// Ends an execution trace.
  /// [String] id of the trace.
  static Future<void> endExecutionTrace(String id) async {
    final List<dynamic> params = <dynamic>[id];
    await _channel.invokeMethod<Object>('endExecutionTrace:', params);
  }

  /// Enables or disables auto UI tracing.
  /// [boolean] isEnabled
  static Future<void> setAutoUITraceEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setAutoUITraceEnabled:', params);
  }

  /// Starts UI trace.
  /// [String] name
  static Future<void> startUITrace(String name) async {
    final List<dynamic> params = <dynamic>[name];
    await _channel.invokeMethod<Object>('startUITrace:', params);
  }

  /// Ends UI trace.
  static Future<void> endUITrace() async {
    await _channel.invokeMethod<Object>('endUITrace');
  }

  /// Ends UI trace.
  static void endAppLaunch() async {
    await _channel.invokeMethod<Object>('endAppLaunch');
  }

  static Future<bool?> networkLogAndroid(NetworkData data) async {
    if (IBGBuildInfo.instance.isAndroid) {
      final params = <dynamic>[data.toMap()];
      return await _channel.invokeMethod<bool>(
          'apmNetworkLogByReflection:', params);
    }
  }
}
