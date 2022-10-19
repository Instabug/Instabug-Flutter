// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/generated/feature_requests.api.g.dart';

enum ActionType { requestNewFeature, addCommentToFeature }

class FeatureRequests {
  static final _native = FeatureRequestsHostApi();

  /// Shows the UI for feature requests list
  static Future<void> show() async {
    return _native.show();
  }

  /// Sets whether users are required to enter an email address or not when sending reports.
  /// Defaults to YES.
  /// [isRequired] A boolean to indicate whether email
  /// field is required or not.
  /// [actionTypes] An enum that indicates which action types will have the isEmailFieldRequired
  static Future<void> setEmailFieldRequired(
    bool isRequired,
    List<ActionType>? actionTypes,
  ) async {
    final types = actionTypes?.map((e) => e.toString()).toList();
    return _native.setEmailFieldRequired(isRequired, types ?? []);
  }
}
