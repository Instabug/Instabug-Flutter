import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/services.dart';

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
  liveWelcomeMessageContent
}

enum ReproStepsMode { enabled, disabled, enabledWithNoScreenshots }

class Instabug {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// Starts the SDK.
  /// This is the main SDK method that does all the magic. This is the only
  /// method that SHOULD be called.
  /// The [token] that identifies the app, you can find
  /// it on your dashboard.
  /// The [invocationEvents] are the events that invoke
  /// the SDK's UI.
  static void start(
      String token, List<InvocationEvent> invocationEvents) async {
    final List<String> invocationEventsStrings = <String>[];
    invocationEvents.forEach((e) {
      invocationEventsStrings.add(e.toString());
    });
    final List<dynamic> params = <dynamic>[token, invocationEventsStrings];
    await _channel.invokeMethod<Object>(
        'startWithToken:invocationEvents:', params);
  }

  /// Shows the welcome message in a specific mode.
  /// [welcomeMessageMode] is an enum to set the welcome message mode to live, or beta.
  static void showWelcomeMessageWithMode(
      WelcomeMessageMode welcomeMessageMode) async {
    final List<dynamic> params = <dynamic>[welcomeMessageMode.toString()];
    await _channel.invokeMethod<Object>('showWelcomeMessageWithMode:', params);
  }

  /// Sets the default value of the user's [email] and hides the email field from the reporting UI
  /// and set the user's [name] to be included with all reports.
  /// It also reset the chats on device to that email and removes user attributes,
  /// user data and completed surveys.
  static void identifyUser(String email, [String name]) async {
    final List<dynamic> params = <dynamic>[email, name];
    await _channel.invokeMethod<Object>('identifyUserWithEmail:name:', params);
  }

  /// Sets the default value of the user's email to nil and show email field and remove user name
  /// from all reports
  /// It also reset the chats on device and removes user attributes, user data and completed surveys.
  static void logOut() async {
    await _channel.invokeMethod<Object>('logOut');
  }

  /// Sets the SDK's [locale].
  /// Use to change the SDK's UI to different language.
  /// Defaults to the device's current locale.
  static void setLocale(IBGLocale locale) async {
    final List<dynamic> params = <dynamic>[locale.toString()];
    await _channel.invokeMethod<Object>('setLocale:', params);
  }

  /// Sets the color theme of the SDK's whole UI to the [colorTheme] given.
  /// It should be of type [ColorTheme].
  static void setColorTheme(ColorTheme colorTheme) async {
    final List<dynamic> params = <dynamic>[colorTheme.toString()];
    await _channel.invokeMethod<Object>('setColorTheme:', params);
  }

  /// Appends a set of [tags] to previously added tags of reported feedback, bug or crash.
  static void appendTags(List<String> tags) async {
    final List<dynamic> params = <dynamic>[tags];
    await _channel.invokeMethod<Object>('appendTags:', params);
  }

  /// Manually removes all tags of reported feedback, bug or crash.
  static void resetTags() async {
    await _channel.invokeMethod<Object>('resetTags');
  }

  /// Gets all tags of reported feedback, bug or crash. Returns the list of tags.
  static Future<List<String>> getTags() async {
    final List<dynamic> tags = await _channel.invokeMethod<Object>('getTags');
    return tags != null ? tags.cast<String>() : null;
  }

  /// Add custom user attribute [value] with a [key] that is going to be sent with each feedback, bug or crash.
  static void setUserAttribute(String value, String key) async {
    final List<dynamic> params = <dynamic>[value, key];
    await _channel.invokeMethod<Object>('setUserAttribute:withKey:', params);
  }

  /// Removes a given [key] and its associated value from user attributes.
  /// Does nothing if a [key] does not exist.
  static void removeUserAttribute(String key) async {
    final List<dynamic> params = <dynamic>[key];
    await _channel.invokeMethod<Object>('removeUserAttributeForKey:', params);
  }

  /// Returns the user attribute associated with a given [key].
  static Future<String> getUserAttributeForKey(String key) async {
    final List<dynamic> params = <dynamic>[key];
    return await _channel.invokeMethod<Object>(
        'getUserAttributeForKey:', params);
  }

  /// A new Map containing all the currently set user attributes, or an empty Map if no user attributes have been set.
  static Future<Map<String, String>> getUserAttributes() async {
    final Object userAttributes =
        await _channel.invokeMethod<Object>('getUserAttributes');
    return userAttributes != null
        ? Map<String, String>.from(userAttributes)
        : <String, String>{};
  }

  /// invoke sdk manually
  static void show() async {
    await _channel.invokeMethod<Object>('show');
  }

  /// Logs a user event with [name] that happens through the lifecycle of the application.
  /// Logged user events are going to be sent with each report, as well as at the end of a session.
  static void logUserEvent(String name) async {
    final List<String> params = <String>[name];
    await _channel.invokeMethod<Object>('logUserEventWithName:', params);
  }

  /// Overrides any of the strings shown in the SDK with custom ones.
  /// Allows you to customize a [value] shown to users in the SDK using a predefined [key].
  static void setValueForStringWithKey(
      String value, CustomTextPlaceHolderKey key) async {
    final List<dynamic> params = <dynamic>[value, key.toString()];
    await _channel.invokeMethod<Object>('setValue:forStringWithKey:', params);
  }

  /// Enable/disable session profiler
  /// [sessionProfilerEnabled] desired state of the session profiler feature.
  static void setSessionProfilerEnabled(bool sessionProfilerEnabled) async {
    final List<dynamic> params = <dynamic>[sessionProfilerEnabled];
    await _channel.invokeMethod<Object>('setSessionProfilerEnabled:', params);
  }

  /// Sets the primary color of the SDK's UI.
  /// Sets the color of UI elements indicating interactivity or call to action.
  /// [color] primaryColor A color to set the UI elements of the SDK to.
  static void setPrimaryColor(Color color) async {
    final List<dynamic> params = <dynamic>[color.value];
    await _channel.invokeMethod<Object>('setPrimaryColor:', params);
  }

  /// Adds specific user data that you need to be added to the reports
  /// [userData] data to be added
  static void setUserData(String userData) async {
    final List<dynamic> params = <dynamic>[userData];
    await _channel.invokeMethod<Object>('setUserData:', params);
  }

  ///Add file to be attached to the bug report.
  ///[filePath] of the file
  ///[fileName] of the file
  static void addFileAttachmentWithURL(String filePath, String fileName) async {
    if (Platform.isIOS) {
      final List<dynamic> params = <dynamic>[filePath];
      await _channel.invokeMethod<Object>('addFileAttachmentWithURL:', params);
    } else {
      final List<dynamic> params = <dynamic>[filePath, fileName];
      await _channel.invokeMethod<Object>('addFileAttachmentWithURL:', params);
    }
  }

  ///Add file to be attached to the bug report.
  ///[data] of the file
  ///[fileName] of the file
  static void addFileAttachmentWithData(Uint8List data, String fileName) async {
    if (Platform.isIOS) {
      final List<dynamic> params = <dynamic>[data];
      await _channel.invokeMethod<Object>('addFileAttachmentWithData:', params);
    } else {
      final List<dynamic> params = <dynamic>[data, fileName];
      await _channel.invokeMethod<Object>('addFileAttachmentWithData:', params);
    }
  }

  ///Clears all Uris of the attached files.
  ///The URIs which added via {@link Instabug#addFileAttachment} API not the physical files.
  static void clearFileAttachments() async {
    await _channel.invokeMethod<Object>('clearFileAttachments');
  }

  ///Sets the welcome message mode to live, beta or disabled.
  ///[welcomeMessageMode] An enum to set the welcome message mode to live, beta or disabled.
  static void setWelcomeMessageMode(
      WelcomeMessageMode welcomeMessageMode) async {
    final List<dynamic> params = <dynamic>[welcomeMessageMode.toString()];
    await _channel.invokeMethod<Object>('setWelcomeMessageMode:', params);
  }

  ///Reports that the screen has been changed (repro steps)
  ///[screenName] String containing the screen name
  static void reportScreenChange(String screenName) async {
    final List<dynamic> params = <dynamic>[screenName];
    await _channel.invokeMethod<Object>('reportScreenChange:', params);
  }

  ///Sets the repro steps mode
  ///[mode] repro steps mode
  static void setReproStepsMode(ReproStepsMode reproStepsMode) async {
    final List<dynamic> params = <dynamic>[reproStepsMode.toString()];
    await _channel.invokeMethod<Object>('setReproStepsMode:', params);
  }
}
