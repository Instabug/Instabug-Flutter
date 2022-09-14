// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:typed_data';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';

enum InvocationEvent {
  shake,
  screenshot,
  twoFingersSwipeLeft,
  floatingButton,
  none
}

enum WelcomeMessageMode { live, beta, disabled }

enum IBGLocale {
  arabic,
  azerbaijani,
  chineseSimplified,
  chineseTraditional,
  czech,
  danish,
  dutch,
  english,
  french,
  german,
  italian,
  japanese,
  korean,
  polish,
  portugueseBrazil,
  portuguesePortugal,
  russian,
  spanish,
  swedish,
  turkish,
  indonesian,
  slovak,
  norwegian
}

enum IBGSDKDebugLogsLevel { verbose, debug, error, none }

enum ColorTheme { dark, light }

enum CustomTextPlaceHolderKey {
  shakeHint,
  swipeHint,
  invalidEmailMessage,
  invalidCommentMessage,
  invocationHeader,
  reportQuestion,
  reportBug,
  reportFeedback,
  emailFieldHint,
  commentFieldHintForBugReport,
  commentFieldHintForFeedback,
  commentFieldHintForQuestion,
  addVoiceMessage,
  addImageFromGallery,
  addExtraScreenshot,
  conversationsListTitle,
  audioRecordingPermissionDenied,
  conversationTextFieldHint,
  voiceMessagePressAndHoldToRecord,
  voiceMessageReleaseToAttach,
  reportSuccessfullySent,
  successDialogHeader,
  addVideo,
  betaWelcomeMessageWelcomeStepTitle,
  betaWelcomeMessageWelcomeStepContent,
  betaWelcomeMessageHowToReportStepTitle,
  betaWelcomeMessageHowToReportStepContent,
  betaWelcomeMessageFinishStepTitle,
  betaWelcomeMessageFinishStepContent,
  liveWelcomeMessageTitle,
  liveWelcomeMessageContent,
  repliesNotificationTeamName,
  repliesNotificationReplyButton,
  repliesNotificationDismissButton
}

enum ReproStepsMode { enabled, disabled, enabledWithNoScreenshots }

class Instabug {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion =>
      _channel.invokeMethod<String>('getPlatformVersion');

  /// Starts the SDK.
  /// This is the main SDK method that does all the magic. This is the only
  /// method that SHOULD be called.
  /// The [token] that identifies the app, you can find
  /// it on your dashboard.
  /// The [invocationEvents] are the events that invoke
  /// the SDK's UI.
  static Future<void> start(
    String token,
    List<InvocationEvent> invocationEvents,
  ) async {
    final invocationEventsStrings =
        invocationEvents.map((e) => e.toString()).toList(growable: false);
    final params = <dynamic>[token, invocationEventsStrings];
    return _channel.invokeMethod(
      'startWithToken:invocationEvents:',
      params,
    );
  }

  /// Shows the welcome message in a specific mode.
  /// [welcomeMessageMode] is an enum to set the welcome message mode to live, or beta.
  static Future<void> showWelcomeMessageWithMode(
    WelcomeMessageMode welcomeMessageMode,
  ) async {
    final params = <dynamic>[welcomeMessageMode.toString()];
    return _channel.invokeMethod('showWelcomeMessageWithMode:', params);
  }

  /// Sets the default value of the user's [email] and hides the email field from the reporting UI
  /// and set the user's [name] to be included with all reports.
  /// It also reset the chats on device to that email and removes user attributes,
  /// user data and completed surveys.
  static Future<void> identifyUser(String email, [String? name]) async {
    final params = <dynamic>[email, name];
    return _channel.invokeMethod('identifyUserWithEmail:name:', params);
  }

  /// Sets the default value of the user's email to nil and show email field and remove user name
  /// from all reports
  /// It also reset the chats on device and removes user attributes, user data and completed surveys.
  static Future<void> logOut() async {
    return _channel.invokeMethod('logOut');
  }

  /// Sets the SDK's [locale].
  /// Use to change the SDK's UI to different language.
  /// Defaults to the device's current locale.
  static Future<void> setLocale(IBGLocale locale) async {
    final params = <dynamic>[locale.toString()];
    return _channel.invokeMethod('setLocale:', params);
  }

  /// Sets the verbosity level of logs used to debug The SDK. The defualt value in debug
  /// mode is sdkDebugLogsLevelVerbose and in production is sdkDebugLogsLevelError.
  static Future<void> setSdkDebugLogsLevel(
    IBGSDKDebugLogsLevel sdkDebugLogsLevel,
  ) async {
    final params = <dynamic>[sdkDebugLogsLevel.toString()];
    return _channel.invokeMethod('setSdkDebugLogsLevel:', params);
  }

  /// Sets the color theme of the SDK's whole UI to the [colorTheme] given.
  /// It should be of type [ColorTheme].
  static Future<void> setColorTheme(ColorTheme colorTheme) async {
    final params = <dynamic>[colorTheme.toString()];
    return _channel.invokeMethod('setColorTheme:', params);
  }

  /// Appends a set of [tags] to previously added tags of reported feedback, bug or crash.
  static Future<void> appendTags(List<String> tags) async {
    final params = <dynamic>[tags];
    return _channel.invokeMethod('appendTags:', params);
  }

  /// Manually removes all tags of reported feedback, bug or crash.
  static Future<void> resetTags() async {
    return _channel.invokeMethod('resetTags');
  }

  /// Gets all tags of reported feedback, bug or crash. Returns the list of tags.
  static Future<List<String>?> getTags() async {
    final tags = await _channel.invokeMethod<List<dynamic>>('getTags');
    return tags?.cast<String>();
  }

  /// Adds experiments to the next report.
  static Future<void> addExperiments(List<String> experiments) async {
    final params = <dynamic>[experiments];
    return _channel.invokeMethod('addExperiments:', params);
  }

  /// Removes certain experiments from the next report.
  static Future<void> removeExperiments(List<String> experiments) async {
    final params = <dynamic>[experiments];
    return _channel.invokeMethod('removeExperiments:', params);
  }

  /// Clears all experiments from the next report.
  static Future<void> clearAllExperiments() async {
    return _channel.invokeMethod('clearAllExperiments');
  }

  /// Add custom user attribute [value] with a [key] that is going to be sent with each feedback, bug or crash.
  static Future<void> setUserAttribute(String value, String key) async {
    final params = <dynamic>[value, key];
    return _channel.invokeMethod('setUserAttribute:withKey:', params);
  }

  /// Removes a given [key] and its associated value from user attributes.
  /// Does nothing if a [key] does not exist.
  static Future<void> removeUserAttribute(String key) async {
    final params = <dynamic>[key];
    return _channel.invokeMethod('removeUserAttributeForKey:', params);
  }

  /// Returns the user attribute associated with a given [key].
  static Future<String?> getUserAttributeForKey(String key) {
    final params = <dynamic>[key];
    return _channel.invokeMethod<String>(
      'getUserAttributeForKey:',
      params,
    );
  }

  /// A new Map containing all the currently set user attributes, or an empty Map if no user attributes have been set.
  static Future<Map<String, String>> getUserAttributes() async {
    final userAttributes =
        await _channel.invokeMethod<Map<dynamic, dynamic>>('getUserAttributes');
    return userAttributes != null
        ? Map<String, String>.from(userAttributes)
        : <String, String>{};
  }

  /// invoke sdk manually
  static Future<void> show() async {
    return _channel.invokeMethod('show');
  }

  /// Logs a user event with [name] that happens through the lifecycle of the application.
  /// Logged user events are going to be sent with each report, as well as at the end of a session.
  static Future<void> logUserEvent(String name) async {
    final params = <String>[name];
    return _channel.invokeMethod('logUserEventWithName:', params);
  }

  /// Overrides any of the strings shown in the SDK with custom ones.
  /// Allows you to customize a [value] shown to users in the SDK using a predefined [key].
  static Future<void> setValueForStringWithKey(
    String value,
    CustomTextPlaceHolderKey key,
  ) async {
    final params = <dynamic>[value, key.toString()];
    return _channel.invokeMethod('setValue:forStringWithKey:', params);
  }

  /// Enable/disable session profiler
  /// [sessionProfilerEnabled] desired state of the session profiler feature.
  static Future<void> setSessionProfilerEnabled(
    bool sessionProfilerEnabled,
  ) async {
    final params = <dynamic>[sessionProfilerEnabled];
    return _channel.invokeMethod('setSessionProfilerEnabled:', params);
  }

  /// Android only
  /// Enable/disable SDK logs
  /// [debugEnabled] desired state of debug mode.
  static Future<void> setDebugEnabled(bool debugEnabled) async {
    if (IBGBuildInfo.instance.isAndroid) {
      final params = <dynamic>[debugEnabled];
      return _channel.invokeMethod('setDebugEnabled:', params);
    }
  }

  /// Sets the primary color of the SDK's UI.
  /// Sets the color of UI elements indicating interactivity or call to action.
  /// [color] primaryColor A color to set the UI elements of the SDK to.
  static Future<void> setPrimaryColor(Color color) async {
    final params = <dynamic>[color.value];
    return _channel.invokeMethod('setPrimaryColor:', params);
  }

  /// Adds specific user data that you need to be added to the reports
  /// [userData] data to be added
  static Future<void> setUserData(String userData) async {
    final params = <dynamic>[userData];
    return _channel.invokeMethod('setUserData:', params);
  }

  ///Add file to be attached to the bug report.
  ///[filePath] of the file
  ///[fileName] of the file
  static Future<void> addFileAttachmentWithURL(
    String filePath,
    String fileName,
  ) async {
    if (IBGBuildInfo.instance.isIOS) {
      final params = <dynamic>[filePath];
      return _channel.invokeMethod('addFileAttachmentWithURL:', params);
    } else {
      final params = <dynamic>[filePath, fileName];
      return _channel.invokeMethod('addFileAttachmentWithURL:', params);
    }
  }

  ///Add file to be attached to the bug report.
  ///[data] of the file
  ///[fileName] of the file
  static Future<void> addFileAttachmentWithData(
    Uint8List data,
    String fileName,
  ) async {
    if (IBGBuildInfo.instance.isIOS) {
      final params = <dynamic>[data];
      return _channel.invokeMethod('addFileAttachmentWithData:', params);
    } else {
      final params = <dynamic>[data, fileName];
      return _channel.invokeMethod('addFileAttachmentWithData:', params);
    }
  }

  ///Clears all Uris of the attached files.
  ///The URIs which added via {@link Instabug#addFileAttachment} API not the physical files.
  static Future<void> clearFileAttachments() async {
    return _channel.invokeMethod('clearFileAttachments');
  }

  ///Sets the welcome message mode to live, beta or disabled.
  ///[welcomeMessageMode] An enum to set the welcome message mode to live, beta or disabled.
  static Future<void> setWelcomeMessageMode(
    WelcomeMessageMode welcomeMessageMode,
  ) async {
    final params = <dynamic>[welcomeMessageMode.toString()];
    return _channel.invokeMethod('setWelcomeMessageMode:', params);
  }

  ///Reports that the screen has been changed (repro steps)
  ///[screenName] String containing the screen name
  static Future<void> reportScreenChange(String screenName) async {
    final params = <dynamic>[screenName];
    return _channel.invokeMethod('reportScreenChange:', params);
  }

  ///Sets the repro steps mode
  ///[mode] repro steps mode
  static Future<void> setReproStepsMode(ReproStepsMode reproStepsMode) async {
    final params = <dynamic>[reproStepsMode.toString()];
    return _channel.invokeMethod('setReproStepsMode:', params);
  }

  ///Android Only
  ///Enables all Instabug functionality
  static Future<void> enableAndroid() async {
    if (IBGBuildInfo.instance.isAndroid) {
      return _channel.invokeMethod('enable:');
    }
  }

  ///Android Only
  ///Disables all Instabug functionality
  static Future<void> disableAndroid() async {
    if (IBGBuildInfo.instance.isAndroid) {
      return _channel.invokeMethod('disable:');
    }
  }
}
