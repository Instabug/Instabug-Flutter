import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/screen_loading/flags_config.dart';
import 'package:instabug_flutter/src/utils/screen_loading/route_matcher.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';
import 'package:instabug_flutter/src/utils/screen_loading/ui_trace.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'screen_loading_manager_test.mocks.dart';

class ScreenLoadingManagerNoResets extends ScreenLoadingManager {
  ScreenLoadingManagerNoResets.init() : super.init();

  @override
  void resetDidExtendScreenLoading() {}

  @override
  void resetDidReportScreenLoading() {}

  @override
  void resetDidStartScreenLoading() {}
}

@GenerateMocks([
  ApmHostApi,
  InstabugLogger,
  IBGDateTime,
  IBGBuildInfo,
  RouteMatcher,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  var mScreenLoadingManager = ScreenLoadingManager.init();
  final mHost = MockApmHostApi();
  final mInstabugLogger = MockInstabugLogger();
  final mDateTime = MockIBGDateTime();
  final mIBGBuildInfo = MockIBGBuildInfo();
  final mRouteMatcher = MockRouteMatcher();

  setUpAll(() {
    ScreenLoadingManager.setInstance(mScreenLoadingManager);
    APM.$setHostApi(mHost);
    InstabugLogger.setInstance(mInstabugLogger);
    IBGDateTime.setInstance(mDateTime);
    IBGBuildInfo.setInstance(mIBGBuildInfo);
    RouteMatcher.setInstance(mRouteMatcher);
  });

  tearDownAll(() => {});

  group('reset methods tests', () {
    test(
        '[resetDidStartScreenLoading] should set _currentUITrace?.didStartScreenLoading to false',
        () async {
      const expected = false;
      final uiTrace = UiTrace('screen1', traceId: 1);
      uiTrace.didStartScreenLoading = true;
      mScreenLoadingManager.currentUiTrace = uiTrace;

      ScreenLoadingManager.I.resetDidStartScreenLoading();

      final actual =
          ScreenLoadingManager.I.currentUiTrace?.didStartScreenLoading;

      expect(actual, expected);
      verify(
        mInstabugLogger.d(
          'Resetting didStartScreenLoading — setting didStartScreenLoading: ${uiTrace.didStartScreenLoading}',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mDateTime);
      verifyZeroInteractions(mHost);
    });

    test(
        '[resetDidReportScreenLoading] should set _currentUITrace?.didReportScreenLoading to false',
        () async {
      const expected = false;
      final uiTrace = UiTrace('screen1', traceId: 1);
      uiTrace.didReportScreenLoading = true;
      mScreenLoadingManager.currentUiTrace = uiTrace;

      ScreenLoadingManager.I.resetDidReportScreenLoading();

      final actual =
          ScreenLoadingManager.I.currentUiTrace?.didReportScreenLoading;

      expect(actual, expected);
      verify(
        mInstabugLogger.d(
          'Resetting didExtendScreenLoading — setting didExtendScreenLoading: ${uiTrace.didExtendScreenLoading}',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mHost);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[resetDidExtendScreenLoading] should set _currentUITrace?.didExtendScreenLoading to false',
        () async {
      const expected = false;
      final uiTrace = UiTrace('screen1', traceId: 1);
      mScreenLoadingManager.currentUiTrace = uiTrace;

      ScreenLoadingManager.I.resetDidExtendScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(actualUiTrace?.didExtendScreenLoading, expected);
      verify(
        mInstabugLogger.d(
          'Resetting didReportScreenLoading — setting didReportScreenLoading: ${uiTrace.didReportScreenLoading}',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mHost);
      verifyZeroInteractions(mDateTime);
    });
  });

  group('startUiTrace tests', () {
    test('[startUiTrace] with APM disabled on iOS Platform should Log error',
        () async {
      const screenName = 'screen1';
      final uiTrace = UiTrace(screenName, traceId: 1);
      ScreenLoadingManager.setInstance(ScreenLoadingManagerNoResets.init());
      mScreenLoadingManager.currentUiTrace = uiTrace;
      when(FlagsConfig.apm.isEnabled()).thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(true);

      await ScreenLoadingManager.I.startUiTrace(screenName);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      expect(actualUiTrace, null);

      verify(mHost.isEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'APM is disabled, skipping starting the UI trace for screen: $screenName.\n'
          'Please refer to the documentation for how to enable APM on your app: https://docs.instabug.com/docs/react-native-apm-disabling-enabling',
          tag: APM.tag,
        ),
      ).called(1);
      verifyZeroInteractions(mDateTime);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mDateTime);
      verifyNoMoreInteractions(mHost);
    });

    test(
        '[startUiTrace] with APM enabled on android Platform should call `APM.startCpUiTrace and set UiTrace',
        () async {
      const screenName = 'screen1';
      final time = DateTime.now();
      final uiTrace = UiTrace(screenName, traceId: time.millisecondsSinceEpoch);
      ScreenLoadingManager.setInstance(ScreenLoadingManagerNoResets.init());
      mScreenLoadingManager.currentUiTrace = uiTrace;
      when(FlagsConfig.apm.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.startUiTrace(screenName);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;

      verify(mHost.isEnabled()).called(1);
      expect(
        actualUiTrace?.didStartScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(actualUiTrace?.screenName, screenName);
      expect(actualUiTrace?.traceId, time.millisecondsSinceEpoch);
      verify(
        mHost.startCpUiTrace(
          screenName,
          time.microsecondsSinceEpoch,
          time.millisecondsSinceEpoch,
        ),
      ).called(1);
      verify(
        mInstabugLogger.d(
          'Starting Ui trace — traceId: ${time.millisecondsSinceEpoch}, screenName: $screenName, microTimeStamp: ${time.microsecondsSinceEpoch}',
          tag: APM.tag,
        ),
      ).called(1);
      verify(mDateTime.now()).called(2);
      verifyNoMoreInteractions(mDateTime);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mHost);
    });
  });

  group('startScreenLoadingTrace tests', () {
    test(
        '[startScreenLoadingTrace] with screen loading disabled on iOS Platform should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      mScreenLoadingManager.currentUiTrace = uiTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled())
          .thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(true);
      when(mDateTime.now()).thenReturn(time);

      final trace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );

      await ScreenLoadingManager.I.startScreenLoadingTrace(trace);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace,
        null,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'Screen loading monitoring is disabled, skipping starting screen loading monitoring for screen: $screenName.\n'
          'Please refer to the documentation for how to enable screen loading monitoring on your app: https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mHost);
      verifyZeroInteractions(mDateTime);
      verifyZeroInteractions(mRouteMatcher);
    });

    test(
        '[startScreenLoadingTrace] with screen loading enabled on Android should do nothing',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      mScreenLoadingManager.currentUiTrace = uiTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled())
          .thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);

      final trace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );

      await ScreenLoadingManager.I.startScreenLoadingTrace(trace);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace,
        null,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verifyNoMoreInteractions(mHost);
      verifyZeroInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[startScreenLoadingTrace] with screen loading enabled with in different screen should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      const isSameScreen = false;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).thenReturn(isSameScreen);

      final trace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );

      await ScreenLoadingManager.I.startScreenLoadingTrace(trace);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace,
        null,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mRouteMatcher.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).called(1);
      verify(
        mInstabugLogger.d(
          'failed to start screen loading trace — screenName: $screenName, startTimeInMicroseconds: ${time.microsecondsSinceEpoch}',
          tag: APM.tag,
        ),
      ).called(1);
      verify(
        mInstabugLogger.d(
          'didStartScreenLoading: ${actualUiTrace?.didStartScreenLoading}, isSameScreen: $isSameScreen',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[startScreenLoadingTrace] with screen loading enabled should start a new UI Trace',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      final time = DateTime.now();
      const screenName = 'screen1';
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      mScreenLoadingManager.currentUiTrace = uiTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(FlagsConfig.apm.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).thenReturn(true);
      final trace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );

      await ScreenLoadingManager.I.startScreenLoadingTrace(trace);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;

      expect(
        actualUiTrace?.screenName,
        screenName,
      );
      expect(
        actualUiTrace?.traceId,
        traceId,
      );
      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      verify(
        mRouteMatcher.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).called(1);
      verify(
        mInstabugLogger.d(
          'starting screen loading trace — screenName: $screenName, startTimeInMicroseconds: ${time.microsecondsSinceEpoch}',
          tag: APM.tag,
        ),
      ).called(1);
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });
  });

  group('reportScreenLoading tests', () {
    test(
        '[reportScreenLoading] with screen loading disabled on iOS Platform should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled())
          .thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(true);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.reportScreenLoading(screenLoadingTrace);

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        null,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'Screen loading monitoring is disabled, skipping reporting screen loading time for screen: $screenName.\n'
          'Please refer to the documentation for how to enable screen loading monitoring on your app: https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mHost);
      verifyZeroInteractions(mDateTime);
      verifyZeroInteractions(mRouteMatcher);
    });

    test(
        '[reportScreenLoading] with screen loading enabled on Android Platform should do nothing',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled())
          .thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.reportScreenLoading(
        screenLoadingTrace,
      );

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        null,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verifyNoMoreInteractions(mHost);
      verifyZeroInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[reportScreenLoading] with screen loading enabled with in different screen should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      int? duration;
      uiTrace.didStartScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const isSameScreen = false;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).thenReturn(isSameScreen);

      await ScreenLoadingManager.I.reportScreenLoading(
        screenLoadingTrace,
      );

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.d(
          'Failed to report screen loading trace — screenName: $screenName, '
          'startTimeInMicroseconds: ${time.microsecondsSinceEpoch}, '
          'duration: $duration, '
          'trace.duration: ${screenLoadingTrace.duration ?? 0}',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'didReportScreenLoading: ${uiTrace.didReportScreenLoading == true}, '
          'isSameName: $isSameScreen',
          tag: APM.tag,
        ),
      );
      verify(mRouteMatcher.match(routePath: screenName, actualPath: screenName))
          .called(1);
      verify(
        mInstabugLogger.e(
          argThat(contains('Dropping the screen loading capture')),
          tag: APM.tag,
        ),
      );
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mRouteMatcher);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[reportScreenLoading] with screen loading enabled and a previously reported screen loading trace should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      int? duration;
      uiTrace.didStartScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const isSameScreen = true;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).thenReturn(isSameScreen);

      await ScreenLoadingManager.I.reportScreenLoading(
        screenLoadingTrace,
      );

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.d(
          'Failed to report screen loading trace — screenName: $screenName, '
          'startTimeInMicroseconds: ${time.microsecondsSinceEpoch}, '
          'duration: $duration, '
          'trace.duration: ${screenLoadingTrace.duration ?? 0}',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'didReportScreenLoading: ${uiTrace.didReportScreenLoading == true}, '
          'isSameName: $isSameScreen',
          tag: APM.tag,
        ),
      );
      verify(mRouteMatcher.match(routePath: screenName, actualPath: screenName))
          .called(1);
      verify(
        mInstabugLogger.e(
          argThat(contains('Dropping the screen loading capture')),
          tag: APM.tag,
        ),
      );
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mRouteMatcher);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[reportScreenLoading] with screen loading enabled and an invalid screenLoadingTrace should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      ;
      uiTrace.didStartScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const isSameScreen = true;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: null,
        ),
      ).thenReturn(isSameScreen);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).thenReturn(isSameScreen);
      const ScreenLoadingTrace? expectedScreenLoadingTrace = null;

      await ScreenLoadingManager.I.reportScreenLoading(
        expectedScreenLoadingTrace,
      );

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        null,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.d(
          'Failed to report screen loading trace — screenName: null, '
          'startTimeInMicroseconds: ${expectedScreenLoadingTrace?.startTimeInMicroseconds}, '
          'duration: null, '
          'trace.duration: 0',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'didReportScreenLoading: ${uiTrace.didReportScreenLoading == true}, '
          'isSameName: $isSameScreen',
          tag: APM.tag,
        ),
      );
      verify(mRouteMatcher.match(routePath: screenName, actualPath: null))
          .called(1);
      verify(
        mInstabugLogger.e(
          argThat(contains('Dropping the screen loading capture')),
          tag: APM.tag,
        ),
      );
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mRouteMatcher);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[reportScreenLoading] with screen loading enabled and a valid trace should report it',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      const duration = 1000;
      final endTime = time.add(const Duration(microseconds: duration));
      uiTrace.didStartScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const isSameScreen = true;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);
      when(
        RouteMatcher.I.match(
          routePath: screenName,
          actualPath: screenName,
        ),
      ).thenReturn(isSameScreen);
      screenLoadingTrace.endTimeInMicroseconds = endTime.microsecondsSinceEpoch;
      screenLoadingTrace.duration = duration;

      await ScreenLoadingManager.I.reportScreenLoading(
        screenLoadingTrace,
      );

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        screenLoadingTrace.endTimeInMicroseconds,
      );
      expect(
        actualScreenLoadingTrace?.duration,
        screenLoadingTrace.duration,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mRouteMatcher.match(routePath: screenName, actualPath: screenName),
      ).called(1);
      verify(
        mHost.reportScreenLoadingCP(
          time.microsecondsSinceEpoch,
          duration,
          time.millisecondsSinceEpoch,
        ),
      ).called(1);
      verify(
        mInstabugLogger.d(
          'Reporting screen loading trace — traceId: ${uiTrace.traceId}, startTimeInMicroseconds: ${screenLoadingTrace.startTimeInMicroseconds}, durationInMicroseconds: ${screenLoadingTrace.duration}',
          tag: APM.tag,
        ),
      );
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mRouteMatcher);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mDateTime);
    });
  });

  group('endScreenLoading tests', () {
    test(
        '[endScreenLoading] with screen loading disabled on iOS Platform should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      uiTrace.didReportScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const duration = 1000;
      final endTime = time.add(const Duration(microseconds: duration));
      screenLoadingTrace.endTimeInMicroseconds = endTime.microsecondsSinceEpoch;
      screenLoadingTrace.duration = duration;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled())
          .thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(true);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.endScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        endTime.microsecondsSinceEpoch,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'Screen loading monitoring is disabled, skipping ending screen loading monitoring with APM.endScreenLoading().\n'
          'Please refer to the documentation for how to enable screen loading monitoring in your app: https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking',
          tag: APM.tag,
        ),
      ).called(1);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyNoMoreInteractions(mHost);
      verifyZeroInteractions(mDateTime);
      verifyZeroInteractions(mRouteMatcher);
    });

    test(
        '[endScreenLoading] with screen loading enabled on Android Platform should do nothing',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      uiTrace.didReportScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const duration = 1000;
      final endTime = time.add(const Duration(microseconds: duration));
      screenLoadingTrace.endTimeInMicroseconds = endTime.microsecondsSinceEpoch;
      screenLoadingTrace.duration = duration;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled())
          .thenAnswer((_) async => false);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.endScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        endTime.microsecondsSinceEpoch,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verifyNoMoreInteractions(mHost);
      verifyZeroInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test('[endScreenLoading] with a previously extended trace should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      uiTrace.didReportScreenLoading = true;
      uiTrace.didExtendScreenLoading = true;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const duration = 1000;
      final endTime = time.add(const Duration(microseconds: duration));
      screenLoadingTrace.endTimeInMicroseconds = endTime.microsecondsSinceEpoch;
      screenLoadingTrace.duration = duration;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.endScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        true,
      );
      expect(
        actualScreenLoadingTrace?.startTimeInMicroseconds,
        time.microsecondsSinceEpoch,
      );
      expect(
        actualScreenLoadingTrace?.endTimeInMicroseconds,
        endTime.microsecondsSinceEpoch,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'endScreenLoading has already been called for the current screen visit. Multiple calls to this API are not allowed during a single screen visit, only the first call will be considered.',
          tag: APM.tag,
        ),
      );
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test('[endScreenLoading] with no active screen loading should log error',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = false;
      uiTrace.didReportScreenLoading = true;
      uiTrace.didExtendScreenLoading = false;
      const duration = 1000;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.endScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        false,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        false,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'endScreenLoading wasn’t called as there is no active screen Loading trace.',
          tag: APM.tag,
        ),
      );
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test(
        '[endScreenLoading] with prematurely ended screen loading should log error and End screen loading',
        () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      uiTrace.didReportScreenLoading = true;
      uiTrace.didExtendScreenLoading = false;
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
      );
      const duration = 1000;
      const prematureDuration = 0;
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.endScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        true,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      verify(
        mInstabugLogger.e(
          'endScreenLoading was called too early in the Screen Loading cycle. Please make sure to call the API after the screen is done loading.',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'endTimeInMicroseconds: ${screenLoadingTrace.endTimeInMicroseconds}, '
          'didEndScreenLoadingPrematurely: true, extendedEndTimeInMicroseconds: $prematureDuration.',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'Extending screen loading trace — traceId: ${uiTrace.traceId}, endTimeInMicroseconds: $prematureDuration',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'Ending screen loading capture — duration: $prematureDuration',
          tag: APM.tag,
        ),
      );
      verify(mHost.endScreenLoadingCP(prematureDuration, uiTrace.traceId))
          .called(1);
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });

    test('[endScreenLoading] should End screen loading', () async {
      mScreenLoadingManager = ScreenLoadingManagerNoResets.init();
      const screenName = 'screen1';
      final time = DateTime.now();
      final traceId = time.millisecondsSinceEpoch;
      final uiTrace = UiTrace(screenName, traceId: traceId);
      uiTrace.didStartScreenLoading = true;
      uiTrace.didReportScreenLoading = true;
      uiTrace.didExtendScreenLoading = false;
      const duration = 1000;
      final endTime = time.add(const Duration(microseconds: duration));
      final screenLoadingTrace = ScreenLoadingTrace(
        screenName,
        startTimeInMicroseconds: time.microsecondsSinceEpoch,
        startMonotonicTimeInMicroseconds: time.microsecondsSinceEpoch,
        endTimeInMicroseconds: endTime.microsecondsSinceEpoch,
        duration: duration,
      );
      mScreenLoadingManager.currentUiTrace = uiTrace;
      mScreenLoadingManager.currentScreenLoadingTrace = screenLoadingTrace;
      ScreenLoadingManager.setInstance(mScreenLoadingManager);
      when(FlagsConfig.screenLoading.isEnabled()).thenAnswer((_) async => true);
      when(IBGBuildInfo.I.isIOS).thenReturn(false);
      when(mDateTime.now()).thenReturn(time);

      await ScreenLoadingManager.I.endScreenLoading();

      final actualUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final actualScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;

      expect(
        actualUiTrace?.didStartScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didReportScreenLoading,
        true,
      );
      expect(
        actualUiTrace?.didExtendScreenLoading,
        true,
      );
      verify(mHost.isScreenLoadingEnabled()).called(1);
      final extendedTime = endTime
          .add(const Duration(microseconds: duration))
          .microsecondsSinceEpoch;
      verify(
        mInstabugLogger.d(
          'endTimeInMicroseconds: ${screenLoadingTrace.endTimeInMicroseconds}, '
          'didEndScreenLoadingPrematurely: false, extendedEndTimeInMicroseconds: $extendedTime.',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'Extending screen loading trace — traceId: ${uiTrace.traceId}, endTimeInMicroseconds: $extendedTime',
          tag: APM.tag,
        ),
      );
      verify(
        mInstabugLogger.d(
          'Ending screen loading capture — duration: $extendedTime',
          tag: APM.tag,
        ),
      );
      verify(mHost.endScreenLoadingCP(duration, uiTrace.traceId)).called(1);
      verifyNoMoreInteractions(mHost);
      verifyNoMoreInteractions(mInstabugLogger);
      verifyZeroInteractions(mRouteMatcher);
      verifyZeroInteractions(mDateTime);
    });
  });
}
