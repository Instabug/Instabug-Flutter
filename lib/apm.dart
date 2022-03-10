import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'models/network_data.dart';
import 'models/trace.dart';

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

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'startExecutionTraceCallBack':
        _startExecutionTraceCallback(call.arguments);
        return;
    }
  }

  /// Enables or disables APM feature.
  /// [boolean] isEnabled
  static void setEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setAPMEnabled:', params);
  }

  /// Sets log Level to determine level of details in a log
  /// [logLevel] Enum value to determine the level
  static void setLogLevel(LogLevel logLevel) async {
    final params = <dynamic>[logLevel.toString()];
    await _channel.invokeMethod<Object>('setAPMLogLevel:', params);
  }

  /// Enables or disables cold app launch tracking.
  /// [boolean] isEnabled
  static void setColdAppLaunchEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setColdAppLaunchEnabled:', params);
  }

  /// Starts an execution trace.
  /// [String] name of the trace.
  static Future<dynamic> startExecutionTrace(String name) async {
    final TRACE_NOT_STARTED_APM_NOT_ENABLED = "Execution trace " +
        name +
        " wasn't created. Please make sure to enable APM first by following the instructions at this link: https://docs.instabug.com/reference#enable-or-disable-apm";
    final id = DateTime.now();
    final Completer completer = new Completer<Trace>();
    final params = <dynamic>[name.toString(), id.toString()];
    _channel.setMethodCallHandler(_handleMethod);
    final Function callback = (String idBack) async {
      if (idBack != null) {
        completer.complete(Trace(id: idBack, name: name));
      } else {
        completer.completeError(TRACE_NOT_STARTED_APM_NOT_ENABLED);
      }
    };
    _startExecutionTraceCallback = callback;
    _channel.invokeMethod<Object>('startExecutionTrace:id:', params);
    return completer.future;
  }

  /// Sets attribute of an execution trace.
  /// [String] id of the trace.
  /// [String] key of attribute.
  /// [String] value of attribute.
  static void setExecutionTraceAttribute(
      String id, String key, String value) async {
    final params = <dynamic>[
      id.toString(),
      key.toString(),
      value.toString(),
    ];
    await _channel.invokeMethod<Object>(
        'setExecutionTraceAttribute:key:value:', params);
  }

  /// Ends an execution trace.
  /// [String] id of the trace.
  static void endExecutionTrace(String id) async {
    final params = <dynamic>[id];
    await _channel.invokeMethod<Object>('endExecutionTrace:', params);
  }

  /// Enables or disables auto UI tracing.
  /// [boolean] isEnabled
  static void setAutoUITraceEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setAutoUITraceEnabled:', params);
  }

  /// Starts UI trace.
  /// [String] name
  static void startUITrace(String name) async {
    final params = <dynamic>[name];
    await _channel.invokeMethod<Object>('startUITrace:', params);
  }

  /// Ends UI trace.
  static void endUITrace() async {
    await _channel.invokeMethod<Object>('endUITrace');
  }
  /// Ends UI trace.
  static void endAppLaunch() async {
    await _channel.invokeMethod<Object>('endAppLaunch');
  }

  static Future<bool?> networkLogAndroid(NetworkData data) async {
    if (Platform.isAndroid) {
      final params = <dynamic>[data.toMap()];
      return await _channel.invokeMethod<bool>(
          'apmNetworkLogByReflection:', params);
    }
  }
}
