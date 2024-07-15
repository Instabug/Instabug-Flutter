import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';

class W3HeaderUtils {
  static Random _random = Random();
  static final _featureFlagManager = FeatureFlagsManager();


  W3HeaderUtils();

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setRandom(Random random) {
    _random = random;
  }

  /// Generate random 32 bit unsigned integer Hexadecimal (8 chars) lower case letters
  /// Should not return all zeros
  static Map<String, dynamic> generateTracePartialId() {
    int randomNumber;
    String hexString;

    do {
      randomNumber = _random.nextInt(0xffffffff);
      hexString = randomNumber.toRadixString(16).padLeft(8, '0');
    } while (hexString == '00000000');

    return {
      'numberPartialId': randomNumber,
      'hexStringPartialId': hexString.toLowerCase(),
    };
  }

  /// Generate W3C header in the format of {version}-{trace-id}-{parent-id}-{trace-flag}
  /// @param networkStartTime
  /// @returns w3c header
  static Map<String, dynamic> generateW3CHeader(int networkStartTime) {
    final partialIdData = generateTracePartialId();
    final String hexStringPartialId = partialIdData['hexStringPartialId'];
    final int numberPartialId = partialIdData['numberPartialId'];

    final timestampInSeconds = (networkStartTime / 1000).floor();
    final hexaDigitsTimestamp =
        timestampInSeconds.toRadixString(16).toLowerCase();
    final traceId =
        '$hexaDigitsTimestamp$hexStringPartialId$hexaDigitsTimestamp$hexStringPartialId';
    final parentId = '4942472d$hexStringPartialId';

    return {
      'timestampInSeconds': timestampInSeconds,
      'partialId': numberPartialId,
      'w3cHeader': '00-$traceId-$parentId-01',
    };
  }

  static Future<NetworkData> addW3Header(NetworkData data) async {
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
        w3CCaughtHeader: data.requestHeaders.toString(),
      );
    } else if (isW3ExternalGeneratedHeaderEnabled) {
      final w3HeaderData = generateW3CHeader(networkData.startTime.millisecondsSinceEpoch);

      final int timestampInSeconds = w3HeaderData['timestampInSeconds'];
      final int partialId = w3HeaderData['partialId'];
      final w3cHeader = w3HeaderData['w3cHeader'].toString();
      return networkData.copyWith(
        partialId: partialId,
        networkStartTimeInSeconds: timestampInSeconds,
        w3CGeneratedHeader: w3cHeader,
      );
    }
    return networkData;
  }
}
