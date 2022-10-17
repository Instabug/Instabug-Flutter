// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/services.dart';
import 'package:instabug_flutter/generated/replies.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';

typedef HasChatsCallback = void Function(bool);
typedef OnNewReplyReceivedCallback = void Function();
typedef UnreadRepliesCountCallback = void Function(int);

class Replies {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');
  static final _native = RepliesApi();

  static HasChatsCallback? _hasChatsCallback;
  static OnNewReplyReceivedCallback? _onNewReplyReceivedCallback;
  static UnreadRepliesCountCallback? _unreadRepliesCountCallback;

  static Future<dynamic> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'hasChatsCallback':
        _hasChatsCallback?.call(call.arguments as bool);
        return;
      case 'onNewReplyReceivedCallback':
        _onNewReplyReceivedCallback?.call();
        return;
      case 'unreadRepliesCountCallback':
        _unreadRepliesCountCallback?.call(call.arguments as int);
        return;
    }
  }

  /// Enables and disables everything related to receiving replies.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _native.setEnabled(isEnabled);
  }

  ///Manual invocation for replies.
  static Future<void> show() async {
    return _native.show();
  }

  /// Tells whether the user has chats already or not.
  ///  [function] - callback that is invoked if chats exist
  static Future<void> hasChats(HasChatsCallback function) async {
    _channel.setMethodCallHandler(_handleMethod);
    _hasChatsCallback = function;
    return _channel.invokeMethod('hasChats');
  }

  ///  Sets a block of code that gets executed when a new message is received.
  ///  [function] -  A callback that gets executed when a new message is received.
  static Future<void> setOnNewReplyReceivedCallback(
    OnNewReplyReceivedCallback function,
  ) async {
    _channel.setMethodCallHandler(_handleMethod);
    _onNewReplyReceivedCallback = function;
    return _channel.invokeMethod('setOnNewReplyReceivedCallback');
  }

  /// Returns the number of unread messages the user currently has.
  /// Use this method to get the number of unread messages the user
  /// has, then possibly notify them about it with your own UI.
  /// [function] callback with argument
  /// Notifications count, or -1 in case the SDK has not been initialized.
  static Future<void> getUnreadRepliesCount(
    UnreadRepliesCountCallback function,
  ) async {
    _channel.setMethodCallHandler(_handleMethod);
    _unreadRepliesCountCallback = function;
    return _channel.invokeMethod('getUnreadRepliesCount');
  }

  /// Enables/disables showing in-app notifications when the user receives a new message.
  /// [isEnabled] A boolean to set whether notifications are enabled or disabled.
  static Future<void> setInAppNotificationsEnabled(bool isEnabled) async {
    return _native.setInAppNotificationsEnabled(isEnabled);
  }

  /// Set whether new in app notification received will play a small sound notification or not (Default is {@code false})
  /// [isEnabled] A boolean to set whether notifications sound should be played.
  /// @android ONLY
  static Future<void> setInAppNotificationSound(bool isEnabled) async {
    if (IBGBuildInfo.instance.isAndroid) {
      return _native.setInAppNotificationsEnabled(isEnabled);
    }
  }
}
