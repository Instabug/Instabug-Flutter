import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';

class W3HeaderUtils {
  static Random _random = Random();

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
}
