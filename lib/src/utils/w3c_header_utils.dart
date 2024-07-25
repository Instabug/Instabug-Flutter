import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/models/generated_w3_header.dart';

class W3CHeaderUtils {
  static Random _random = Random();

  W3CHeaderUtils();

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
  static GeneratedW3Header generateW3CHeader(int networkStartTime) {
    final partialIdData = generateTracePartialId();
    final hexStringPartialId = partialIdData['hexStringPartialId'] as String;
    final numberPartialId = partialIdData['numberPartialId'] as int;

    final timestampInSeconds = (networkStartTime / 1000).floor();
    final hexaDigitsTimestamp =
        timestampInSeconds.toRadixString(16).toLowerCase();
    final traceId =
        '$hexaDigitsTimestamp$hexStringPartialId$hexaDigitsTimestamp$hexStringPartialId';
    final parentId = '4942472d$hexStringPartialId';

    return GeneratedW3Header(
      timestampInSeconds: timestampInSeconds,
      partialId: numberPartialId,
      w3cHeader: '00-$traceId-$parentId-01',
    );
  }
}
