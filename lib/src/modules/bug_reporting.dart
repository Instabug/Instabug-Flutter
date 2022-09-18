// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';

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

enum FloatingButtonEdge { left, right }

enum Position {
  topRight,
  topLeft,
  bottomRight,
  bottomLeft,
}

typedef OnSDKInvokeCallback = void Function();
typedef OnSDKDismissCallback = void Function(DismissType, ReportType);

class BugReporting {
  static OnSDKInvokeCallback? _onInvokeCallback;
  static OnSDKDismissCallback? _onDismissCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion =>
      _channel.invokeMethod<String>('getPlatformVersion');

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onInvokeCallback':
        _onInvokeCallback?.call();
        return;
      case 'onDismissCallback':
        final map = call.arguments as Map<dynamic, dynamic>;
        DismissType? dismissType;
        ReportType? reportType;
        final dismissTypeString = (map['dismissType'] as String).toUpperCase();
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
        final reportTypeString = (map['reportType'] as String).toUpperCase();
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
        if (dismissType != null && reportType != null) {
          _onDismissCallback?.call(dismissType, reportType);
        }
        return;
    }
  }

  ///Enables and disables manual invocation and prompt options for bug and feedback.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    return _channel.invokeMethod('setBugReportingEnabled:', params);
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [function]  A callback that gets executed before invoking the SDK
  static Future<void> setOnInvokeCallback(
    OnSDKInvokeCallback function,
  ) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onInvokeCallback = function;
    return _channel.invokeMethod('setOnInvokeCallback');
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [function]  A callback that gets executed before invoking the SDK
  static Future<void> setOnDismissCallback(
    OnSDKDismissCallback function,
  ) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onDismissCallback = function;
    return _channel.invokeMethod('setOnDismissCallback');
  }

  /// Sets the events that invoke the feedback form.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationEvents] invocationEvent List of events that invokes the
  static Future<void> setInvocationEvents(
    List<InvocationEvent>? invocationEvents,
  ) async {
    final invocationEventsStrings =
        invocationEvents?.map((e) => e.toString()).toList(growable: false) ??
            [];
    final params = <dynamic>[invocationEventsStrings];
    return _channel.invokeMethod('setInvocationEvents:', params);
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
    final params = <dynamic>[
      screenshot,
      extraScreenshot,
      galleryImage,
      screenRecording
    ];
    return _channel.invokeMethod(
      'setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:',
      params,
    );
  }

  ///Sets what type of reports, bug or feedback, should be invoked.
  /// [reportTypes] - List of reportTypes
  static Future<void> setReportTypes(List<ReportType>? reportTypes) async {
    final reportTypesStrings =
        reportTypes?.map((e) => e.toString()).toList(growable: false) ?? [];
    final params = <dynamic>[reportTypesStrings];
    return _channel.invokeMethod('setReportTypes:', params);
  }

  /// Sets whether the extended bug report mode should be disabled, enabled with
  /// required fields or enabled with optional fields.
  /// [extendedBugReportMode] ExtendedBugReportMode enum
  static Future<void> setExtendedBugReportMode(
    ExtendedBugReportMode extendedBugReportMode,
  ) async {
    final params = <dynamic>[extendedBugReportMode.toString()];
    return _channel.invokeMethod('setExtendedBugReportMode:', params);
  }

  /// Sets the invocation options.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationOptions] List of invocation options
  static Future<void> setInvocationOptions(
    List<InvocationOption>? invocationOptions,
  ) async {
    final invocationOptionsStrings =
        invocationOptions?.map((e) => e.toString()).toList(growable: false) ??
            [];
    final params = <dynamic>[invocationOptionsStrings];
    return _channel.invokeMethod('setInvocationOptions:', params);
  }

  /// Sets the floating button position.
  /// [floatingButtonEdge] FloatingButtonEdge enum - left or right edge of the screen.
  /// [offsetFromTop] integer offset for the position on the y-axis.
  static Future<void> setFloatingButtonEdge(
    FloatingButtonEdge floatingButtonEdge,
    int offsetFromTop,
  ) async {
    final params = <dynamic>[floatingButtonEdge.toString(), offsetFromTop];
    return _channel.invokeMethod(
      'setFloatingButtonEdge:withTopOffset:',
      params,
    );
  }

  /// Invoke bug reporting with report type and options.
  /// [reportType] type
  /// [invocationOptions]  List of invocation options
  static Future<void> show(
    ReportType reportType,
    List<InvocationOption>? invocationOptions,
  ) async {
    final invocationOptionsStrings =
        invocationOptions?.map((e) => e.toString()).toList(growable: false) ??
            [];
    final params = <dynamic>[reportType.toString(), invocationOptionsStrings];
    return _channel.invokeMethod(
      'showBugReportingWithReportTypeAndOptions:options:',
      params,
    );
  }

  /// Sets the threshold value of the shake gesture for iPhone/iPod Touch
  /// Default for iPhone is 2.5.
  /// [iPhoneShakingThreshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPhone(
    double iPhoneShakingThreshold,
  ) async {
    if (IBGBuildInfo.instance.isIOS) {
      final params = <dynamic>[iPhoneShakingThreshold];
      return _channel.invokeMethod(
        'setShakingThresholdForiPhone:',
        params,
      );
    }
  }

  /// Sets the threshold value of the shake gesture for iPad
  /// Default for iPhone is 0.6.
  /// [iPadShakingThreshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPad(
    double iPadShakingThreshold,
  ) async {
    if (IBGBuildInfo.instance.isIOS) {
      final params = <dynamic>[iPadShakingThreshold];
      return _channel.invokeMethod(
        'setShakingThresholdForiPad:',
        params,
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
    if (IBGBuildInfo.instance.isAndroid) {
      final params = <dynamic>[androidThreshold];
      return _channel.invokeMethod(
        'setShakingThresholdForAndroid:',
        params,
      );
    }
  }
}
