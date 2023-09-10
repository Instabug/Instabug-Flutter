import 'dart:async';

import 'package:instabug_flutter/instabug_flutter.dart';

typedef ObfuscateLogCallback = FutureOr<NetworkData> Function(NetworkData data);

/// Mockable [NetworkManager] responsible for processing network logs
/// before they are sent to the native SDKs.
class NetworkManager {
  ObfuscateLogCallback? _obfuscateLogCallback;

  // ignore: use_setters_to_change_properties
  void setObfuscateLogCallback(ObfuscateLogCallback callback) {
    _obfuscateLogCallback = callback;
  }

  /// Registers a callback to selectively obfuscate network log data.
  ///
  /// Use this method to set a callback function that determines whether
  /// specific network log data should undergo obfuscation before being recorded
  /// or logged.
  ///
  /// The [callback] function takes a [NetworkData] object as its argument and
  /// should return a modified [NetworkData] object with sensitive information
  /// obfuscated.
  ///
  /// Example:
  ///
  /// ```dart
  /// NetworkLogger.obfuscateLog((data) {
  ///   // Implement custom logic to obfuscate sensitive data here.
  ///   // Modify 'data' as needed and return it.
  /// });
  /// ```
  FutureOr<NetworkData> obfuscateLog(NetworkData data) {
    if (_obfuscateLogCallback == null) {
      return data;
    }

    return _obfuscateLogCallback!(data);
  }
}
