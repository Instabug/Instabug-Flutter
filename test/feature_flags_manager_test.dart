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
    FeatureFlagsManager().$setHostApi(mInstabugHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  tearDown(() {
    reset(mInstabugHost);
  });

  test('[getW3CFeatureFlagsHeader] should call host method on IOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);
    when(mInstabugHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
    final isW3CExternalTraceID =
        await FeatureFlagsManager().getW3CFeatureFlagsHeader();
    expect(isW3CExternalTraceID.isW3cExternalTraceIDEnabled, true);
    expect(isW3CExternalTraceID.isW3cExternalGeneratedHeaderEnabled, true);
    expect(isW3CExternalTraceID.isW3cCaughtHeaderEnabled, true);

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
    when(mInstabugHost.getNetworkBodyMaxSize()).thenAnswer(
      (_) => Future.value(10240),
    );
    await FeatureFlagsManager().registerFeatureFlagsListener();

    final isW3CExternalTraceID =
        await FeatureFlagsManager().getW3CFeatureFlagsHeader();
    expect(isW3CExternalTraceID.isW3cExternalTraceIDEnabled, true);
    expect(isW3CExternalTraceID.isW3cExternalGeneratedHeaderEnabled, true);
    expect(isW3CExternalTraceID.isW3cCaughtHeaderEnabled, true);
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
    when(mInstabugHost.getNetworkBodyMaxSize()).thenAnswer(
      (_) => Future.value(10240),
    );

    await FeatureFlagsManager().registerFeatureFlagsListener();

    verify(
      mInstabugHost.registerFeatureFlagChangeListener(),
    ).called(1);
  });
}
