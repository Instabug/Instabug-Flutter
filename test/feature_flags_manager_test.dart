import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'feature_flags_manager_test.mocks.dart';

@GenerateNiceMocks([MockSpec<InstabugHostApi>(), MockSpec<IBGBuildInfo>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mInstabugHost = MockInstabugHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  setUpAll(() {
    FeatureFlagsManager.$setHostApi(mInstabugHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  tearDown(() {
    reset(mInstabugHost);
  });

  test('[isW3ExternalTraceID] should call host method on IOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3FeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3ExternalTraceIDEnabled": true,
        "isW3ExternalGeneratedHeaderEnabled": true,
        "isW3CaughtHeaderEnabled": true,
      }),
    );
    final m = await FeatureFlagsManager.isW3ExternalTraceID;
    expect(m, true);
    verify(
      mInstabugHost.isW3FeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CaughtHeader] should call host method on IOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3FeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3ExternalTraceIDEnabled": true,
        "isW3ExternalGeneratedHeaderEnabled": true,
        "isW3CaughtHeaderEnabled": false,
      }),
    );
    final m = await FeatureFlagsManager.isW3CaughtHeader;
    expect(m, false);
    verify(
      mInstabugHost.isW3FeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3ExternalGeneratedHeader] should call host method on IOS',
      () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3FeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3ExternalTraceIDEnabled": true,
        "isW3ExternalGeneratedHeaderEnabled": true,
        "isW3CaughtHeaderEnabled": true,
      }),
    );
    final m = await FeatureFlagsManager.isW3ExternalGeneratedHeader;
    expect(m, true);
    verify(
      mInstabugHost.isW3FeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3ExternalTraceID] should call host method on Android', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mInstabugHost.isW3FeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3ExternalTraceIDEnabled": true,
        "isW3ExternalGeneratedHeaderEnabled": true,
        "isW3CaughtHeaderEnabled": true,
      }),
    );
    await FeatureFlagsManager.registerW3CFlagsListener();

    final m = await FeatureFlagsManager.isW3ExternalTraceID;
    expect(m, true);
    verify(
      mInstabugHost.isW3FeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CaughtHeader] should call host method on Android', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mInstabugHost.isW3FeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3ExternalTraceIDEnabled": true,
        "isW3ExternalGeneratedHeaderEnabled": true,
        "isW3CaughtHeaderEnabled": false,
      }),
    );
    await FeatureFlagsManager.registerW3CFlagsListener();

    final m = await FeatureFlagsManager.isW3CaughtHeader;
    expect(m, false);
    verify(
      mInstabugHost.isW3FeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3ExternalGeneratedHeader] should call host method on Android',
      () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mInstabugHost.isW3FeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3ExternalTraceIDEnabled": true,
        "isW3ExternalGeneratedHeaderEnabled": true,
        "isW3CaughtHeaderEnabled": true,
      }),
    );
    await FeatureFlagsManager.registerW3CFlagsListener();

    final m = await FeatureFlagsManager.isW3ExternalGeneratedHeader;
    expect(m, true);
    verify(
      mInstabugHost.isW3FeatureFlagsEnabled(),
    ).called(1);
  });

  test('[registerW3CFlagsListener] should call host method', () async {
    FeatureFlagsManager.registerW3CFlagsListener();

    // ServicesBinding.instance.defaultBinaryMessenger.send(
    //   'dev.flutter.pigeon.instabug_flutter.InstabugHostApi.bindOnW3CFeatureFlagChangeCallback',
    //   const StandardMethodCodec().encodeSuccessEnvelope('{"result":true}'),
    // );

    verify(
      mInstabugHost.bindOnW3CFeatureFlagChangeCallback(),
    ).called(1);
  });
}
