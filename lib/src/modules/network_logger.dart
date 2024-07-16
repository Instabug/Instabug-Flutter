// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';
import 'package:instabug_flutter/src/utils/w3_header_utils.dart';

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

  /// Registers a callback to selectively omit network log data.
  ///
  /// Use this method to set a callback function that determines whether
  /// specific network log data should be excluded before recording it.
  ///
  /// The [callback] function takes a [NetworkData] object as its argument and
  /// should return a boolean value indicating whether the data should be omitted
  /// (`true`) or included (`false`).
  ///
  /// Example:
  ///
  /// ```dart
  /// NetworkLogger.omitLog((data) {
  ///   // Implement logic to decide whether to omit the data.
  ///   // For example, ignore requests to a specific URL:
  ///   return data.url.startsWith('https://example.com');
  /// });
  /// ```
  static void omitLog(OmitLogCallback callback) {
    _manager.setOmitLogCallback(callback);
  }

  Future<void> networkLog(NetworkData data) async {
    final networkData = await _addW3Header(data);
    final omit = await _manager.omitLog(networkData);
    if (omit) return;
    final obfuscated = await _manager.obfuscateLog(networkData);
    await _host.networkLog(obfuscated.toJson());
    await APM.networkLogAndroid(obfuscated);
  }

  Future<NetworkData> _addW3Header(NetworkData data) async {
    final networkData = data.copyWith();
    final w3Flags = await Future.wait([
      FeatureFlagsManager.isW3ExternalTraceID,
      FeatureFlagsManager.isW3CaughtHeader,
      FeatureFlagsManager.isW3ExternalGeneratedHeader,
    ]);
    final isW3ExternalTraceIDEnabled = w3Flags[0];
    final isW3CaughtHeaderEnabled = w3Flags[1];
    final isW3ExternalGeneratedHeaderEnabled = w3Flags[2];

    if (isW3ExternalTraceIDEnabled == false) {
      return data;
    }
    final isW3HeaderFound = data.requestHeaders.containsKey("traceparent");

    if (data.requestHeaders.containsKey("traceparent") &&
        isW3CaughtHeaderEnabled) {
      return networkData.copyWith(
        isW3cHeaderFound: isW3HeaderFound,
        w3CCaughtHeader: data.requestHeaders['traceparent'].toString(),
      );
    } else if (isW3ExternalGeneratedHeaderEnabled) {
      final w3HeaderData = W3HeaderUtils.generateW3CHeader(
          networkData.startTime.millisecondsSinceEpoch,);

      final int timestampInSeconds = w3HeaderData['timestampInSeconds'];
      final int partialId = w3HeaderData['partialId'];
      final w3cHeader = w3HeaderData['w3cHeader'].toString();
      final headers = networkData.requestHeaders;
      headers['traceparent'] = w3cHeader;
      return networkData.copyWith(
        partialId: partialId,
        networkStartTimeInSeconds: timestampInSeconds,
        w3CGeneratedHeader: w3cHeader,
        isW3cHeaderFound: false,
        requestHeaders: headers,
      );
    }
    return networkData;
  }
}
