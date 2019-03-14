import 'dart:async';
import 'dart:collection';

import 'package:flutter/services.dart';

enum InvocationEvent {
  shake,
  screenshot,
  twoFingersSwipeLeft,
  floatingButton,
  none
}

enum WelcomeMessageMode { live, beta, disabled }

enum Locale {
  Arabic,
  ChineseSimplified,
  ChineseTraditional,
  Czech,
  Danish,
  Dutch,
  English,
  French,
  German,
  Italian,
  Japanese,
  Korean,
  Polish,
  PortugueseBrazil,
  PortuguesePortugal,
  Russian,
  Spanish,
  Swedish,
  Turkish,
  Indonesian,
  Slovak,
  Norwegian
}

enum InvocationMode {
  BUG,
  FEEDBACK,
  CHATS,
  REPLIES
}

enum InvocationOption {
  COMMENT_FIELD_REQUIRED,
  DISABLE_POST_SENDING_DIALOG,
  EMAIL_FIELD_HIDDEN,
  EMAIL_FIELD_OPTIONAL
}


enum ColorTheme { dark, light }

enum IBGCustomTextPlaceHolderKey {
  SHAKE_HINT,
  SWIPE_HINT,
  INVALID_EMAIL_MESSAGE,
  INVALID_COMMENT_MESSAGE,
  INVOCATION_HEADER,
  START_CHATS,
  REPORT_BUG,
  REPORT_FEEDBACK,
  EMAIL_FIELD_HINT,
  COMMENT_FIELD_HINT_FOR_BUG_REPORT,
  COMMENT_FIELD_HINT_FOR_FEEDBACK,
  ADD_VOICE_MESSAGE,
  ADD_IMAGE_FROM_GALLERY,
  ADD_EXTRA_SCREENSHOT,
  CONVERSATIONS_LIST_TITLE,
  AUDIO_RECORDING_PERMISSION_DENIED,
  CONVERSATION_TEXT_FIELD_HINT,
  BUG_REPORT_HEADER,
  FEEDBACK_REPORT_HEADER,
  VOICE_MESSAGE_PRESS_AND_HOLD_TO_RECORD,
  VOICE_MESSAGE_RELEASE_TO_ATTACH,
  REPORT_SUCCESSFULLY_SENT,
  SUCCESS_DIALOG_HEADER,
  ADD_VIDEO,
  BETA_WELCOME_MESSAGE_WELCOME_STEP_TITLE,
  BETA_WELCOME_MESSAGE_WELCOME_STEP_CONTENT,
  BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_TITLE,
  BETA_WELCOME_MESSAGE_HOW_TO_REPORT_STEP_CONTENT,
  BETA_WELCOME_MESSAGE_FINISH_STEP_TITLE,
  BETA_WELCOME_MESSAGE_FINISH_STEP_CONTENT,
  LIVE_WELCOME_MESSAGE_TITLE,
  LIVE_WELCOME_MESSAGE_CONTENT
}

class InstabugFlutter {
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
  static void start(String token, List<InvocationEvent> invocationEvents) async {
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
  static void showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode) async {
    final List<dynamic> params = <dynamic>[welcomeMessageMode.toString()];
    await _channel.invokeMethod<Object>('showWelcomeMessageWithMode:', params);
  }

  /// Sets the default value of the user's [email] and hides the email field from the reporting UI
  /// and set the user's [name] to be included with all reports.
  /// It also reset the chats on device to that email and removes user attributes,
  /// user data and completed surveys.
  static void identifyUserWithEmail(String email, [String name]) async {
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
  static void setLocale(Locale locale) async {
    final List<dynamic> params = <dynamic>[locale.toString()];
    await _channel.invokeMethod<Object>('setLocale:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static void logVerbose(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logVerbose:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static void logDebug(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logDebug:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static void logInfo(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logInfo:', params);
  }

  /// Clears Instabug internal log
  static void clearAllLogs() async {
    await _channel.invokeMethod<Object>('clearAllLogs');
  }
  
  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static void logError(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logError:', params);
  }

  /// Appends a log [message] to Instabug internal log
  /// These logs are then sent along the next uploaded report.
  /// All log messages are timestamped
  /// Note: logs passed to this method are NOT printed to console
  static void logWarn(String message) async {
    final List<dynamic> params = <dynamic>[message];
    await _channel.invokeMethod<Object>('logWarn:', params);
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
  static void setUserAttributeWithKey(String value, String key) async {
    final List<dynamic> params = <dynamic>[value, key];
    await _channel.invokeMethod<Object>('setUserAttribute:withKey:', params);
  }

  /// Removes a given [key] and its associated value from user attributes.
  /// Does nothing if a [key] does not exist.
  static void removeUserAttributeForKey(String key) async {
    final List<dynamic> params = <dynamic>[key];
    await _channel.invokeMethod<Object>('removeUserAttributeForKey:', params);
  }

  /// Returns the user attribute associated with a given [key].
  static Future<String> getUserAttributeForKey(String key) async {
    final List<dynamic> params = <dynamic>[key];
    return await _channel.invokeMethod<Object>('getUserAttributeForKey:', params);
  }

  /// A new Map containing all the currently set user attributes, or an empty Map if no user attributes have been set.
  static Future<Map<String, String>> getUserAttributes() async {
    final Object userAttributes = await _channel.invokeMethod<Object>('getUserAttributes');
    return userAttributes != null ? Map<String, String>.from(userAttributes) : <String, String>{};
  }
  
  /// invoke sdk manually
  static void show() async {
    await _channel.invokeMethod<Object>('show');
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

  /// Logs a user event with [name] that happens through the lifecycle of the application.
  /// Logged user events are going to be sent with each report, as well as at the end of a session.
  static void logUserEventWithName(String name) async {
    final List<String> params = <String>[name];
    await _channel.invokeMethod<Object>('logUserEventWithName:', params);
  }
}


