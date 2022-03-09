// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';

enum ActionType { requestNewFeature, addCommentToFeature }

class FeatureRequests {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  ///Shows the UI for feature requests list
  static Future<void> show() async {
    await _channel.invokeMethod<Object>('showFeatureRequests');
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
    final params = <dynamic>[isEmailFieldRequired, actionTypesStrings];
    await _channel.invokeMethod<Object>(
        'setEmailFieldRequiredForFeatureRequests:forAction:', params);
  }
}
