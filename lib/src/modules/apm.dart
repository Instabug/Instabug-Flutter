// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/models/trace.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';

enum LogLevel {
  none,
  error,
  warning,
  info,
  debug,
  verbose,
}

class APM {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion =>
      _channel.invokeMethod<String>('getPlatformVersion');

  /// Enables or disables APM feature.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    return _channel.invokeMethod('setAPMEnabled:', params);
  }

  /// Sets log Level to determine level of details in a log
  /// [logLevel] Enum value to determine the level
  static Future<void> setLogLevel(LogLevel logLevel) async {
    final params = <dynamic>[logLevel.toString()];
    return _channel.invokeMethod('setAPMLogLevel:', params);
  }

  /// Enables or disables cold app launch tracking.
  /// [boolean] isEnabled
  static Future<void> setColdAppLaunchEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    return _channel.invokeMethod('setColdAppLaunchEnabled:', params);
  }

  /// Starts an execution trace.
  /// [String] name of the trace.
  static Future<Trace> startExecutionTrace(String name) async {
    final id = IBGDateTime.instance.now();
    final params = <dynamic>[name, id.toString()];
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
    String id,
    String key,
    String value,
  ) async {
    final params = <dynamic>[
      id,
      key,
      value,
    ];
    return _channel.invokeMethod(
      'setExecutionTraceAttribute:key:value:',
      params,
    );
  }

  /// Ends an execution trace.
  /// [String] id of the trace.
  static Future<void> endExecutionTrace(String id) async {
    final params = <dynamic>[id];
    return _channel.invokeMethod('endExecutionTrace:', params);
  }

  /// Enables or disables auto UI tracing.
  /// [boolean] isEnabled
  static Future<void> setAutoUITraceEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    return _channel.invokeMethod('setAutoUITraceEnabled:', params);
  }

  /// Starts UI trace.
  /// [String] name
  static Future<void> startUITrace(String name) async {
    final params = <dynamic>[name];
    return _channel.invokeMethod('startUITrace:', params);
  }

  /// Ends UI trace.
  static Future<void> endUITrace() async {
    return _channel.invokeMethod('endUITrace');
  }

  /// Ends App Launch.
  static Future<void> endAppLaunch() async {
    return _channel.invokeMethod('endAppLaunch');
  }

  static FutureOr<void> networkLogAndroid(NetworkData data) {
    if (IBGBuildInfo.instance.isAndroid) {
      final params = <dynamic>[data.toMap()];
      return _channel.invokeMethod(
        'apmNetworkLogByReflection:',
        params,
      );
    }
  }
}
