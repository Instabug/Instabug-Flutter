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

enum DismissType {
  CANCEL,
  SUBMIT,
  ADD_ATTACHMENT
}

enum ReportType {
  BUG,
  FEEDBACK,
  OTHER
}

enum ExtendedBugReportMode {
  ENABLED_WITH_REQUIRED_FIELDS,
  ENABLED_WITH_OPTIONAL_FIELDS,
  DISABLED
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
      Map<dynamic, dynamic> map = call.arguments;
      DismissType dismissType;
      ReportType reportType;
      final String dismissTypeString = map['dismissType'].toUpperCase();
      switch(dismissTypeString) {
        case 'CANCEL':
          dismissType = DismissType.CANCEL;
          break;
        case 'SUBMIT':
          dismissType = DismissType.SUBMIT;
          break;
        case 'ADD_ATTACHMENT':
          dismissType = DismissType.ADD_ATTACHMENT;
          break;
      }
      final String reportTypeString = map['reportType'].toUpperCase();
      switch(reportTypeString) {
        case 'BUG':
          reportType = ReportType.BUG;
          break;
        case 'FEEDBACK':
          reportType = ReportType.FEEDBACK;
          break;
        case 'OTHER':
          reportType = ReportType.OTHER;
          break;
      }
      try {
        onDismissCallback(dismissType,reportType);
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

   /// Sets the events that invoke the feedback form.
   /// Default is set by `Instabug.startWithToken`.
   /// [invocationEvents] invocationEvent List of events that invokes the
  static void setInvocationEvents(List<InvocationEvent> invocationEvents) async {
    List<String> invocationEventsStrings = <String>[];
    if (invocationEvents != null) {
      invocationEvents.forEach((e) {
        invocationEventsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[invocationEventsStrings];
    await _channel.invokeMethod<Object>('setInvocationEvents:',params);
  } 

   /// Sets whether attachments in bug reporting and in-app messaging are enabled or not.
   /// [screenshot] A boolean to enable or disable screenshot attachments.
   /// [extraScreenshot] A boolean to enable or disable extra screenshot attachments.
   /// [galleryImage] A boolean to enable or disable gallery image
   /// attachments. In iOS 10+,NSPhotoLibraryUsageDescription should be set in
   /// info.plist to enable gallery image attachments.
   /// [screenRecording] A boolean to enable or disable screen recording attachments.
  static void setEnabledAttachmentTypes(bool screenshot, bool extraScreenshot, bool galleryImage, bool screenRecording) async {
    final List<dynamic> params = <dynamic>[screenshot, extraScreenshot, galleryImage, screenRecording];
    await _channel.invokeMethod<Object>('setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',params);
  } 

   ///Sets what type of reports, bug or feedback, should be invoked.
   /// [reportTypes] - List of reportTypes
  static void setReportTypes(List<ReportType> reportTypes) async {
    List<String> reportTypesStrings = <String>[];
    if (reportTypes != null) {
      reportTypes.forEach((e) {
        reportTypesStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[reportTypesStrings];
    await _channel.invokeMethod<Object>('setReportTypes:',params);
  } 

   /// Sets whether the extended bug report mode should be disabled, enabled with
   /// required fields or enabled with optional fields.
   /// [extendedBugReportMode] ExtendedBugReportMode enum 
  static void setExtendedBugReportMode(ExtendedBugReportMode extendedBugReportMode) async {
    final List<dynamic> params = <dynamic>[extendedBugReportMode.toString()];
    await _channel.invokeMethod<Object>('setExtendedBugReportMode:', params); 
  } 

   /// Sets the invocation options.
   /// Default is set by `Instabug.startWithToken`.
   /// [invocationOptions] List of invocation options
  static void setInvocationOptions(List<InvocationOption> invocationOptions) async {
    List<String> invocationOptionsStrings = <String>[];
    if (invocationOptions != null) {
      invocationOptions.forEach((e) {
        invocationOptionsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[invocationOptionsStrings];
    await _channel.invokeMethod<Object>('setInvocationOptions:',params);
  } 

   /// Invoke bug reporting with report type and options.
   /// [reportType] type 
   /// [invocationOptions]  List of invocation options
  static void showWithOptions(ReportType reportType, List<InvocationOption> invocationOptions) async {
    List<String> invocationOptionsStrings = <String>[];
    if (invocationOptions != null) {
      invocationOptions.forEach((e) {
        invocationOptionsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[reportType.toString(), invocationOptionsStrings];
    await _channel.invokeMethod<Object>('showBugReportingWithReportTypeAndOptions:options:',params);
  } 
}
