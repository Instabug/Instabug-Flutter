import 'dart:async';
import 'dart:convert';
import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/models/crash_data.dart';
import 'package:instabug_flutter/models/exception_data.dart';
import 'package:stack_trace/stack_trace.dart';


class CrashReporting {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static void reportCrash(dynamic exception, StackTrace stack) async {
    if(kReleaseMode){
        reportUnhandledException(exception, stack);
    } else {
        reportUnhandledException(exception, stack);
        FlutterError.dumpErrorToConsole(FlutterErrorDetails(stack: stack, exception: exception));
    }
    exit(1);
  }

  static void reportUnhandledException(dynamic exception, StackTrace stack) async {
    final Trace trace = Trace.from(stack);
    final List<ExceptionData> frames = <ExceptionData>[];
    for (int i = 0; i < trace.frames.length; i++) {
      frames.add(ExceptionData(trace.frames[i].uri.toString(), trace.frames[i].member, trace.frames[i].line, trace.frames[i].column));
    }
    final CrashData crashData = CrashData(exception.toString(),Platform.operatingSystem.toString(),frames);

    //print(jsonEncode(crashData));
      final List<dynamic> params = <dynamic>[
        jsonEncode(crashData),
        false
      ];
    await _channel.invokeMethod<Object>(
        'sendJSCrashByReflection:handled:', params);
    } 
}


