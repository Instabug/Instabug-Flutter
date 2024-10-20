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

  FutureOr<bool> omitLog(NetworkData data) {
    if (_omitLogCallback == null) {
      return false;
    }

    return _omitLogCallback!(data);
  }
}
