import 'dart:async';
import 'package:flutter/services.dart';

enum ActionType {
  requestNewFeature,
  addCommentToFeature
}

class FeatureRequests {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  ///Shows the UI for feature requests list
  static void show() async {
    await _channel.invokeMethod<Object>('showFeatureRequests');
  }

  /// Sets whether users are required to enter an email address or not when sending reports.
  /// Defaults to YES.
  /// [isEmailFieldRequired] A boolean to indicate whether email
  /// field is required or not.
  /// [actionTypes] An enum that indicates which action types will have the isEmailFieldRequired
  static void setEmailFieldRequired(
      bool isEmailFieldRequired, List<ActionType> actionTypes) async {
    final List<String> actionTypesStrings = <String>[];
    if (actionTypes != null) {
      actionTypes.forEach((e) {
        actionTypesStrings.add(e.toString());
      });
    }
    final List<dynamic> params = <dynamic>[
      isEmailFieldRequired,
      actionTypesStrings
    ];
    await _channel.invokeMethod<Object>(
        'setEmailFieldRequiredForFeatureRequests:forAction:', params);
  }
}
