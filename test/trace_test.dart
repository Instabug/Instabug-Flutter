import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/generated/apm.api.g.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'trace_test.mocks.dart';

@GenerateMocks([
  ApmHostApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockApmHostApi();
  final trace = Trace(
    id: "trace",
    name: "Execution Trace",
  );

  setUpAll(() {
    APM.$setHostApi(mHost);
  });

  test('[end] should call host method', () async {
    trace.end();

    verify(
      mHost.endExecutionTrace(trace.id),
    ).called(1);
  });

  test('[setAttribute] should call host method', () async {
    const key = "attr-key";
    const attribute = "Trace Attribute";
    trace.setAttribute(key, attribute);

    verify(
      mHost.setExecutionTraceAttribute(trace.id, key, attribute),
    ).called(1);
  });
}
