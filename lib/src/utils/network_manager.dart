import 'dart:async';

import 'package:instabug_flutter/instabug_flutter.dart';

typedef ObfuscateLogCallback = FutureOr<NetworkData> Function(NetworkData data);
typedef OmitLogCallback = FutureOr<bool> Function(NetworkData data);

/// Mockable [NetworkManager] responsible for processing network logs
/// before they are sent to the native SDKs.
class NetworkManager {
  ObfuscateLogCallback? _obfuscateLogCallback;
  OmitLogCallback? _omitLogCallback;

  // ignore: use_setters_to_change_properties
  void setObfuscateLogCallback(ObfuscateLogCallback callback) {
    _obfuscateLogCallback = callback;
  }

  // ignore: use_setters_to_change_properties
  void setOmitLogCallback(OmitLogCallback callback) {
    _omitLogCallback = callback;
  }

  FutureOr<NetworkData> obfuscateLog(NetworkData data) {
    if (_obfuscateLogCallback == null) {
      return data;
    }

    return _obfuscateLogCallback!(data);
  }

  /// Registers a callback to selectively omit network log data.
  ///
  /// Use this method to set a callback function that determines whether
  /// specific network log data should be excluded before recording or displaying it.
  ///
  /// The [callback] function takes a [NetworkData] object as its argument and
  /// should return a boolean value indicating whether the data should be omitted
  /// (true) or included (false).
  ///
  /// Example:
  ///
  /// ```dart
  /// NetworkLogger.omitLog((data) {
  ///   // Implement logic to decide whether to omit the data.
  ///   // For example, check if it contains a specific keyword and return false, otherwise return true.
  ///   return someCondition ? true : false;
  /// });
  /// ```
  FutureOr<bool> omitLog(NetworkData data) {
    if (_omitLogCallback == null) {
      return false;
    }

    return _omitLogCallback!(data);
  }
}
