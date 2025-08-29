// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/models/network_data.dart';
import 'package:instabug_flutter/src/models/w3c_header.dart';
import 'package:instabug_flutter/src/modules/apm.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/instabug_constants.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/iterable_ext.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';
import 'package:instabug_flutter/src/utils/w3c_header_utils.dart';
import 'package:meta/meta.dart';

class NetworkLogger {
  static var _host = InstabugHostApi();
  static var _manager = NetworkManager();

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(InstabugHostApi host) {
    _host = host;
    // ignore: invalid_use_of_visible_for_testing_member
    FeatureFlagsManager().$setHostApi(host);
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
    final w3Header = await getW3CHeader(
      data.requestHeaders,
      data.startTime.millisecondsSinceEpoch,
    );
    if (w3Header?.isW3cHeaderFound == false &&
        w3Header?.w3CGeneratedHeader != null) {
      data.requestHeaders['traceparent'] = w3Header?.w3CGeneratedHeader;
    }
    networkLogInternal(data);
  }

  @internal
  Future<void> networkLogInternal(NetworkData data) async {
    final omit = await _manager.omitLog(data);
    if (omit) return;

    // Check size limits early to avoid processing large bodies
    final requestExceeds = await _manager.didRequestBodyExceedSizeLimit(data);
    final responseExceeds = await _manager.didResponseBodyExceedSizeLimit(data);

    var processedData = data;
    if (requestExceeds || responseExceeds) {
      // Replace bodies with warning messages
      processedData = data.copyWith(
        requestBody: requestExceeds
            ? InstabugConstants.getRequestBodyReplacementMessage(
                data.requestBodySize,
              )
            : data.requestBody,
        responseBody: responseExceeds
            ? InstabugConstants.getResponseBodyReplacementMessage(
                data.responseBodySize,
              )
            : data.responseBody,
      );

      // Log the truncation event.
      final isBothExceeds = requestExceeds && responseExceeds;
      InstabugLogger.I.e(
        "Truncated network ${isBothExceeds ? 'request and response' : requestExceeds ? 'request' : 'response'} body",
        tag: InstabugConstants.networkLoggerTag,
      );
    }

    final obfuscated = await _manager.obfuscateLog(processedData);
    await _host.networkLog(obfuscated.toJson());
    await APM.networkLogAndroid(obfuscated);
  }

  @internal
  Future<W3CHeader?> getW3CHeader(
    Map<String, dynamic> header,
    int startTime,
  ) async {
    final w3cFlags = await FeatureFlagsManager().getW3CFeatureFlagsHeader();

    if (w3cFlags.isW3cExternalTraceIDEnabled == false) {
      return null;
    }

    final w3cHeaderFound = header.entries
        .firstWhereOrNull(
          (element) => element.key.toLowerCase() == 'traceparent',
        )
        ?.value as String?;
    final isW3cHeaderFound = w3cHeaderFound != null;

    if (isW3cHeaderFound && w3cFlags.isW3cCaughtHeaderEnabled) {
      return W3CHeader(isW3cHeaderFound: true, w3CCaughtHeader: w3cHeaderFound);
    } else if (w3cFlags.isW3cExternalGeneratedHeaderEnabled &&
        !isW3cHeaderFound) {
      final w3cHeaderData = W3CHeaderUtils().generateW3CHeader(
        startTime,
      );

      return W3CHeader(
        isW3cHeaderFound: false,
        partialId: w3cHeaderData.partialId,
        networkStartTimeInSeconds: w3cHeaderData.timestampInSeconds,
        w3CGeneratedHeader: w3cHeaderData.w3cHeader,
      );
    }
    return null;
  }

  /// Enables or disables network body logs capturing.
  /// [boolean] isEnabled
  static Future<void> setNetworkLogBodyEnabled(bool isEnabled) async {
    return _host.setNetworkLogBodyEnabled(isEnabled);
  }
}
