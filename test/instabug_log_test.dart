import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug_log.api.g.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_log_test.mocks.dart';

@GenerateMocks([
  InstabugLogHostApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockInstabugLogHostApi();

  setUpAll(() {
    InstabugLog.$setHostApi(mHost);
  });

  test('[logVerbose] should call host method', () async {
    const message = "Log message";

    await InstabugLog.logVerbose(message);

    verify(
      mHost.logVerbose(message),
    ).called(1);
  });

  test('[logDebug] should call host method', () async {
    const message = "Log message";

    await InstabugLog.logDebug(message);

    verify(
      mHost.logDebug(message),
    ).called(1);
  });

  test('[logInfo] should call host method', () async {
    const message = "Log message";

    await InstabugLog.logInfo(message);

    verify(
      mHost.logInfo(message),
    ).called(1);
  });

  test('[logWarn] should call host method', () async {
    const message = "Log message";

    await InstabugLog.logWarn(message);

    verify(
      mHost.logWarn(message),
    ).called(1);
  });

  test('[logError] should call host method', () async {
    const message = "Log message";

    await InstabugLog.logError(message);

    verify(
      mHost.logError(message),
    ).called(1);
  });

  test('[clearAllLogs] should call host method', () async {
    await InstabugLog.clearAllLogs();

    verify(
      mHost.clearAllLogs(),
    ).called(1);
  });
}
