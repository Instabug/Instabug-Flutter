import 'dart:async';

import 'package:flutter/services.dart';

enum InvocationEvent { shake, screenshot, twoFingersSwipeLeft, floatingButton, none }

enum WelcomeMessageMode { live, beta, disabled }

enum Locale { Arabic, ChineseSimplified, ChineseTraditional, Czech, Danish, Dutch, English, French,
              German, Italian, Japanese, Korean, Polish, PortugueseBrazil, Russian, Spanish, Swedish, Turkish}

class InstabugFlutter {
  static const MethodChannel _channel =
      const MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /*
   * Starts the SDK.
   * This is the main SDK method that does all the magic. This is the only
   * method that SHOULD be called.
   * @param {string} token The token that identifies the app, you can find
   * it on your dashboard.
   * @param {List<InvocationEvent>} invocationEvents The events that invoke
   * the SDK's UI.
   */
  static void start(String token, List<InvocationEvent> invocationEvents) async {
    List<String> invocationEventsStrings = new List<String>();
    invocationEvents.forEach((e) {
      invocationEventsStrings.add(e.toString());
    });
    Map <String, Object> params = { 'token': token, 'invocationEvents': invocationEventsStrings };
    await _channel.invokeMethod<Object>('startWithToken:invocationEvents:', params);
  }

   /*
   * Shows the welcome message in a specific mode.
   * @param welcomeMessageMode An enum to set the welcome message mode to
   *                           live, or beta.
   *
   */
  static void showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode) async {
    Map <String, Object> params = {'welcomeMessageMode': welcomeMessageMode.toString() };
    await _channel.invokeMethod<Object>('showWelcomeMessageWithMode:', params);
  }

  /*
   * Sets the default value of the user's email and hides the email field from the reporting UI
   * and set the user's name to be included with all reports.
   * It also reset the chats on device to that email and removes user attributes,
   * user data and completed surveys.
   * @param {string} email Email address to be set as the user's email.
   * @param {string} name Name of the user to be set.
   */
  static void identifyUserWithEmail(String email, [String name]) async {
    Map <String, Object> params = {'email': email, 'name': name };
    await _channel.invokeMethod<Object>('identifyUserWithEmail:name:', params);
  }

  /*
   * Sets the default value of the user's email to nil and show email field and remove user name
   * from all reports
   * It also reset the chats on device and removes user attributes, user data and completed surveys.
   */
  static void logOut() async {
    Map <String, Object> params = { };
    await _channel.invokeMethod<Object>('logOut', params);
  }

  /*
   * Sets the SDK's locale.
   * Use to change the SDK's UI to different language.
   * Defaults to the device's current locale.
   * @param {locale} locale A locale to set the SDK to.
   */
  static void setLocale(Locale locale) async {
    Map <String, Object> params = {'locale': locale.toString() };
    await _channel.invokeMethod<Object>('setLocale:', params);
  }

  /*
   * Appends a log message to Instabug internal log
   * These logs are then sent along the next uploaded report.
   * All log messages are timestamped
   * Note: logs passed to this method are NOT printed to console
   * @param {message} the message
   */
  static void logVerbose(String message) async {
    Map <String, Object> params = {'message': message };
    await _channel.invokeMethod<Object>('logVerbose:', params);
  }
  
  /*
   * Appends a log message to Instabug internal log
   * These logs are then sent along the next uploaded report.
   * All log messages are timestamped
   * Note: logs passed to this method are NOT printed to console
   * @param {message} the message
   */
  static void logDebug(String message) async {
    Map <String, Object> params = {'message': message };
    await _channel.invokeMethod<Object>('logDebug:', params);
  }

}
