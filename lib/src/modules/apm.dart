import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import '../models/network_data.dart';
import '../models/trace.dart';

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
  static Future<void> setEnabled(bool isEnabled) async {
    return _channel.invokeMethod(
      'setAPMEnabled:',
      [isEnabled],
    );
  }

  /// Sets log Level to determine level of details in a log
  /// [logLevel] Enum value to determine the level
  static Future<void> setLogLevel(LogLevel logLevel) async {
    return _channel.invokeMethod(
      'setAPMLogLevel:',
      [logLevel.toString()],
    );
  }

  /// Enables or disables cold app launch tracking.
  /// [boolean] isEnabled
  static Future<void> setColdAppLaunchEnabled(bool isEnabled) async {
    return _channel.invokeMethod(
      'setColdAppLaunchEnabled:',
      [isEnabled],
    );
  }

  /// Starts an execution trace.
  /// [String] name of the trace.
  static Future<dynamic> startExecutionTrace(String name) async {
    final completer = Completer<Trace>();
    _channel.setMethodCallHandler(_handleMethod);
    final callback = (String? idBack) async {
      if (idBack != null) {
        completer.complete(Trace(id: idBack, name: name));
      } else {
        completer.completeError("Execution trace $name wasn't created. "
            'Please make sure to enable APM first by following '
            'the instructions at this link: https://docs.instabug.com/reference#enable-or-disable-apm');
      }
    };

    _startExecutionTraceCallback = callback;

    final id = DateTime.now();
    _channel.invokeMethod(
      'startExecutionTrace:id:',
      [name, id.toString()],
    );

    return completer.future;
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
    return _channel.invokeMethod(
      'setExecutionTraceAttribute:key:value:',
      [id, key, value],
    );
  }

  /// Ends an execution trace.
  /// [String] id of the trace.
  static Future<void> endExecutionTrace(String id) async {
    return _channel.invokeMethod(
      'endExecutionTrace:',
      [id],
    );
  }

  /// Enables or disables auto UI tracing.
  /// [boolean] isEnabled
  static Future<void> setAutoUITraceEnabled(bool isEnabled) async {
    return _channel.invokeMethod(
      'setAutoUITraceEnabled:',
      [isEnabled],
    );
  }

  /// Starts UI trace.
  /// [String] name
  static Future<void> startUITrace(String name) async {
    return _channel.invokeMethod(
      'startUITrace:',
      [name],
    );
  }

  /// Ends UI trace.
  static Future<void> endUITrace() async {
    return _channel.invokeMethod('endUITrace');
  }

  /// Ends UI trace.
  static Future<void> endAppLaunch() async {
    return _channel.invokeMethod('endAppLaunch');
  }

  static Future<bool?> networkLogAndroid(NetworkData data) async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod<bool>(
        'apmNetworkLogByReflection:',
        [data.toMap()],
      );
    }

    return null;
  }
}
