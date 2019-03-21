import 'dart:async';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/Instabug.dart';

enum InvocationOption {
  COMMENT_FIELD_REQUIRED,
  DISABLE_POST_SENDING_DIALOG,
  EMAIL_FIELD_HIDDEN,
  EMAIL_FIELD_OPTIONAL
}

class BugReporting {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
  /// invoke sdk manually with desire invocation mode
  /// [invocationMode] the invocation mode
  /// [invocationOptions] the array of invocation options
  static void invokeWithMode(InvocationMode invocationMode, [List<InvocationOption> invocationOptions]) async {
    List<String> invocationOptionsStrings = <String>[];
    if (invocationOptions != null) {
      invocationOptions.forEach((e) {
        invocationOptionsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[invocationMode.toString(), invocationOptionsStrings];
    await _channel.invokeMethod<Object>('invokeWithMode:options:',params);
  }
}