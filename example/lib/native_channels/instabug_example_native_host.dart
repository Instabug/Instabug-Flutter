import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Class for invoking native method channels
///
/// Exposes methods for invoking native method channels
class InstabugExampleNativeHost {
  /// Method channel for invoking native methods
  static final _methodChannel = const MethodChannel(methodChannelName);

  static Future<void> sendNDKCrash() async {
    try {
      await _methodChannel.invokeMethod('sendNDKCrash');
    } on PlatformException catch (e) {
      debugPrint('Failed to send NDK crash: ${e.message}');
    }
  }
}

const methodChannelName = 'instabug_example_native_method_channel';
