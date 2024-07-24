import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'feature_flags_manager_test.mocks.dart';

@GenerateMocks([InstabugHostApi, IBGBuildInfo])
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

  test('[isW3CExternalTraceID] should call host method on IOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
    final isW3CExternalTraceID = await FeatureFlagsManager.isW3CExternalTraceID;
    expect(isW3CExternalTraceID, true);
    verify(
      mInstabugHost.isW3CFeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CCaughtHeader] should call host method on IOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": false,
      }),
    );
    final isW3CaughtHeader = await FeatureFlagsManager.isW3CCaughtHeader;
    expect(isW3CaughtHeader, false);
    verify(
      mInstabugHost.isW3CFeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CExternalGeneratedHeader] should call host method on IOS',
      () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
    final m = await FeatureFlagsManager.isW3CExternalGeneratedHeader;
    expect(m, true);
    verify(
      mInstabugHost.isW3CFeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CExternalTraceID] should call host method on Android', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
    await FeatureFlagsManager.registerW3CFlagsListener();

    final isW3CExternalTraceID = await FeatureFlagsManager.isW3CExternalTraceID;
    expect(isW3CExternalTraceID, true);
    verify(
      mInstabugHost.isW3CFeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CCaughtHeader] should call host method on Android', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": false,
      }),
    );

    await FeatureFlagsManager.registerW3CFlagsListener();

    final isW3CaughtHeader = await FeatureFlagsManager.isW3CCaughtHeader;
    expect(isW3CaughtHeader, false);
    verify(
      mInstabugHost.isW3CFeatureFlagsEnabled(),
    ).called(1);
  });

  test('[isW3CExternalGeneratedHeader] should call host method on Android',
      () async {
    when(mBuildInfo.isAndroid).thenReturn(true);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
    await FeatureFlagsManager.registerW3CFlagsListener();

    final isW3CExternalGeneratedHeader =
        await FeatureFlagsManager.isW3CExternalGeneratedHeader;
    expect(isW3CExternalGeneratedHeader, true);
    verify(
      mInstabugHost.isW3CFeatureFlagsEnabled(),
    ).called(1);
  });

  test('[registerW3CFlagsListener] should call host method', () async {
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );

    await FeatureFlagsManager.registerW3CFlagsListener();

    verify(
      mInstabugHost.bindOnW3CFeatureFlagChangeCallback(),
    ).called(1);
  });
}
