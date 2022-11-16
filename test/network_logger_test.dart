import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/generated/apm.api.g.dart';
import 'package:instabug_flutter/generated/instabug.api.g.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'network_logger_test.mocks.dart';

@GenerateMocks([
  ApmHostApi,
  InstabugHostApi,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mApmHost = MockApmHostApi();
  final mInstabugHost = MockInstabugHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  final logger = NetworkLogger();
  final data = NetworkData(
    url: "https://httpbin.org/get",
    method: "GET",
    startTime: DateTime.now(),
  );

  setUpAll(() {
    APM.$setHostApi(mApmHost);
    NetworkLogger.$setHostApi(mInstabugHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[networkLog] should call 1 host method on iOS', () async {
    when(mBuildInfo.isAndroid).thenReturn(false);

    await logger.networkLog(data);

    verify(
      mInstabugHost.networkLog(data.toJson()),
    ).called(1);

    verifyNever(
      mApmHost.networkLogAndroid(data.toJson()),
    );
  });

  test('[networkLog] should call 2 host methods on Android', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);

    await logger.networkLog(data);

    verify(
      mInstabugHost.networkLog(data.toJson()),
    ).called(1);

    verify(
      mApmHost.networkLogAndroid(data.toJson()),
    ).called(1);
  });
}
