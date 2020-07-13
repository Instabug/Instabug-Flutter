import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:instabug_flutter/Instabug.dart';

enum InvocationOption {
  commentFieldRequired,
  disablePostSendingDialog,
  emailFieldHidden,
  emailFieldOptional
}

enum DismissType { cancel, submit, addAttachment }

enum ReportType { bug, feedback, question, other }

enum ExtendedBugReportMode {
  enabledWithRequiredFields,
  enabledWithOptionalFields,
  disabled
}

class BugReporting {
  static Function _onInvokeCallback;
  static Function _onDismissCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onInvokeCallback':
        _onInvokeCallback();
        return;
      case 'onDismissCallback':
        final Map<dynamic, dynamic> map = call.arguments;
        DismissType dismissType;
        ReportType reportType;
        final String dismissTypeString = map['dismissType'].toUpperCase();
        switch (dismissTypeString) {
          case 'CANCEL':
            dismissType = DismissType.cancel;
            break;
          case 'SUBMIT':
            dismissType = DismissType.submit;
            break;
          case 'ADD_ATTACHMENT':
            dismissType = DismissType.addAttachment;
            break;
        }
        final String reportTypeString = map['reportType'].toUpperCase();
        switch (reportTypeString) {
          case 'BUG':
            reportType = ReportType.bug;
            break;
          case 'FEEDBACK':
            reportType = ReportType.feedback;
            break;
          case 'OTHER':
            reportType = ReportType.other;
            break;
        }
        try {
          _onDismissCallback(dismissType, reportType);
        } catch (exception) {
          _onDismissCallback();
        }
        return;
    }
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
    _onInvokeCallback = function;
    await _channel.invokeMethod<Object>('setOnInvokeCallback');
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [function]  A callback that gets executed before invoking the SDK
  static void setOnDismissCallback(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onDismissCallback = function;
    await _channel.invokeMethod<Object>('setOnDismissCallback');
  }

  /// Sets the events that invoke the feedback form.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationEvents] invocationEvent List of events that invokes the
  static void setInvocationEvents(
      List<InvocationEvent> invocationEvents) async {
    final List<String> invocationEventsStrings = <String>[];
    if (invocationEvents != null) {
      invocationEvents.forEach((e) {
        invocationEventsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[invocationEventsStrings];
    await _channel.invokeMethod<Object>('setInvocationEvents:', params);
  }

  /// Sets whether attachments in bug reporting and in-app messaging are enabled or not.
  /// [screenshot] A boolean to enable or disable screenshot attachments.
  /// [extraScreenshot] A boolean to enable or disable extra screenshot attachments.
  /// [galleryImage] A boolean to enable or disable gallery image
  /// attachments. In iOS 10+,NSPhotoLibraryUsageDescription should be set in
  /// info.plist to enable gallery image attachments.
  /// [screenRecording] A boolean to enable or disable screen recording attachments.
  static void setEnabledAttachmentTypes(bool screenshot, bool extraScreenshot,
      bool galleryImage, bool screenRecording) async {
    final List<dynamic> params = <dynamic>[
      screenshot,
      extraScreenshot,
      galleryImage,
      screenRecording
    ];
    await _channel.invokeMethod<Object>(
        'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',
        params);
  }

  ///Sets what type of reports, bug or feedback, should be invoked.
  /// [reportTypes] - List of reportTypes
  static void setReportTypes(List<ReportType> reportTypes) async {
    final List<String> reportTypesStrings = <String>[];
    if (reportTypes != null) {
      reportTypes.forEach((e) {
        reportTypesStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[reportTypesStrings];
    await _channel.invokeMethod<Object>('setReportTypes:', params);
  }

  /// Sets whether the extended bug report mode should be disabled, enabled with
  /// required fields or enabled with optional fields.
  /// [extendedBugReportMode] ExtendedBugReportMode enum
  static void setExtendedBugReportMode(
      ExtendedBugReportMode extendedBugReportMode) async {
    final List<dynamic> params = <dynamic>[extendedBugReportMode.toString()];
    await _channel.invokeMethod<Object>('setExtendedBugReportMode:', params);
  }

  /// Sets the invocation options.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationOptions] List of invocation options
  static void setInvocationOptions(
      List<InvocationOption> invocationOptions) async {
    final List<String> invocationOptionsStrings = <String>[];
    if (invocationOptions != null) {
      invocationOptions.forEach((e) {
        invocationOptionsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[invocationOptionsStrings];
    await _channel.invokeMethod<Object>('setInvocationOptions:', params);
  }

  /// Invoke bug reporting with report type and options.
  /// [reportType] type
  /// [invocationOptions]  List of invocation options
  static void show(
      ReportType reportType, List<InvocationOption> invocationOptions) async {
    final List<String> invocationOptionsStrings = <String>[];
    if (invocationOptions != null) {
      invocationOptions.forEach((e) {
        invocationOptionsStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[
      reportType.toString(),
      invocationOptionsStrings
    ];
    await _channel.invokeMethod<Object>(
        'showBugReportingWithReportTypeAndOptions:options:', params);
  }

  /// Sets the threshold value of the shake gesture for iPhone/iPod Touch
  /// Default for iPhone is 2.5.
  /// [iPhoneShakingThreshold] iPhoneShakingThreshold double
  static void setShakingThresholdForiPhone(
      double iPhoneShakingThreshold) async {
    if (Platform.isIOS) {
      final List<dynamic> params = <dynamic>[iPhoneShakingThreshold];
      await _channel.invokeMethod<Object>(
          'setShakingThresholdForiPhone:', params);
    }
  }

  /// Sets the threshold value of the shake gesture for iPad
  /// Default for iPhone is 0.6.
  /// [iPadShakingThreshold] iPhoneShakingThreshold double
  static void setShakingThresholdForiPad(double iPadShakingThreshold) async {
    if (Platform.isIOS) {
      final List<dynamic> params = <dynamic>[iPadShakingThreshold];
      await _channel.invokeMethod<Object>(
          'setShakingThresholdForiPad:', params);
    }
  }

  /// Sets the threshold value of the shake gesture for android devices.
  /// Default for android is an integer value equals 350.
  /// you could increase the shaking difficulty level by
  /// increasing the `350` value and vice versa
  /// [androidThreshold] iPhoneShakingThreshold int
  static void setShakingThresholdForAndroid(int androidThreshold) async {
    if (Platform.isAndroid) {
      final List<dynamic> params = <dynamic>[androidThreshold];
      await _channel.invokeMethod<Object>(
          'setShakingThresholdForAndroid:', params);
    }
  }
}
