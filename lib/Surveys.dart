// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/services.dart';

class Surveys {
  static Function? _onShowCallback;
  static Function? _onDismissCallback;
  static Function? _availableSurveysCallback;
  static Function? _hasRespondedToSurveyCallback;
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String?> get platformVersion async =>
      await _channel.invokeMethod<String>('getPlatformVersion');

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onShowSurveyCallback':
        _onShowCallback?.call();
        return;
      case 'onDismissSurveyCallback':
        _onDismissCallback?.call();
        return;
      case 'availableSurveysCallback':
        final List<dynamic> result = call.arguments;
        final params = <String>[];
        for (int i = 0; i < result.length; i++) {
          params.add(result[i].toString());
        }
        _availableSurveysCallback?.call(params);
        return;
      case 'hasRespondedToSurveyCallback':
        _hasRespondedToSurveyCallback?.call(call.arguments);
        return;
    }
  }

  /// @summary Sets whether surveys are enabled or not.
  /// If you disable surveys on the SDK but still have active surveys on your Instabug dashboard,
  /// those surveys are still going to be sent to the device, but are not going to be
  /// shown automatically.
  /// To manually display any available surveys, call `Instabug.showSurveyIfAvailable()`.
  /// Defaults to `true`.
  /// [isEnabled] A boolean to set whether Instabug Surveys is enabled or disabled.
  static Future<void> setEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setSurveysEnabled:', params);
  }

  ///Sets whether auto surveys showing are enabled or not.
  /// [isEnabled] A boolean to indicate whether the
  /// surveys auto showing are enabled or not.
  static Future<void> setAutoShowingEnabled(bool isEnabled) async {
    final List<dynamic> params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>(
        'setAutoShowingSurveysEnabled:', params);
  }

  /// Returns an array containing the available surveys.
  /// [function] availableSurveysCallback callback with
  /// argument available surveys
  static Future<void> getAvailableSurveys(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _availableSurveysCallback = function;
    await _channel.invokeMethod<Object>('getAvailableSurveys');
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes before the survey's UI is shown.
  /// [function]  A callback that gets executed before presenting the survey's UI.
  static Future<void> setOnShowCallback(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onShowCallback = function;
    await _channel.invokeMethod<Object>('setOnShowSurveyCallback');
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes  after the survey's UI is dismissed.
  /// [function]  A callback that gets executed after the survey's UI is dismissed.
  static Future<void> setOnDismissCallback(Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onDismissCallback = function;
    await _channel.invokeMethod<Object>('setOnDismissSurveyCallback');
  }

  /// Setting an option for all the surveys to show a welcome screen before
  /// [shouldShowWelcomeScreen] A boolean for setting whether the  welcome screen should show.
  static Future<void> setShouldShowWelcomeScreen(
      bool shouldShowWelcomeScreen) async {
    final List<dynamic> params = <dynamic>[shouldShowWelcomeScreen];
    await _channel.invokeMethod<Object>(
        'setShouldShowSurveysWelcomeScreen:', params);
  }

  ///  Shows one of the surveys that were not shown before, that also have conditions
  /// that match the current device/user.
  /// Does nothing if there are no available surveys or if a survey has already been shown
  /// in the current session.
  static Future<void> showSurveyIfAvailable() async {
    await _channel.invokeMethod<Object>('showSurveysIfAvailable');
  }

  /// Shows survey with a specific token.
  /// Does nothing if there are no available surveys with that specific token.
  /// Answered and cancelled surveys won't show up again.
  /// [surveyToken] - A String with a survey token.
  static Future<void> showSurvey(String surveyToken) async {
    final List<dynamic> params = <dynamic>[surveyToken];
    await _channel.invokeMethod<Object>('showSurveyWithToken:', params);
  }

  /// Sets a block of code to be executed just before the SDK's UI is presented.
  /// This block is executed on the UI thread. Could be used for performing any
  /// UI changes  after the survey's UI is dismissed.
  /// [function]  A callback that gets executed after the survey's UI is dismissed.
  static Future<void> hasRespondedToSurvey(
      String surveyToken, Function function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _hasRespondedToSurveyCallback = function;
    final List<dynamic> params = <dynamic>[surveyToken];
    await _channel.invokeMethod<Object>(
        'hasRespondedToSurveyWithToken:', params);
  }

  /// iOS Only
  /// @summary Sets url for the published iOS app on AppStore, You can redirect
  /// NPS Surveys or AppRating Surveys to AppStore to let users rate your app on AppStore itself.
  /// [appStoreURL] A String url for the published iOS app on AppStore
  static Future<void> setAppStoreURL(String appStoreURL) async {
    if (Platform.isIOS) {
      final List<dynamic> params = <dynamic>[appStoreURL];
      await _channel.invokeMethod<Object>('setAppStoreURL:', params);
    }
  }
}
