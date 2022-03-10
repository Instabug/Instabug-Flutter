import 'dart:async';

import 'package:flutter/services.dart';

enum ActionType { requestNewFeature, addCommentToFeature }

class FeatureRequests {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  ///Shows the UI for feature requests list
  static Future<void> show() async {
    return _channel.invokeMethod('showFeatureRequests');
  }

  /// Sets whether users are required to enter an email address or not when sending reports.
  /// Defaults to YES.
  /// [isEmailFieldRequired] A boolean to indicate whether email
  /// field is required or not.
  /// [actionTypes] An enum that indicates which action types will have the isEmailFieldRequired
  static Future<void> setEmailFieldRequired(
      bool isEmailFieldRequired, List<ActionType>? actionTypes) async {
    final actionTypesStrings =
        actionTypes?.map((e) => e.toString()).toList(growable: false) ?? [];

    return _channel.invokeMethod(
      'setEmailFieldRequiredForFeatureRequests:forAction:',
      [isEmailFieldRequired, actionTypesStrings],
    );
  }
}
