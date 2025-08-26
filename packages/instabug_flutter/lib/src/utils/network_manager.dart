import 'dart:async';

import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/instabug_constants.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';

typedef ObfuscateLogCallback = FutureOr<NetworkData> Function(NetworkData data);
typedef OmitLogCallback = FutureOr<bool> Function(NetworkData data);

/// Mockable [NetworkManager] responsible for processing network logs
/// before they are sent to the native SDKs.
class NetworkManager {
  ObfuscateLogCallback? _obfuscateLogCallback;
  OmitLogCallback? _omitLogCallback;
  int? _cachedNetworkBodyMaxSize;
  final int _defaultNetworkBodyMaxSize = 10240; // in bytes
  final _host = InstabugHostApi();

  NetworkManager() {
    // Register for network body max size changes
    FeatureFlagsManager().onNetworkBodyMaxSizeChangeCallback = () {
      clearNetworkBodyMaxSizeCache();
    };
  }

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

  /// Checks if network request body exceeds backend size limits
  ///
  /// Returns true if request body size exceeds the limit
  Future<bool> didRequestBodyExceedSizeLimit(NetworkData data) async {
    try {
      final limit = await _getNetworkBodyMaxSize();
      if (limit == null) {
        return false; // If we can't get the limit, don't block logging
      }

      final requestExceeds = data.requestBodySize > limit;
      if (requestExceeds) {
        InstabugLogger.I.d(
          InstabugConstants.getNetworkBodyLimitExceededMessage(
            type: 'request',
            bodySize: data.requestBodySize,
          ),
          tag: InstabugConstants.networkManagerTag,
        );
      }

      return requestExceeds;
    } catch (error) {
      InstabugLogger.I.e(
        'Error checking network request body size limit: $error',
        tag: InstabugConstants.networkManagerTag,
      );
      return false; // Don't block logging on error
    }
  }

  /// Checks if network response body exceeds backend size limits
  ///
  /// Returns true if response body size exceeds the limit
  Future<bool> didResponseBodyExceedSizeLimit(NetworkData data) async {
    try {
      final limit = await _getNetworkBodyMaxSize();
      if (limit == null) {
        return false; // If we can't get the limit, don't block logging
      }

      final responseExceeds = data.responseBodySize > limit;
      if (responseExceeds) {
        InstabugLogger.I.d(
          InstabugConstants.getNetworkBodyLimitExceededMessage(
            type: 'response',
            bodySize: data.responseBodySize,
          ),
          tag: InstabugConstants.networkManagerTag,
        );
      }

      return responseExceeds;
    } catch (error) {
      InstabugLogger.I.e(
        'Error checking network response body size limit: $error',
        tag: InstabugConstants.networkManagerTag,
      );
      return false; // Don't block logging on error
    }
  }

  /// Gets the network body max size from native SDK, with caching
  Future<int?> _getNetworkBodyMaxSize() async {
    if (_cachedNetworkBodyMaxSize != null) {
      return _cachedNetworkBodyMaxSize;
    }

    final ffmNetworkBodyLimit = FeatureFlagsManager().networkBodyMaxSize;

    if (ffmNetworkBodyLimit > 0) {
      _cachedNetworkBodyMaxSize = ffmNetworkBodyLimit;
      return ffmNetworkBodyLimit;
    }

    try {
      final limit = await _host.getNetworkBodyMaxSize();
      _cachedNetworkBodyMaxSize = limit?.toInt();
      return limit?.toInt();
    } catch (error) {
      InstabugLogger.I.e(
        'Failed to get network body max size from native API: $error'
        '\n'
        'Setting it to the default value of $_defaultNetworkBodyMaxSize bytes = ${_defaultNetworkBodyMaxSize / 1024} KB',
        tag: InstabugConstants.networkManagerTag,
      );
      _cachedNetworkBodyMaxSize = _defaultNetworkBodyMaxSize;
      return _defaultNetworkBodyMaxSize;
    }
  }

  /// Clears the cached network body max size
  void clearNetworkBodyMaxSizeCache() {
    _cachedNetworkBodyMaxSize = null;
  }
}
