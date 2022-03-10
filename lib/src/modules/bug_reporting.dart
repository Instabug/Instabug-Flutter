import 'dart:async';

import 'package:flutter/services.dart';

import '../utils/platform_manager.dart';
import 'instabug.dart';

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
  static Function? _onInvokeCallback;
  static Function? _onDismissCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onInvokeCallback':
        _onInvokeCallback?.call();
        return;
      case 'onDismissCallback':
        final Map<dynamic, dynamic> map = call.arguments;
        DismissType? dismissType;
        ReportType? reportType;
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
          _onDismissCallback?.call(dismissType, reportType);
        } catch (exception) {
          _onDismissCallback?.call();
        }
        return;
    }
  }

  ///Enables and disables manual invocation and prompt options for bug and feedback.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _channel.invokeMethod(
      'setBugReportingEnabled:',
      [isEnabled],
    );
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [function]  A callback that gets executed before invoking the SDK
  static Future<void> setOnInvokeCallback(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onInvokeCallback = function;
    await _channel.invokeMethod<Object>('setOnInvokeCallback');
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [function]  A callback that gets executed before invoking the SDK
  static Future<void> setOnDismissCallback(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onDismissCallback = function;
    await _channel.invokeMethod<Object>('setOnDismissCallback');
  }

  /// Sets the events that invoke the feedback form.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationEvents] invocationEvent List of events that invokes the
  static Future<void> setInvocationEvents(
      List<InvocationEvent>? invocationEvents) async {
    final invocationEventsStrings =
        invocationEvents?.map((e) => e.toString()).toList(growable: false) ??
            [];
    return _channel.invokeMethod(
      'setInvocationEvents:',
      [invocationEventsStrings],
    );
  }

  /// Sets whether attachments in bug reporting and in-app messaging are enabled or not.
  /// [screenshot] A boolean to enable or disable screenshot attachments.
  /// [extraScreenshot] A boolean to enable or disable extra screenshot attachments.
  /// [galleryImage] A boolean to enable or disable gallery image
  /// attachments. In iOS 10+,NSPhotoLibraryUsageDescription should be set in
  /// info.plist to enable gallery image attachments.
  /// [screenRecording] A boolean to enable or disable screen recording attachments.
  static Future<void> setEnabledAttachmentTypes(
    bool screenshot,
    bool extraScreenshot,
    bool galleryImage,
    bool screenRecording,
  ) async {
    return _channel.invokeMethod(
      'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',
      [screenshot, extraScreenshot, galleryImage, screenRecording],
    );
  }

  ///Sets what type of reports, bug or feedback, should be invoked.
  /// [reportTypes] - List of reportTypes
  static Future<void> setReportTypes(List<ReportType>? reportTypes) async {
    final reportTypesStrings =
        reportTypes?.map((e) => e.toString()).toList(growable: false) ?? [];
    return _channel.invokeMethod(
      'setReportTypes:',
      [reportTypesStrings],
    );
  }

  /// Sets whether the extended bug report mode should be disabled, enabled with
  /// required fields or enabled with optional fields.
  /// [extendedBugReportMode] ExtendedBugReportMode enum
  static Future<void> setExtendedBugReportMode(
      ExtendedBugReportMode extendedBugReportMode) async {
    return _channel.invokeMethod(
      'setExtendedBugReportMode:',
      [extendedBugReportMode.toString()],
    );
  }

  /// Sets the invocation options.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationOptions] List of invocation options
  static Future<void> setInvocationOptions(
      List<InvocationOption>? invocationOptions) async {
    final invocationOptionsStrings =
        invocationOptions?.map((e) => e.toString()).toList(growable: false) ??
            [];
    return _channel.invokeMethod(
      'setInvocationOptions:',
      [invocationOptionsStrings],
    );
  }

  /// Invoke bug reporting with report type and options.
  /// [reportType] type
  /// [invocationOptions]  List of invocation options
  static Future<void> show(
      ReportType reportType, List<InvocationOption>? invocationOptions) async {
    final invocationOptionsStrings =
        invocationOptions?.map((e) => e.toString()).toList(growable: false) ??
            [];
    return _channel.invokeMethod(
      'showBugReportingWithReportTypeAndOptions:options:',
      [reportType.toString(), invocationOptionsStrings],
    );
  }

  /// Sets the threshold value of the shake gesture for iPhone/iPod Touch
  /// Default for iPhone is 2.5.
  /// [iPhoneShakingThreshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPhone(
      double iPhoneShakingThreshold) async {
    if (PlatformManager.instance.isIOS()) {
      return _channel.invokeMethod(
        'setShakingThresholdForiPhone:',
        [iPhoneShakingThreshold],
      );
    }
  }

  /// Sets the threshold value of the shake gesture for iPad
  /// Default for iPhone is 0.6.
  /// [iPadShakingThreshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPad(
    double iPadShakingThreshold,
  ) async {
    if (PlatformManager.instance.isIOS()) {
      return _channel.invokeMethod(
        'setShakingThresholdForiPad:',
        [iPadShakingThreshold],
      );
    }
  }

  /// Sets the threshold value of the shake gesture for android devices.
  /// Default for android is an integer value equals 350.
  /// you could increase the shaking difficulty level by
  /// increasing the `350` value and vice versa
  /// [androidThreshold] iPhoneShakingThreshold int
  static Future<void> setShakingThresholdForAndroid(
    int androidThreshold,
  ) async {
    if (PlatformManager.instance.isAndroid()) {
      return _channel.invokeMethod(
        'setShakingThresholdForAndroid:',
        [androidThreshold],
      );
    }
  }
}
