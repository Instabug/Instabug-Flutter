import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/services.dart';

import '../utils/platform_manager.dart';

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
  startChats,
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
  bugReportHeader,
  feedbackReportHeader,
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

  /// Starts the SDK.
  /// This is the main SDK method that does all the magic. This is the only
  /// method that SHOULD be called.
  /// The [token] that identifies the app, you can find
  /// it on your dashboard.
  /// The [invocationEvents] are the events that invoke
  /// the SDK's UI.
  static Future<void> start(
      String token, List<InvocationEvent> invocationEvents) async {
    if (PlatformManager.instance.isIOS()) {
      final invocationEventsStrings =
          invocationEvents.map((e) => e.toString()).toList(growable: false);
      return _channel.invokeMethod(
        'startWithToken:invocationEvents:',
        [token, invocationEventsStrings],
      );
    }
  }

  /// Shows the welcome message in a specific mode.
  /// [welcomeMessageMode] is an enum to set the welcome message mode to live, or beta.
  static Future<void> showWelcomeMessageWithMode(
      WelcomeMessageMode welcomeMessageMode) async {
    return _channel.invokeMethod(
      'showWelcomeMessageWithMode:',
      [welcomeMessageMode.toString()],
    );
  }

  /// Sets the default value of the user's [email] and hides the email field from the reporting UI
  /// and set the user's [name] to be included with all reports.
  /// It also reset the chats on device to that email and removes user attributes,
  /// user data and completed surveys.
  static Future<void> identifyUser(String email, [String? name]) async {
    return _channel.invokeMethod(
      'identifyUserWithEmail:name:',
      [email, name],
    );
  }

  /// Sets the default value of the user's email to nil and show email field and remove user name
  /// from all reports
  /// It also reset the chats on device and removes user attributes, user data and completed surveys.
  static Future<void> logOut() async {
    await _channel.invokeMethod<Object>('logOut');
  }

  /// Sets the SDK's [locale].
  /// Use to change the SDK's UI to different language.
  /// Defaults to the device's current locale.
  static Future<void> setLocale(IBGLocale locale) async {
    return _channel.invokeMethod(
      'setLocale:',
      [locale.toString()],
    );
  }

  /// Sets the verbosity level of logs used to debug The SDK. The defualt value in debug
  /// mode is sdkDebugLogsLevelVerbose and in production is sdkDebugLogsLevelError.
  static Future<void> setSdkDebugLogsLevel(
    IBGSDKDebugLogsLevel sdkDebugLogsLevel,
  ) async {
    return _channel.invokeMethod(
      'setSdkDebugLogsLevel:',
      [sdkDebugLogsLevel.toString()],
    );
  }

  /// Sets the color theme of the SDK's whole UI to the [colorTheme] given.
  /// It should be of type [ColorTheme].
  static Future<void> setColorTheme(ColorTheme colorTheme) async {
    return _channel.invokeMethod(
      'setColorTheme:',
      [colorTheme.toString()],
    );
  }

  /// Appends a set of [tags] to previously added tags of reported feedback, bug or crash.
  static Future<void> appendTags(List<String> tags) async {
    return _channel.invokeMethod(
      'appendTags:',
      [tags],
    );
  }

  /// Manually removes all tags of reported feedback, bug or crash.
  static Future<void> resetTags() async {
    await _channel.invokeMethod<Object>('resetTags');
  }

  /// Gets all tags of reported feedback, bug or crash. Returns the list of tags.
  static Future<List<String>?> getTags() async {
    final tags = await _channel.invokeMethod<List<dynamic>>('getTags');
    return tags?.cast<String>();
  }

  /// Add custom user attribute [value] with a [key] that is going to be sent with each feedback, bug or crash.
  static Future<void> setUserAttribute(String value, String key) async {
    return _channel.invokeMethod(
      'setUserAttribute:withKey:',
      [value, key],
    );
  }

  /// Removes a given [key] and its associated value from user attributes.
  /// Does nothing if a [key] does not exist.
  static Future<void> removeUserAttribute(String key) async {
    return _channel.invokeMethod(
      'removeUserAttributeForKey:',
      [key],
    );
  }

  /// Returns the user attribute associated with a given [key].
  static Future<String?> getUserAttributeForKey(String key) async {
    return _channel.invokeMethod<String>(
      'getUserAttributeForKey:',
      [key],
    );
  }

  /// A new Map containing all the currently set user attributes, or an empty Map if no user attributes have been set.
  static Future<Map<String, String>> getUserAttributes() async {
    final userAttributes = await _channel.invokeMethod<Map<dynamic, dynamic>>(
      'getUserAttributes',
    );
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
    return _channel.invokeMethod('logUserEventWithName:', [name]);
  }

  /// Overrides any of the strings shown in the SDK with custom ones.
  /// Allows you to customize a [value] shown to users in the SDK using a predefined [key].
  static Future<void> setValueForStringWithKey(
      String value, CustomTextPlaceHolderKey key) async {
    return _channel.invokeMethod(
      'setValue:forStringWithKey:',
      [value, key.toString()],
    );
  }

  /// Enable/disable session profiler
  /// [sessionProfilerEnabled] desired state of the session profiler feature.
  static Future<void> setSessionProfilerEnabled(
    bool sessionProfilerEnabled,
  ) async {
    return _channel.invokeMethod(
      'setSessionProfilerEnabled:',
      [sessionProfilerEnabled],
    );
  }

  /// Android only
  /// Enable/disable SDK logs
  /// [debugEnabled] desired state of debug mode.
  static Future<void> setDebugEnabled(bool debugEnabled) async {
    if (PlatformManager.instance.isAndroid()) {
      return _channel.invokeMethod(
        'setDebugEnabled:',
        [debugEnabled],
      );
    }
  }

  /// Sets the primary color of the SDK's UI.
  /// Sets the color of UI elements indicating interactivity or call to action.
  /// [color] primaryColor A color to set the UI elements of the SDK to.
  static Future<void> setPrimaryColor(Color color) async {
    return _channel.invokeMethod(
      'setPrimaryColor:',
      [color.value],
    );
  }

  /// Adds specific user data that you need to be added to the reports
  /// [userData] data to be added
  static Future<void> setUserData(String userData) async {
    return _channel.invokeMethod(
      'setUserData:',
      [userData],
    );
  }

  ///Add file to be attached to the bug report.
  ///[filePath] of the file
  ///[fileName] of the file
  static Future<void> addFileAttachmentWithURL(
    String filePath,
    String fileName,
  ) async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(
        'addFileAttachmentWithURL:',
        [filePath],
      );
    } else {
      return _channel.invokeMethod(
        'addFileAttachmentWithURL:',
        [filePath, fileName],
      );
    }
  }

  ///Add file to be attached to the bug report.
  ///[data] of the file
  ///[fileName] of the file
  static Future<void> addFileAttachmentWithData(
    Uint8List data,
    String fileName,
  ) async {
    if (Platform.isIOS) {
      return _channel.invokeMethod(
        'addFileAttachmentWithData:',
        [data],
      );
    } else {
      return _channel.invokeMethod(
        'addFileAttachmentWithData:',
        [data, fileName],
      );
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
    return _channel.invokeMethod(
      'setWelcomeMessageMode:',
      [welcomeMessageMode.toString()],
    );
  }

  ///Reports that the screen has been changed (repro steps)
  ///[screenName] String containing the screen name
  static Future<void> reportScreenChange(String screenName) async {
    return _channel.invokeMethod(
      'reportScreenChange:',
      [screenName],
    );
  }

  ///Sets the repro steps mode
  ///[mode] repro steps mode
  static Future<void> setReproStepsMode(ReproStepsMode reproStepsMode) async {
    return _channel.invokeMethod(
      'setReproStepsMode:',
      [reproStepsMode.toString()],
    );
  }

  ///Android Only
  ///Enables all Instabug functionality
  static Future<void> enableAndroid() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('enable:');
    }
  }

  ///Android Only
  ///Disables all Instabug functionality
  static Future<void> disableAndroid() async {
    if (Platform.isAndroid) {
      return _channel.invokeMethod('disable:');
    }
  }
}
