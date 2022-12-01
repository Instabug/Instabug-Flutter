// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/models/trace.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:meta/meta.dart';

enum LogLevel {
  none,
  error,
  warning,
  info,
  debug,
  verbose,
}

class APM {
  static var _host = ApmHostApi();

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(ApmHostApi host) {
    _host = host;
  }

  /// Enables or disables APM feature.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  /// Sets log Level to determine level of details in a log
  /// [logLevel] Enum value to determine the level
  static Future<void> setLogLevel(LogLevel logLevel) async {
    return _host.setLogLevel(logLevel.toString());
  }

  /// Enables or disables cold app launch tracking.
  /// [boolean] isEnabled
  static Future<void> setColdAppLaunchEnabled(bool isEnabled) async {
    return _host.setColdAppLaunchEnabled(isEnabled);
  }

  /// Starts an execution trace.
  /// [String] name of the trace.
  static Future<Trace> startExecutionTrace(String name) async {
    final id = IBGDateTime.instance.now();
    final traceId = await _host.startExecutionTrace(id.toString(), name);

    if (traceId == null) {
      return Future.error(
        "Execution trace $name wasn't created. Please make sure to enable APM first by following "
        'the instructions at this link: https://docs.instabug.com/reference#enable-or-disable-apm',
      );
    }

    return Trace(
      id: traceId,
      name: name,
    );
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
    return _host.setExecutionTraceAttribute(id, key, value);
  }

  /// Ends an execution trace.
  /// [String] id of the trace.
  static Future<void> endExecutionTrace(String id) async {
    return _host.endExecutionTrace(id);
  }

  /// Enables or disables auto UI tracing.
  /// [boolean] isEnabled
  static Future<void> setAutoUITraceEnabled(bool isEnabled) async {
    return _host.setAutoUITraceEnabled(isEnabled);
  }

  /// Starts UI trace.
  /// [String] name
  static Future<void> startUITrace(String name) async {
    return _host.startUITrace(name);
  }

  /// Ends UI trace.
  static Future<void> endUITrace() async {
    return _host.endUITrace();
  }

  /// Ends App Launch.
  static Future<void> endAppLaunch() async {
    return _host.endAppLaunch();
  }

  static FutureOr<void> networkLogAndroid(NetworkData data) {
    if (IBGBuildInfo.instance.isAndroid) {
      return _host.networkLogAndroid(data.toJson());
    }
  }
}
