// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';
import 'package:instabug_flutter/src/utils/w3c_header_utils.dart';

class NetworkLogger {
  static var _host = InstabugHostApi();
  static var _manager = NetworkManager();

  static final _w3cHeaders = <int, Map<String, dynamic>>{};

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
    final networkData = await _addW3CHeader(data);
    final omit = await _manager.omitLog(networkData);
    if (omit) return;
    final obfuscated = await _manager.obfuscateLog(networkData);
    await _host.networkLog(obfuscated.toJson());
    await APM.networkLogAndroid(obfuscated);
  }

  Future<NetworkData> _addW3CHeader(NetworkData data) async {
    final networkData = data.copyWith();
    final startTime = networkData.startTime.millisecondsSinceEpoch;
    final w3cData = _w3cHeaders[startTime];
    if (w3cData != null) {
      final isW3cHeaderFound = w3cData['isW3cHeaderFound'] as bool?;
      if (isW3cHeaderFound != null) {
        _w3cHeaders.remove(data.startTime.millisecondsSinceEpoch);

        if (isW3cHeaderFound == true) {
          return networkData.copyWith(
            isW3cHeaderFound: isW3cHeaderFound,
            w3CCaughtHeader: data.requestHeaders['traceparent'].toString(),
          );
        } else {
          return networkData.copyWith(
            partialId: w3cData['partialId'] as num?,
            networkStartTimeInSeconds:
                w3cData['networkStartTimeInSeconds'] as num?,
            w3CGeneratedHeader: w3cData['w3CGeneratedHeader'] as String?,
            isW3cHeaderFound: false,
          );
        }
      }
    }
    return networkData;
  }

  Future<String?> getW3CHeader(
    Map<String, dynamic> header,
    int startTime,
  ) async {
    final w3cFlags = await Future.wait([
      FeatureFlagsManager.isW3ExternalTraceID,
      FeatureFlagsManager.isW3CaughtHeader,
      FeatureFlagsManager.isW3ExternalGeneratedHeader,
    ]);

    final isW3CExternalTraceIDEnabled = w3cFlags[0];
    final isW3CCaughtHeaderEnabled = w3cFlags[1];
    final isW3CExternalGeneratedHeaderEnabled = w3cFlags[2];

    if (isW3CExternalTraceIDEnabled == false) {
      return null;
    }

    final isW3cHeaderFound = header.containsKey("traceparent");

    if (isW3cHeaderFound && isW3CCaughtHeaderEnabled) {
      final w3cMap = {
        "isW3cHeaderFound": isW3cHeaderFound,
        "w3CCaughtHeader": header['traceparent'].toString(),
      };
      _w3cHeaders[startTime] = w3cMap;
      return header['traceparent'].toString();
    } else if (isW3CExternalGeneratedHeaderEnabled) {
      final w3cHeaderData = W3CHeaderUtils.generateW3CHeader(
        startTime,
      );

      final timestampInSeconds = w3cHeaderData['timestampInSeconds'] as int;
      final partialId = w3cHeaderData['partialId'] as int;
      final w3cHeader = w3cHeaderData['w3cHeader'].toString();

      final w3cMap = {
        "partialId": partialId,
        "networkStartTimeInSeconds": timestampInSeconds,
        "w3CGeneratedHeader": w3cHeader,
        "isW3cHeaderFound": false,
      };
      _w3cHeaders[startTime] = w3cMap;

      return w3cHeader;
    }
    return null;
  }
}
