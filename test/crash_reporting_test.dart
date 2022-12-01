import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/generated/crash_reporting.api.g.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;

import 'crash_reporting_test.mocks.dart';

@GenerateMocks([
  CrashReportingHostApi,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockCrashReportingHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  setUpAll(() {
    CrashReporting.$setHostApi(mHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await CrashReporting.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[reportHandledCrash] should call host method', () async {
    try {
      final params = <dynamic>[1, 2];
      params[5] = 2;
    } catch (exception, stack) {
      final trace = stack_trace.Trace.from(stack);
      final frames = trace.frames
          .map(
            (frame) => ExceptionData(
              file: frame.uri.toString(),
              methodName: frame.member,
              lineNumber: frame.line,
              column: frame.column ?? 0,
            ),
          )
          .toList();

      when(mBuildInfo.operatingSystem).thenReturn('unit-test');

      final data = CrashData(
        os: IBGBuildInfo.instance.operatingSystem,
        message: exception.toString(),
        exception: frames,
      );

      await CrashReporting.reportHandledCrash(exception, stack);

      verify(
        mHost.send(jsonEncode(data), true),
      ).called(1);
    }
  });
}
