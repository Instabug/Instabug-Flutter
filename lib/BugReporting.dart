import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/Instabug.dart';

enum InvocationOption {
  COMMENT_FIELD_REQUIRED,
  DISABLE_POST_SENDING_DIALOG,
  EMAIL_FIELD_HIDDEN,
  EMAIL_FIELD_OPTIONAL
}

class BugReporting {

  static Function onInvokeCallback;
  static Function onDismissCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {
  switch(call.method) {
    case 'onInvokeCallback':
      onInvokeCallback();
      return ;
    case 'onDismissCallback':
      try {
        onDismissCallback(call.arguments);
      }
      catch(exception) {
        onDismissCallback();
      }
      return ;
  }
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

  ///Enables and disables manual invocation and prompt options for bug and feedback.
  /// [boolean] isEnabled
  static void setEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setBugReportingEnabled:', params); 
  } 

   /// Sets a block of code to be executed just before the SDK's UI is presented.
   /// This block is executed on the UI thread. Could be used for performing any
   /// UI changes before the SDK's UI is shown.
   /// [function]  A callback that gets executed before invoking the SDK
  static void setOnInvokeCallback(Function function) async {
     _channel.setMethodCallHandler(_handleMethod);
    onInvokeCallback = function;
    await _channel.invokeMethod<Object>('setOnInvokeCallback'); 
  } 
  
   /// Sets a block of code to be executed just before the SDK's UI is presented.
   /// This block is executed on the UI thread. Could be used for performing any
   /// UI changes before the SDK's UI is shown.
   /// [function]  A callback that gets executed before invoking the SDK
  static void setOnDismissCallback(Function function) async {
     _channel.setMethodCallHandler(_handleMethod);
    onDismissCallback = function;
    await _channel.invokeMethod<Object>('setOnDismissCallback'); 
  } 
}
