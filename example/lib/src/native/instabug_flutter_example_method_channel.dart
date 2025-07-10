import 'dart:io';

import 'package:flutter/services.dart';
import 'dart:developer';

class InstabugFlutterExampleMethodChannel {
  static const MethodChannel _channel =
      MethodChannel(Constants.methodChannelName);

  static const String _tag = 'InstabugFlutterExampleMethodChannel';

  static Future<void> sendNativeNonFatalCrash(
      [String? exceptionObjection]) async {
    try {
      await _channel.invokeMethod(
          Constants.sendNativeNonFatalCrashMethodName, exceptionObjection);
    } on PlatformException catch (e) {
      log("Failed to send native non-fatal crash: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> sendNativeFatalCrash() async {
    try {
      await _channel.invokeMethod(Constants.sendNativeFatalCrashMethodName);
    } on PlatformException catch (e) {
      log("Failed to send native fatal crash: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> sendNativeFatalHang() async {
    try {
      await _channel.invokeMethod(Constants.sendNativeFatalHangMethodName);
    } on PlatformException catch (e) {
      log("Failed to send native fatal hang: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> sendAnr() async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _channel.invokeMethod(Constants.sendAnrMethodName);
    } on PlatformException catch (e) {
      log("Failed to send ANR: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> sendOom() async {
    try {
      await _channel.invokeMethod(Constants.sendOomMethodName);
    } on PlatformException catch (e) {
      log("Failed to send out of memory: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> setFullscreen(bool isEnabled) async {
    if (!Platform.isAndroid) {
      return;
    }

    try {
      await _channel.invokeMethod(Constants.setFullscreenMethodName, {
        'isEnabled': isEnabled,
      });
    } on PlatformException catch (e) {
      log("Failed to set fullscreen: '${e.message}'.", name: _tag);
    } catch (e) {
      log("Unexpected error setting fullscreen: '$e'.", name: _tag);
    }
  }
}

class Constants {
  static const methodChannelName = "instabug_flutter_example";

  // Method Names
  static const sendNativeNonFatalCrashMethodName = "sendNativeNonFatalCrash";
  static const sendNativeFatalCrashMethodName = "sendNativeFatalCrash";
  static const sendNativeFatalHangMethodName = "sendNativeFatalHang";
  static const sendAnrMethodName = "sendAnr";
  static const sendOomMethodName = "sendOom";
  static const setFullscreenMethodName = "setFullscreen";
}
