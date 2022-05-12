// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'package:instabug_flutter/utils/platform_manager.dart';

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

class BugReporting {
  static Function? _onInvokeCallback;
  static Function? _onDismissCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion async =>
      await _channel.invokeMethod<String>('getPlatformVersion');

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
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setBugReportingEnabled:', params);
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
    final params = <dynamic>[invocationEventsStrings];
    await _channel.invokeMethod<Object>('setInvocationEvents:', params);
  }

  /// Sets whether attachments in bug reporting and in-app messaging are enabled or not.
  /// [screenshot] A boolean to enable or disable screenshot attachments.
  /// [extraScreenshot] A boolean to enable or disable extra screenshot attachments.
  /// [galleryImage] A boolean to enable or disable gallery image
  /// attachments. In iOS 10+,NSPhotoLibraryUsageDescription should be set in
  /// info.plist to enable gallery image attachments.
  /// [screenRecording] A boolean to enable or disable screen recording attachments.
  static Future<void> setEnabledAttachmentTypes(bool screenshot,
      bool extraScreenshot, bool galleryImage, bool screenRecording) async {
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
  static Future<void> setReportTypes(List<ReportType>? reportTypes) async {
    final reportTypesStrings =
        reportTypes?.map((e) => e.toString()).toList(growable: false) ?? [];
    final params = <dynamic>[reportTypesStrings];
    await _channel.invokeMethod<Object>('setReportTypes:', params);
  }

  /// Sets whether the extended bug report mode should be disabled, enabled with
  /// required fields or enabled with optional fields.
  /// [extendedBugReportMode] ExtendedBugReportMode enum
  static Future<void> setExtendedBugReportMode(
      ExtendedBugReportMode extendedBugReportMode) async {
    final List<dynamic> params = <dynamic>[extendedBugReportMode.toString()];
    await _channel.invokeMethod<Object>('setExtendedBugReportMode:', params);
  }

  /// Sets the invocation options.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationOptions] List of invocation options
  static Future<void> setInvocationOptions(
      List<InvocationOption>? invocationOptions) async {
    final invocationOptionsStrings =
        invocationOptions?.map((e) => e.toString()).toList(growable: false) ??
            [];
    final params = <dynamic>[invocationOptionsStrings];
    await _channel.invokeMethod<Object>('setInvocationOptions:', params);
  }

  /// Sets the floating button position.
  /// [floatingButtonEdge] FloatingButtonEdge enum - left or right edge of the screen.
  /// [offsetFromTop] integer offset for the position on the y-axis.
  static Future<void> setFloatingButtonEdge(
      FloatingButtonEdge floatingButtonEdge, int offsetFromTop) async {
    final List<dynamic> params = <dynamic>[
      floatingButtonEdge.toString(),
      offsetFromTop
    ];
    await _channel.invokeMethod<Object>(
        'setFloatingButtonEdge:withTopOffset:', params);
  }

  /// Invoke bug reporting with report type and options.
  /// [reportType] type
  /// [invocationOptions]  List of invocation options
  static Future<void> show(
      ReportType reportType, List<InvocationOption>? invocationOptions) async {
    final invocationOptionsStrings =
        invocationOptions?.map((e) => e.toString()).toList(growable: false) ??
            [];
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
  static Future<void> setShakingThresholdForiPhone(
      double iPhoneShakingThreshold) async {
    if (PlatformManager.instance.isIOS()) {
      final List<dynamic> params = <dynamic>[iPhoneShakingThreshold];
      await _channel.invokeMethod<Object>(
          'setShakingThresholdForiPhone:', params);
    }
  }

  /// Sets the threshold value of the shake gesture for iPad
  /// Default for iPhone is 0.6.
  /// [iPadShakingThreshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPad(
      double iPadShakingThreshold) async {
    if (PlatformManager.instance.isIOS()) {
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
  static Future<void> setShakingThresholdForAndroid(
      int androidThreshold) async {
    if (PlatformManager.instance.isAndroid()) {
      final List<dynamic> params = <dynamic>[androidThreshold];
      await _channel.invokeMethod<Object>(
          'setShakingThresholdForAndroid:', params);
    }
  }
}
