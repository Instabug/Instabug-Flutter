// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/generated/bug_reporting.api.g.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:meta/meta.dart';

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

class BugReporting implements BugReportingFlutterApi {
  static final _native = BugReportingHostApi();
  static final _instance = BugReporting();

  static OnSDKInvokeCallback? _onInvokeCallback;
  static OnSDKDismissCallback? _onDismissCallback;

  @internal
  static void init() {
    BugReportingFlutterApi.setup(_instance);
  }

  @override
  void onSdkInvoke() {
    _onInvokeCallback?.call();
  }

  @override
  void onSdkDismiss(String dismissType, String reportType) {
    final dismissTypeKey = dismissType.toUpperCase();
    final reportTypeKey = reportType.toUpperCase();

    const dismissTypeMapper = {
      'CANCEL': DismissType.cancel,
      'SUBMIT': DismissType.submit,
      'ADD_ATTACHMENT': DismissType.addAttachment,
    };

    const reportTypeMapper = {
      'BUG': ReportType.bug,
      'FEEDBACK': ReportType.feedback,
      'OTHER': ReportType.other,
    };

    if (dismissTypeMapper.containsKey(dismissTypeKey) &&
        reportTypeMapper.containsKey(reportTypeKey)) {
      _onDismissCallback?.call(
        dismissTypeMapper[dismissTypeKey]!,
        reportTypeMapper[reportTypeKey]!,
      );
    }
  }

  /// Enables and disables manual invocation and prompt options for bug and feedback.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _native.setEnabled(isEnabled);
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [callback]  A callback that gets executed before invoking the SDK
  static Future<void> setOnInvokeCallback(
    OnSDKInvokeCallback callback,
  ) async {
    _onInvokeCallback = callback;
    return _native.bindOnInvokeCallback();
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the SDK's UI is shown.
  /// [callback]  A callback that gets executed before invoking the SDK
  static Future<void> setOnDismissCallback(
    OnSDKDismissCallback callback,
  ) async {
    _onDismissCallback = callback;
    return _native.bindOnDismissCallback();
  }

  /// Sets the events that invoke the feedback form.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationEvents] invocationEvent List of events that invokes the
  static Future<void> setInvocationEvents(
    List<InvocationEvent>? invocationEvents,
  ) async {
    final eventsStrings = invocationEvents?.map((e) => e.toString()).toList();
    return _native.setInvocationEvents(eventsStrings ?? []);
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
    return _native.setEnabledAttachmentTypes(
      screenshot,
      extraScreenshot,
      galleryImage,
      screenRecording,
    );
  }

  /// Sets what type of reports, bug or feedback, should be invoked.
  /// [reportTypes] - List of reportTypes
  static Future<void> setReportTypes(List<ReportType>? reportTypes) async {
    final typesStrings = reportTypes?.map((e) => e.toString()).toList();
    return _native.setReportTypes(typesStrings ?? []);
  }

  /// Sets whether the extended bug report mode should be disabled, enabled with
  /// required fields or enabled with optional fields.
  /// [extendedBugReportMode] ExtendedBugReportMode enum
  static Future<void> setExtendedBugReportMode(
    ExtendedBugReportMode extendedBugReportMode,
  ) async {
    return _native.setExtendedBugReportMode(extendedBugReportMode.toString());
  }

  /// Sets the invocation options.
  /// Default is set by `Instabug.startWithToken`.
  /// [invocationOptions] List of invocation options
  static Future<void> setInvocationOptions(
    List<InvocationOption>? invocationOptions,
  ) async {
    final optionsStrings = invocationOptions?.map((e) => e.toString()).toList();
    return _native.setInvocationOptions(optionsStrings ?? []);
  }

  /// Sets the floating button position.
  /// [floatingButtonEdge] FloatingButtonEdge enum - left or right edge of the screen.
  /// [offsetFromTop] integer offset for the position on the y-axis.
  static Future<void> setFloatingButtonEdge(
    FloatingButtonEdge floatingButtonEdge,
    int offsetFromTop,
  ) async {
    return _native.setFloatingButtonEdge(
      floatingButtonEdge.toString(),
      offsetFromTop,
    );
  }

  /// Sets the position of the video recording button when using the screen recording attachment functionality.
  /// [position] Position of the video recording floating button on the screen.
  static Future<void> setVideoRecordingFloatingButtonPosition(
    Position position,
  ) async {
    return _native.setVideoRecordingFloatingButtonPosition(position.toString());
  }

  /// Invoke bug reporting with report type and options.
  /// [reportType] type
  /// [invocationOptions]  List of invocation options
  static Future<void> show(
    ReportType reportType,
    List<InvocationOption>? invocationOptions,
  ) async {
    final optionsStrings = invocationOptions?.map((e) => e.toString()).toList();
    return _native.show(reportType.toString(), optionsStrings ?? []);
  }

  /// Sets the threshold value of the shake gesture for iPhone/iPod Touch
  /// Default for iPhone is 2.5.
  /// [threshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPhone(double threshold) async {
    if (IBGBuildInfo.instance.isIOS) {
      return _native.setShakingThresholdForiPhone(threshold);
    }
  }

  /// Sets the threshold value of the shake gesture for iPad
  /// Default for iPhone is 0.6.
  /// [threshold] iPhoneShakingThreshold double
  static Future<void> setShakingThresholdForiPad(double threshold) async {
    if (IBGBuildInfo.instance.isIOS) {
      return _native.setShakingThresholdForiPad(threshold);
    }
  }

  /// Sets the threshold value of the shake gesture for android devices.
  /// Default for android is an integer value equals 350.
  /// you could increase the shaking difficulty level by
  /// increasing the `350` value and vice versa
  /// [threshold] iPhoneShakingThreshold int
  static Future<void> setShakingThresholdForAndroid(int threshold) async {
    if (IBGBuildInfo.instance.isAndroid) {
      return _native.setShakingThresholdForAndroid(threshold);
    }
  }
}
