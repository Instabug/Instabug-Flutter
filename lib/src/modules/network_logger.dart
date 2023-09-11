// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';

class NetworkLogger {
  static var _host = InstabugHostApi();
  static var _manager = NetworkManager();

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(InstabugHostApi host) {
    _host = host;
  }

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setManager(NetworkManager manager) {
    _manager = manager;
  }

  /// Registers a callback to selectively obfuscate network log data.
  ///
  /// The [callback] function takes a [NetworkData] object as its argument and
  /// should return a modified [NetworkData] object with sensitive information
  /// obfuscated.
  ///
  /// Example:
  ///
  /// ```dart
  /// NetworkLogger.obfuscateLog((data) {
  ///   // Modify 'data' as needed and return it.
  /// });
  /// ```
  static void obfuscateLog(ObfuscateLogCallback callback) {
    _manager.setObfuscateLogCallback(callback);
  }

  Future<void> networkLog(NetworkData data) async {
    final obfuscated = await _manager.obfuscateLog(data);

    await _host.networkLog(obfuscated.toJson());
    await APM.networkLogAndroid(obfuscated);
  }
}
