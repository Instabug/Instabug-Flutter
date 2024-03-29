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
}
