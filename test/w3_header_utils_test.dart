import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/w3_header_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'w3_header_utils_test.mocks.dart';

@GenerateMocks([Random])
void main() {
  final mRandom = MockRandom();

  setUpAll(() {
    W3HeaderUtils.$setRandom(mRandom);
  });
  setUp(() {
    when(mRandom.nextInt(any)).thenReturn(217222);
  });

  tearDown(() {
    reset(mRandom);
  });

  test('generateTracePartialId should generate a non-zero hex string', () {
    final hexString =
        W3HeaderUtils.generateTracePartialId()['hexStringPartialId'].toString();
    expect(hexString, isNot('00000000'));
  });

  test('generateTracePartialId should return 8 chars long generated hex string',
      () {
    final hexString =
        W3HeaderUtils.generateTracePartialId()['hexStringPartialId'].toString();
    expect(hexString.length, 8);
  });

  test(
      'generateW3CHeader should return {version}-{trace-id}-{parent-id}-{trace-flag} format header',
      () {
    const date = 1716210104248;
    final hexString0 = 217222.toRadixString(16).padLeft(8, '0');

    final expectedHeader = <String, dynamic>{
      'timestampInSeconds': (1716210104248 / 1000).floor(),
      'partialId': 217222,
      'w3cHeader':
          '00-664b49b8${hexString0}664b49b8$hexString0-4942472d$hexString0-01',
    };
    final generatedHeader = W3HeaderUtils.generateW3CHeader(date);
    expect(generatedHeader, expectedHeader);
  });

  test('generateW3CHeader should correctly floor the timestamp', () {
    const date = 1716222912145;
    final expectedHeader = <String, dynamic>{
      'timestampInSeconds': (1716222912145 / 1000).floor(),
      'partialId': 217222,
      'w3cHeader': "00-664b7bc000035086664b7bc000035086-4942472d00035086-01",
    };
    final generatedHeader = W3HeaderUtils.generateW3CHeader(date);
    expect(generatedHeader, expectedHeader);
  });
}
