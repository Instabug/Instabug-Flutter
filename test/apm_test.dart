import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/generated/apm.api.g.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
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

  test('[setLogLevel] should call host method', () async {
    const level = LogLevel.debug;

    await APM.setLogLevel(level);

    verify(
      mHost.setLogLevel(level.toString()),
    ).called(1);
  });

  test('[startExecutionTrace] should call host method', () async {
    final id = DateTime.now();
    const name = "trace";

    when(mDateTime.now()).thenAnswer((_) => id);
    when(mHost.startExecutionTrace(id.toString(), name))
        .thenAnswer((_) async => id.toString());

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

    await APM.setExecutionTraceAttribute(id, key, attribute);

    verify(
      mHost.setExecutionTraceAttribute(id, key, attribute),
    ).called(1);
  });

  test('[endExecutionTrace] should call host method', () async {
    final id = DateTime.now().toString();

    await APM.endExecutionTrace(id);

    verify(
      mHost.endExecutionTrace(id),
    ).called(1);
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
      mHost.networkLogAndroid(data.toMap()),
    ).called(1);
  });
}
