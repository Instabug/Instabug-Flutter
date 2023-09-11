import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_logger_test.mocks.dart';

@GenerateMocks([
  ApmHostApi,
  InstabugHostApi,
  IBGBuildInfo,
  NetworkManager,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mApmHost = MockApmHostApi();
  final mInstabugHost = MockInstabugHostApi();
  final mBuildInfo = MockIBGBuildInfo();
  final mManager = MockNetworkManager();

  final logger = NetworkLogger();
  final data = NetworkData(
    url: "https://httpbin.org/get",
    method: "GET",
    startTime: DateTime.now(),
  );

  setUpAll(() {
    APM.$setHostApi(mApmHost);
    NetworkLogger.$setHostApi(mInstabugHost);
    NetworkLogger.$setManager(mManager);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  setUp(() {
    reset(mApmHost);
    reset(mInstabugHost);
    reset(mBuildInfo);
    reset(mManager);
  });

  test('[networkLog] should call 1 host method on iOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mManager.obfuscateLog(data)).thenReturn(data);

    await logger.networkLog(data);

    verify(
      mInstabugHost.networkLog(data.toJson()),
    ).called(1);

    verifyNever(
      mApmHost.networkLogAndroid(data.toJson()),
    );
  });

  test('[networkLog] should call 2 host methods on Android', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mManager.obfuscateLog(data)).thenReturn(data);

    await logger.networkLog(data);

    verify(
      mInstabugHost.networkLog(data.toJson()),
    ).called(1);

    verify(
      mApmHost.networkLogAndroid(data.toJson()),
    ).called(1);
  });

  test('[networkLog] should obfuscate network data before logging', () async {
    final obfuscated = data.copyWith(requestBody: 'obfuscated');

    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mManager.obfuscateLog(data)).thenReturn(obfuscated);

    await logger.networkLog(data);

    verify(
      mManager.obfuscateLog(data),
    ).called(1);

    verify(
      mInstabugHost.networkLog(obfuscated.toJson()),
    ).called(1);

    verify(
      mApmHost.networkLogAndroid(obfuscated.toJson()),
    ).called(1);
  });

  test('[obfuscateLog] should set obfuscation callback on manager', () async {
    FutureOr<NetworkData> callback(NetworkData data) => data;

    NetworkLogger.obfuscateLog(callback);

    verify(
      mManager.setObfuscateLogCallback(callback),
    ).called(1);
  });
}
