import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/models/generated_w3c_header.dart';
import 'package:instabug_flutter/src/models/trace_partial_id.dart';

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
  static TracePartialId generateTracePartialId() {
    int randomNumber;
    String hexString;

    do {
      randomNumber = _random.nextInt(0xffffffff);
      hexString = randomNumber.toRadixString(16).padLeft(8, '0');
    } while (hexString == '00000000');

    return TracePartialId(
      numberPartialId: randomNumber,
      hexPartialId: hexString.toLowerCase(),
    );
  }

  /// Generate W3C header in the format of {version}-{trace-id}-{parent-id}-{trace-flag}
  /// @param networkStartTime
  /// @returns w3c header
  static GeneratedW3CHeader generateW3CHeader(int networkStartTime) {
    final partialIdData = generateTracePartialId();
    final hexStringPartialId = partialIdData.hexPartialId;
    final numberPartialId = partialIdData.numberPartialId;

    final timestampInSeconds = (networkStartTime / 1000).floor();
    final hexaDigitsTimestamp =
        timestampInSeconds.toRadixString(16).toLowerCase();
    final traceId =
        '$hexaDigitsTimestamp$hexStringPartialId$hexaDigitsTimestamp$hexStringPartialId';
    final parentId = '4942472d$hexStringPartialId';

    return GeneratedW3CHeader(
      timestampInSeconds: timestampInSeconds,
      partialId: numberPartialId,
      w3cHeader: '00-$traceId-$parentId-01',
    );
  }
}
