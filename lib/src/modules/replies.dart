// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:instabug_flutter/generated/replies.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:meta/meta.dart';

typedef HasChatsCallback = void Function(bool);
typedef OnNewReplyReceivedCallback = void Function();
typedef UnreadRepliesCountCallback = void Function(int);

class Replies implements RepliesFlutterApi {
  static var _host = RepliesHostApi();
  static final _instance = Replies();

  static OnNewReplyReceivedCallback? _onNewReplyReceivedCallback;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(RepliesHostApi host) {
    _host = host;
  }

  @internal
  static void init() {
    RepliesFlutterApi.setup(_instance);
  }

  @override
  void onNewReply() {
    _onNewReplyReceivedCallback?.call();
  }

  /// Enables and disables everything related to receiving replies.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  /// Manual invocation for replies.
  static Future<void> show() async {
    return _host.show();
  }

  /// Tells whether the user has chats already or not.
  /// [callback] - callback that is invoked if chats exist
  static Future<void> hasChats(HasChatsCallback callback) async {
    // TODO: return directly without callback
    final hasChats = await _host.hasChats();
    callback(hasChats);
  }

  /// Sets a block of code that gets executed when a new message is received.
  /// [callback] - A callback that gets executed when a new message is received.
  static Future<void> setOnNewReplyReceivedCallback(
    OnNewReplyReceivedCallback callback,
  ) async {
    _onNewReplyReceivedCallback = callback;
    return _host.bindOnNewReplyCallback();
  }

  /// Returns the number of unread messages the user currently has.
  /// Use this method to get the number of unread messages the user
  /// has, then possibly notify them about it with your own UI.
  /// [function] callback with argument
  /// Notifications count, or -1 in case the SDK has not been initialized.
  static Future<void> getUnreadRepliesCount(
    UnreadRepliesCountCallback callback,
  ) async {
    // TODO: return directly without callback
    final count = await _host.getUnreadRepliesCount();
    callback(count);
  }

  /// Enables/disables showing in-app notifications when the user receives a new message.
  /// [isEnabled] A boolean to set whether notifications are enabled or disabled.
  static Future<void> setInAppNotificationsEnabled(bool isEnabled) async {
    return _host.setInAppNotificationsEnabled(isEnabled);
  }

  /// Set whether new in app notification received will play a small sound notification or not (Default is {@code false})
  /// [isEnabled] A boolean to set whether notifications sound should be played.
  /// @android ONLY
  static Future<void> setInAppNotificationSound(bool isEnabled) async {
    if (IBGBuildInfo.instance.isAndroid) {
      return _host.setInAppNotificationsEnabled(isEnabled);
    }
  }
}
