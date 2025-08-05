import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apm_test.mocks.dart';

@GenerateMocks([
  ApmHostApi,
  IBGDateTime,
  IBGBuildInfo,
  InstabugScreenRenderManager,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockApmHostApi();
  final mDateTime = MockIBGDateTime();
  final mBuildInfo = MockIBGBuildInfo();
  final mScreenRenderManager = MockInstabugScreenRenderManager();

  setUpAll(() {
    APM.$setHostApi(mHost);
    IBGDateTime.setInstance(mDateTime);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await APM.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[isEnabled] should call host method', () async {
    when(mHost.isEnabled()).thenAnswer((_) async => true);
    await APM.isEnabled();

    verify(
      mHost.isEnabled(),
    ).called(1);
  });

  test('[setScreenLoadingMonitoringEnabled] should call host method', () async {
    const enabled = true;

    await APM.setScreenLoadingEnabled(enabled);

    verify(
      mHost.setScreenLoadingEnabled(enabled),
    ).called(1);
  });

  test('[isScreenLoadingMonitoringEnabled] should call host method', () async {
    when(mHost.isScreenLoadingEnabled()).thenAnswer((_) async => true);
    await APM.isScreenLoadingEnabled();

    verify(
      mHost.isScreenLoadingEnabled(),
    ).called(1);
  });

  test('[setColdAppLaunchEnabled] should call host method', () async {
    const enabled = true;

    await APM.setColdAppLaunchEnabled(enabled);

    verify(
      mHost.setColdAppLaunchEnabled(enabled),
    ).called(1);
  });

  test('[setAutoUITraceEnabled] should call host method', () async {
    const enabled = true;

    await APM.setAutoUITraceEnabled(enabled);

    verify(
      mHost.setAutoUITraceEnabled(enabled),
    ).called(1);
  });

  test('[startExecutionTrace] should call host method', () async {
    final id = DateTime.now();
    const name = "trace";

    when(mDateTime.now()).thenAnswer((_) => id);
    when(mHost.startExecutionTrace(id.toString(), name))
        .thenAnswer((_) async => id.toString());

    // ignore: deprecated_member_use_from_same_package
    final trace = await APM.startExecutionTrace(name);

    expect(trace.id, id.toString());

    verify(
      mHost.startExecutionTrace(id.toString(), name),
    ).called(1);
  });

  test('[setExecutionTraceAttribute] should call host method', () async {
    final id = DateTime.now().toString();
    const key = "attr-key";
    const attribute = "Trace Attribute";

    // ignore: deprecated_member_use_from_same_package
    await APM.setExecutionTraceAttribute(id, key, attribute);

    verify(
      mHost.setExecutionTraceAttribute(id, key, attribute),
    ).called(1);
  });

  test('[endExecutionTrace] should call host method', () async {
    final id = DateTime.now().toString();

    // ignore: deprecated_member_use_from_same_package
    await APM.endExecutionTrace(id);

    verify(
      mHost.endExecutionTrace(id),
    ).called(1);
  });

  test('[startFlow] should call host method', () async {
    const flowName = "flow-name";
    await APM.startFlow(flowName);

    verify(
      mHost.startFlow(flowName),
    ).called(1);
    verifyNoMoreInteractions(mHost);
  });

  test('[setFlowAttribute] should call host method', () async {
    const flowName = "flow-name";
    const flowAttributeKey = 'attribute-key';
    const flowAttributeValue = 'attribute-value';

    await APM.setFlowAttribute(flowName, flowAttributeKey, flowAttributeValue);

    verify(
      mHost.setFlowAttribute(flowName, flowAttributeKey, flowAttributeValue),
    ).called(1);
    verifyNoMoreInteractions(mHost);
  });

  test('[endFlow] should call host method', () async {
    const flowName = "flow-name";

    await APM.endFlow(flowName);

    verify(
      mHost.endFlow(flowName),
    ).called(1);
    verifyNoMoreInteractions(mHost);
  });

  test('[startUITrace] should call host method', () async {
    const name = 'UI-trace';

    //disable the feature flag for screen render feature in order to skip its checking.
    when(mHost.isScreenRenderEnabled()).thenAnswer((_) async => false);

    await APM.startUITrace(name);

    verify(
      mHost.startUITrace(name),
    ).called(1);
  });

  test('[endUITrace] should call host method', () async {
    await APM.endUITrace();

    verify(
      mHost.endUITrace(),
    ).called(1);
  });

  test('[endAppLaunch] should call host method', () async {
    await APM.endAppLaunch();

    verify(
      mHost.endAppLaunch(),
    ).called(1);
  });

  test('[networkLogAndroid] should call host method', () async {
    final data = NetworkData(
      url: "https://httpbin.org/get",
      method: "GET",
      startTime: DateTime.now(),
    );

    when(mBuildInfo.isAndroid).thenReturn(true);

    await APM.networkLogAndroid(data);

    verify(
      mHost.networkLogAndroid(data.toJson()),
    ).called(1);
  });

  test('[startCpUiTrace] should call host method', () async {
    const screenName = 'screen-name';
    final microTimeStamp = DateTime.now().microsecondsSinceEpoch;
    final traceId = DateTime.now().millisecondsSinceEpoch;

    await APM.startCpUiTrace(screenName, microTimeStamp, traceId);

    verify(
      mHost.startCpUiTrace(screenName, microTimeStamp, traceId),
    ).called(1);
  });

  test('[reportScreenLoading] should call host method', () async {
    final startTimeStampMicro = DateTime.now().microsecondsSinceEpoch;
    final durationMicro = DateTime.now().microsecondsSinceEpoch;
    final uiTraceId = DateTime.now().millisecondsSinceEpoch;

    await APM.reportScreenLoadingCP(
      startTimeStampMicro,
      durationMicro,
      uiTraceId,
    );

    verify(
      mHost.reportScreenLoadingCP(
        startTimeStampMicro,
        durationMicro,
        uiTraceId,
      ),
    ).called(1);
  });

  test('[endScreenLoading] should call host method', () async {
    final timeStampMicro = DateTime.now().microsecondsSinceEpoch;
    final uiTraceId = DateTime.now().millisecondsSinceEpoch;

    await APM.endScreenLoadingCP(timeStampMicro, uiTraceId);

    verify(
      mHost.endScreenLoadingCP(timeStampMicro, uiTraceId),
    ).called(1);
  });

  test('[isSEndScreenLoadingEnabled] should call host method', () async {
    when(mHost.isEndScreenLoadingEnabled()).thenAnswer((_) async => true);
    await APM.isEndScreenLoadingEnabled();

    verify(
      mHost.isEndScreenLoadingEnabled(),
    ).called(1);
  });

  group("ScreenRender", () {
    setUp(() {
      InstabugScreenRenderManager.setInstance(mScreenRenderManager);
    });
    tearDown(() {
      reset(mScreenRenderManager);
    });
    test("[isScreenRenderEnabled] should call host method", () async {
      when(mHost.isScreenRenderEnabled()).thenAnswer((_) async => true);
      await APM.isScreenRenderEnabled();
      verify(mHost.isScreenRenderEnabled());
    });

    test("[getDeviceRefreshRate] should call host method", () async {
      when(mHost.deviceRefreshRate()).thenAnswer((_) async => 60.0);
      await APM.getDeviceRefreshRate();
      verify(mHost.deviceRefreshRate()).called(1);
    });

    test("[setScreenRenderEnabled] should call host method", () async {
      const isEnabled = false;
      await APM.setScreenRenderEnabled(isEnabled);
      verify(mHost.setScreenRenderEnabled(isEnabled)).called(1);
    });

    test(
        "[setScreenRenderEnabled] should call [init()] screen render collector, is the feature is enabled",
        () async {
      const isEnabled = true;
      await APM.setScreenRenderEnabled(isEnabled);
      verify(mScreenRenderManager.init(any)).called(1);
      verifyNoMoreInteractions(mScreenRenderManager);
    });

    test(
        "[setScreenRenderEnabled] should call [remove()] screen render collector, is the feature is enabled",
        () async {
      const isEnabled = false;
      await APM.setScreenRenderEnabled(isEnabled);
      verify(mScreenRenderManager.dispose()).called(1);
      verifyNoMoreInteractions(mScreenRenderManager);
    });

    test(
        "[startUITrace] should start screen render collector with right params, if screen render feature is enabled",
        () async {
      when(mHost.isScreenRenderEnabled()).thenAnswer((_) async => true);

      const traceName = "traceNameTest";
      await APM.startUITrace(traceName);

      verify(mHost.startUITrace(traceName)).called(1);
      verify(mHost.isScreenRenderEnabled()).called(1);
      verify(
        mScreenRenderManager.startScreenRenderCollectorForTraceId(
          0,
          UiTraceType.custom,
        ),
      ).called(1);
    });

    test(
        "[startUITrace] should not start screen render collector, if screen render feature is disabled",
        () async {
      when(mHost.isScreenRenderEnabled()).thenAnswer((_) async => false);

      const traceName = "traceNameTest";
      await APM.startUITrace(traceName);

      verify(mHost.startUITrace(traceName)).called(1);
      verify(mHost.isScreenRenderEnabled()).called(1);
      verifyNever(
        mScreenRenderManager.startScreenRenderCollectorForTraceId(
          any,
          any,
        ),
      );
    });

    test(
        "[endUITrace] should stop screen render collector with, if screen render feature is enabled",
        () async {
      when(mHost.isScreenRenderEnabled()).thenAnswer((_) async => true);
      when(mScreenRenderManager.screenRenderEnabled).thenReturn(true);
      await APM.endUITrace();

      verify(
        mScreenRenderManager.endScreenRenderCollector(),
      ).called(1);
      verifyNever(mHost.endUITrace());
    });

    test(
        "[endUITrace] should acts as normal and do nothing related to screen render, if screen render feature is disabled",
        () async {
      when(mHost.isScreenRenderEnabled()).thenAnswer((_) async => false);
      when(mScreenRenderManager.screenRenderEnabled).thenReturn(false);
      const traceName = "traceNameTest";
      await APM.startUITrace(traceName);
      await APM.endUITrace();

      verify(mHost.startUITrace(traceName)).called(1);
      verify(
        mHost.endUITrace(),
      ).called(1);
      verifyNever(
        mScreenRenderManager.endScreenRenderCollector(),
      );
    });
  });
}
