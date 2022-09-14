// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/src/models/crash_data.dart';
import 'package:instabug_flutter/src/models/exception_data.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:stack_trace/stack_trace.dart';

class CrashReporting {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');
  static bool enabled = true;
  static Future<String?> get platformVersion =>
      _channel.invokeMethod<String>('getPlatformVersion');

  ///Enables and disables Enables and disables automatic crash reporting.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    enabled = isEnabled;
    final params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setCrashReportingEnabled:', params);
  }

  static Future<void> reportCrash(Object exception, StackTrace stack) async {
    if (IBGBuildInfo.instance.isReleaseMode && enabled) {
      await _reportUnhandledCrash(exception, stack);
    } else {
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(stack: stack, exception: exception),
      );
    }
  }

  /// Reports a handled crash to you dashboard
  /// [Object] exception
  /// [StackTrace] stack
  static Future<void> reportHandledCrash(
    Object exception, [
    StackTrace? stack,
  ]) async {
    await _sendCrash(exception, stack ?? StackTrace.current, true);
  }

  static Future<void> _reportUnhandledCrash(
    Object exception,
    StackTrace stack,
  ) async {
    await _sendCrash(exception, stack, false);
  }

  static Future<void> _sendCrash(
    Object exception,
    StackTrace stack,
    bool handled,
  ) async {
    final trace = Trace.from(stack);
    final frames = <ExceptionData>[];
    for (var i = 0; i < trace.frames.length; i++) {
      frames.add(
        ExceptionData(
          trace.frames[i].uri.toString(),
          trace.frames[i].member,
          trace.frames[i].line,
          trace.frames[i].column ?? 0,
        ),
      );
    }
    final crashData = CrashData(
      exception.toString(),
      IBGBuildInfo.instance.operatingSystem,
      frames,
    );
    final params = <dynamic>[jsonEncode(crashData), handled];
    await _channel.invokeMethod<Object>(
      'sendJSCrashByReflection:handled:',
      params,
    );
  }
}
