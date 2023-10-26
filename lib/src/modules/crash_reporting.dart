// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/generated/crash_reporting.api.g.dart';
import 'package:instabug_flutter/src/models/crash_data.dart';
import 'package:instabug_flutter/src/models/exception_data.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:stack_trace/stack_trace.dart';

class CrashReporting {
  static var _host = CrashReportingHostApi();
  static bool enabled = true;

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(CrashReportingHostApi host) {
    _host = host;
  }

  /// Enables and disables Enables and disables automatic crash reporting.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    enabled = isEnabled;
    return _host.setEnabled(isEnabled);
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
    final frames = trace.frames
        .map(
          (frame) => ExceptionData(
            file: frame.uri.toString(),
            methodName: frame.member,
            lineNumber: frame.line,
            column: frame.column ?? 0,
          ),
        )
        .toList();

    final crashData = CrashData(
      os: IBGBuildInfo.instance.operatingSystem,
      message: exception.toString(),
      exception: frames,
    );

    return _host.send(jsonEncode(crashData), handled);
  }

  /// Enables and disables capturing native C++ NDK crashes.
  /// [boolean] isEnabled
  ///
  /// Only supports Android
  static Future<void> setNDKCrashesEnabled(bool isEnabled) async {
    if (Platform.isAndroid) {
      return _host.setNDKCrashesEnabled(isEnabled);
    }
  }
}
