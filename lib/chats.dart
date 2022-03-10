import 'dart:async';

import 'package:flutter/services.dart';

class Chats {
  static const MethodChannel _channel = MethodChannel('instabug_flutter');

  @deprecated
  /// Use {@link BugReporting.show} instead.
  /// Manual invocation for chats view.
  static Future<void> show() async => _channel.invokeMethod<Object>('showChats');

  @deprecated
  /// Use {@link BugReporting.setReportTypes} instead.
  /// Enables and disables everything related to creating new chats.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    final params = <dynamic>[isEnabled];
    await _channel.invokeMethod<Object>('setChatsEnabled:', params);
  }
}
