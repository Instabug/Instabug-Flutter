import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'apm_test.mocks.dart';

@GenerateMocks([
  ApmHostApi,
  IBGDateTime,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockApmHostApi();
  final mDateTime = MockIBGDateTime();
  final mBuildInfo = MockIBGBuildInfo();

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
    verifyNoMoreInteractions(mHost);
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
    verifyNoMoreInteractions(mHost);
  });

  test('[endScreenLoading] should call host method', () async {
    final timeStampMicro = DateTime.now().microsecondsSinceEpoch;
    final uiTraceId = DateTime.now().millisecondsSinceEpoch;

    await APM.endScreenLoadingCP(timeStampMicro, uiTraceId);

    verify(
      mHost.endScreenLoadingCP(timeStampMicro, uiTraceId),
    ).called(1);
    verifyNoMoreInteractions(mHost);
  });

  test('[isSEndScreenLoadingEnabled] should call host method', () async {
    when(mHost.isEndScreenLoadingEnabled()).thenAnswer((_) async => true);
    await APM.isEndScreenLoadingEnabled();

    verify(
      mHost.isEndScreenLoadingEnabled(),
    ).called(1);
  });
}
