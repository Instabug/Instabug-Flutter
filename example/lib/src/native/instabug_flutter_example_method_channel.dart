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

  static Future<void> causeNdkCrash() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkCrashMethodName);
    } on PlatformException catch (e) {
      log("Failed to cause NDK crash: '${e.message}'.", name: _tag);
    }
  }

  // NDK Crash Methods
  static Future<void> causeNdkSigsegv() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkSigsegvMethodName);
    } on PlatformException catch (e) {
      log("Failed to trigger NDK SIGSEGV: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> causeNdkSigabrt() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkSigabrtMethodName);
    } on PlatformException catch (e) {
      log("Failed to trigger NDK SIGABRT: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> causeNdkSigfpe() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkSigfpeMethodName);
    } on PlatformException catch (e) {
      log("Failed to trigger NDK SIGFPE: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> causeNdkSigill() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkSigillMethodName);
    } on PlatformException catch (e) {
      log("Failed to trigger NDK SIGILL: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> causeNdkSigbus() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkSigbusMethodName);
    } on PlatformException catch (e) {
      log("Failed to trigger NDK SIGBUS: '${e.message}'.", name: _tag);
    }
  }

  static Future<void> causeNdkSigtrap() async {
    try {
      await _channel.invokeMethod(Constants.causeNdkSigtrapMethodName);
    } on PlatformException catch (e) {
      log("Failed to trigger NDK SIGTRAP: '${e.message}'.", name: _tag);
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

  // NDK Crash Method Names
  static const causeNdkCrashMethodName = "causeNdkCrash";
  static const causeNdkSigsegvMethodName = "causeSIGSEGVCrash";
  static const causeNdkSigabrtMethodName = "causeSIGABRTCrash";
  static const causeNdkSigfpeMethodName = "causeSIGFPECrash";
  static const causeNdkSigillMethodName = "causeSIGILLCrash";
  static const causeNdkSigbusMethodName = "causeSIGBUSCrash";
  static const causeNdkSigtrapMethodName = "causeSIGTRAPCrash";
}
