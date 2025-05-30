import 'dart:async';
import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/network_manager.dart';
import 'package:instabug_flutter/src/utils/w3c_header_utils.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_logger_test.mocks.dart';

@GenerateMocks([
  ApmHostApi,
  InstabugHostApi,
  IBGBuildInfo,
  NetworkManager,
  W3CHeaderUtils,
  FeatureFlagsManager,
  Random,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mApmHost = MockApmHostApi();
  final mInstabugHost = MockInstabugHostApi();
  final mBuildInfo = MockIBGBuildInfo();
  final mManager = MockNetworkManager();
  final mRandom = MockRandom();
  final logger = NetworkLogger();
  final data = NetworkData(
    url: "https://httpbin.org/get",
    method: "GET",
    startTime: DateTime.now(),
  );

  setUpAll(() {
    APM.$setHostApi(mApmHost);
    FeatureFlagsManager().$setHostApi(mInstabugHost);
    NetworkLogger.$setHostApi(mInstabugHost);
    NetworkLogger.$setManager(mManager);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  setUp(() {
    reset(mApmHost);
    reset(mInstabugHost);
    reset(mBuildInfo);
    reset(mManager);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
  });

  test('[networkLog] should call 1 host method on iOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mManager.obfuscateLog(data)).thenReturn(data);
    when(mManager.omitLog(data)).thenReturn(false);

    await logger.networkLogInternal(data);

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
    when(mManager.omitLog(data)).thenReturn(false);

    await logger.networkLogInternal(data);

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
    when(mManager.omitLog(data)).thenReturn(false);

    await logger.networkLogInternal(data);

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

  test('[networkLog] should not log data if it should be omitted', () async {
    const omit = true;

    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mManager.obfuscateLog(data)).thenReturn(data);
    when(mManager.omitLog(data)).thenReturn(omit);

    await logger.networkLogInternal(data);

    verify(
      mManager.omitLog(data),
    ).called(1);

    verifyNever(
      mInstabugHost.networkLog(data.toJson()),
    );

    verifyNever(
      mApmHost.networkLogAndroid(data.toJson()),
    );
  });

  test('[obfuscateLog] should set obfuscation callback on manager', () async {
    FutureOr<NetworkData> callback(NetworkData data) => data;

    NetworkLogger.obfuscateLog(callback);

    verify(
      mManager.setObfuscateLogCallback(callback),
    ).called(1);
  });

  test('[omitLog] should set omission callback on manager', () async {
    FutureOr<bool> callback(NetworkData data) => true;

    NetworkLogger.omitLog(callback);

    verify(
      mManager.setOmitLogCallback(callback),
    ).called(1);
  });

  test(
      '[getW3CHeader] should return  null when isW3cExternalTraceIDEnabled disabled',
      () async {
    when(mBuildInfo.isAndroid).thenReturn(true);

    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": false,
        "isW3cExternalGeneratedHeaderEnabled": false,
        "isW3cCaughtHeaderEnabled": false,
      }),
    );
    final time = DateTime.now().millisecondsSinceEpoch;
    final w3cHeader = await logger.getW3CHeader({}, time);
    expect(w3cHeader, null);
  });

  test(
      '[getW3CHeader] should return transparent header when isW3cCaughtHeaderEnabled enabled',
      () async {
    when(mBuildInfo.isAndroid).thenReturn(false);

    final time = DateTime.now().millisecondsSinceEpoch;
    final w3cHeader =
        await logger.getW3CHeader({"traceparent": "Header test"}, time);
    expect(w3cHeader!.isW3cHeaderFound, true);
    expect(w3cHeader.w3CCaughtHeader, "Header test");
  });

  test(
      '[getW3CHeader] should return generated header when isW3cExternalGeneratedHeaderEnabled  and no traceparent header',
      () async {
    W3CHeaderUtils().$setRandom(mRandom);
    when(mBuildInfo.isAndroid).thenReturn(false);

    when(mRandom.nextInt(any)).thenReturn(217222);

    final time = DateTime.now().millisecondsSinceEpoch;
    final w3cHeader = await logger.getW3CHeader({}, time);
    final generatedW3CHeader = W3CHeaderUtils().generateW3CHeader(time);

    expect(w3cHeader!.isW3cHeaderFound, false);
    expect(w3cHeader.w3CGeneratedHeader, generatedW3CHeader.w3cHeader);
    expect(w3cHeader.partialId, generatedW3CHeader.partialId);
    expect(
      w3cHeader.networkStartTimeInSeconds,
      generatedW3CHeader.timestampInSeconds,
    );
  });

  test(
      '[networkLog] should add transparent header when isW3cCaughtHeaderEnabled disabled to every request',
      () async {
    final networkData = data.copyWith(requestHeaders: <String, dynamic>{});
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mManager.obfuscateLog(networkData)).thenReturn(networkData);
    when(mManager.omitLog(networkData)).thenReturn(false);
    await logger.networkLog(networkData);
    expect(networkData.requestHeaders.containsKey('traceparent'), isTrue);
  });

  test(
      '[networkLog] should not add transparent header when there is traceparent',
      () async {
    final networkData = data.copyWith(requestHeaders: {'traceparent': 'test'});
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mManager.obfuscateLog(networkData)).thenReturn(networkData);
    when(mManager.omitLog(networkData)).thenReturn(false);
    await logger.networkLog(networkData);
    expect(networkData.requestHeaders['traceparent'], 'test');
  });

  test('[setNetworkLogBodyEnabled] should call host method', () async {
    const enabled = true;

    await NetworkLogger.setNetworkLogBodyEnabled(enabled);

    verify(
      mInstabugHost.setNetworkLogBodyEnabled(enabled),
    ).called(1);
  });
}
