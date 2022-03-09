import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/models/crash_data.dart';
import 'package:instabug_flutter/models/exception_data.dart';
import 'package:stack_trace/stack_trace.dart';

class CrashReporting {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');
  static bool enabled = true;
  ///Enables and disables Enables and disables automatic crash reporting.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    enabled = isEnabled;
    final params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setCrashReportingEnabled:', params);
  }

  static Future<void> reportCrash(dynamic exception, StackTrace stack) async {
    if (kReleaseMode && enabled) {
      _reportUnhandledCrash(exception, stack);
    } else {
      FlutterError.dumpErrorToConsole(
          FlutterErrorDetails(stack: stack, exception: exception));
    }
  }

  /// Reports a handled crash to you dashboard
  /// [dynamic] exception
  /// [StackTrace] stack
  static Future<void> reportHandledCrash(dynamic exception,
      [StackTrace? stack]) async {
    _sendCrash(exception, stack ?? StackTrace.current, true);
  }

  static Future<void> _reportUnhandledCrash(
      dynamic exception, StackTrace stack) async {
    _sendCrash(exception, stack, false);
  }

  static Future<void> _sendCrash(
      dynamic exception, StackTrace stack, bool handled) async {
    final trace = Trace.from(stack);
    final frames = <ExceptionData>[];
    for (var i = 0; i < trace.frames.length; i++) {
      frames.add(ExceptionData(
          trace.frames[i].uri.toString(),
          trace.frames[i].member,
          trace.frames[i].line,
          trace.frames[i].column ?? 0));
    }
    final crashData = CrashData(
        exception.toString(), Platform.operatingSystem.toString(), frames);
    final params = <dynamic>[jsonEncode(crashData), handled];
    await _channel.invokeMethod<Object>(
        'sendJSCrashByReflection:handled:', params);
  }
}
