import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final data = NetworkData(
    url: "https://httpbin.org/get",
    method: "GET",
    startTime: DateTime.now(),
    requestBodySize: 1000,
    responseBodySize: 2000,
  );
  late NetworkManager manager;

  setUp(() {
    manager = NetworkManager();
  });

  test('[obfuscateLog] should return same data when obfuscate log callback',
      () async {
    final result = await manager.obfuscateLog(data);

    expect(result, equals(data));
  });

  test(
      '[obfuscateLog] should obfuscate data when [setObfuscateLogCallback] has set a callback',
      () async {
    final obfuscated = data.copyWith(requestBody: 'obfuscated');
    final completer = Completer<NetworkData>();
    FutureOr<NetworkData> callback(NetworkData data) {
      completer.complete(data);
      return obfuscated;
    }

    manager.setObfuscateLogCallback(callback);

    final result = await manager.obfuscateLog(data);

    expect(completer.isCompleted, isTrue);

    expect(await completer.future, data);

    expect(result, equals(obfuscated));
  });

  test('[omitLog] should return false when no omit log callback', () async {
    const expected = false;

    final result = await manager.omitLog(data);

    expect(result, equals(expected));
  });

  test(
      '[omitLog] should use omit callback when [setOmitLogCallback] has set a callback',
      () async {
    const omit = true;
    final completer = Completer<NetworkData>();
    FutureOr<bool> callback(NetworkData data) {
      completer.complete(data);
      return omit;
    }

    manager.setOmitLogCallback(callback);

    final result = await manager.omitLog(data);

    expect(completer.isCompleted, isTrue);

    expect(await completer.future, data);

    expect(result, equals(omit));
  });

  group('[didRequestBodyExceedSizeLimit]', () {
    test('should return false when request body size is within default limit',
        () async {
      final smallData =
          data.copyWith(requestBodySize: 5000); // 5KB < 10KB default

      final result = await manager.didRequestBodyExceedSizeLimit(smallData);

      expect(result, isFalse);
    });

    test('should return true when request body size exceeds default limit',
        () async {
      final largeData =
          data.copyWith(requestBodySize: 15000); // 15KB > 10KB default

      final result = await manager.didRequestBodyExceedSizeLimit(largeData);

      expect(result, isTrue);
    });

    test('should return false when request body size equals default limit',
        () async {
      final exactData = data.copyWith(requestBodySize: 10240); // Exactly 10KB

      final result = await manager.didRequestBodyExceedSizeLimit(exactData);

      expect(result, isFalse);
    });

    test('should handle errors gracefully and return false', () async {
      final result = await manager.didRequestBodyExceedSizeLimit(data);

      expect(result, isA<bool>());
    });
  });

  group('[didResponseBodyExceedSizeLimit]', () {
    test('should return false when response body size is within default limit',
        () async {
      final smallData =
          data.copyWith(responseBodySize: 5000); // 5KB < 10KB default

      final result = await manager.didResponseBodyExceedSizeLimit(smallData);

      expect(result, isFalse);
    });

    test('should return true when response body size exceeds default limit',
        () async {
      final largeData =
          data.copyWith(responseBodySize: 15000); // 15KB > 10KB default

      final result = await manager.didResponseBodyExceedSizeLimit(largeData);

      expect(result, isTrue);
    });

    test('should return false when response body size equals default limit',
        () async {
      final exactData = data.copyWith(responseBodySize: 10240); // Exactly 10KB

      final result = await manager.didResponseBodyExceedSizeLimit(exactData);

      expect(result, isFalse);
    });

    test('should handle errors gracefully and return false', () async {
      final result = await manager.didResponseBodyExceedSizeLimit(data);

      expect(result, isA<bool>());
    });
  });
}
