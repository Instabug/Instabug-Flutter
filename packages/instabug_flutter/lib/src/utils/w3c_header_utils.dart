import 'dart:math';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/models/generated_w3c_header.dart';
import 'package:instabug_flutter/src/models/trace_partial_id.dart';

class W3CHeaderUtils {
  // Access the singleton instance
  factory W3CHeaderUtils() {
    return _instance;
  }
  // Private constructor to prevent instantiation
  W3CHeaderUtils._();

  // Singleton instance
  static final W3CHeaderUtils _instance = W3CHeaderUtils._();

  // Random instance
  static Random _random = Random();

  @visibleForTesting
  // Setter for the Random instance
  // ignore: use_setters_to_change_properties
  void $setRandom(Random random) {
    _random = random;
  }

  /// Generate random 32-bit unsigned integer Hexadecimal (8 chars) lower case letters
  /// Should not return all zeros
  TracePartialId generateTracePartialId() {
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
  /// @returns W3C header
  GeneratedW3CHeader generateW3CHeader(int networkStartTime) {
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
