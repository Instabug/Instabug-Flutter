import 'package:flutter/scheduler.dart' show FrameTiming;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/apm.api.g.dart';
import 'package:instabug_flutter/src/models/instabug_frame_data.dart';
import 'package:instabug_flutter/src/models/instabug_screen_render_data.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_screen_render_manager_test_manual_mocks.dart';

@GenerateMocks([ApmHostApi, FrameTiming, WidgetsBinding])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late InstabugScreenRenderManager manager;
  late MockApmHostApi mApmHost;
  late MockWidgetsBinding mWidgetBinding;

  setUp(() async {
    mApmHost = MockApmHostApi();
    mWidgetBinding = MockWidgetsBinding();
    manager = InstabugScreenRenderManager.init(); // test-only constructor
    APM.$setHostApi(mApmHost);
    when(mApmHost.getDeviceRefreshRateAndTolerance())
        .thenAnswer((_) async => [60, 0]);
    manager.init(mWidgetBinding);
  });

  group('InstabugScreenRenderManager.init()', () {
    test('should initialize timings callback and add observer', () async {
      expect(manager, isA<InstabugScreenRenderManager>());

      verify(mWidgetBinding.addObserver(any)).called(1);

      verify(mWidgetBinding.addTimingsCallback(any)).called(1);
    });

    test('calling init more that one time should do nothing', () async {
      manager.init(mWidgetBinding);
      manager.init(
        mWidgetBinding,
      ); // second call should be ignored

      verify(mWidgetBinding.addObserver(any)).called(1);

      verify(mWidgetBinding.addTimingsCallback(any)).called(1);
    });
  });

  // group('_initStaticValues', () {
  //
  //   test('should initialize _timingsCallback', () async {
  //     await manager.callInitStaticValues();
  //     expect(manager.timingsCallback, isNotNull);
  //   });
  //
  //   test('should initialize _slowFrameThresholdMs with value from _getSlowFrameThresholdMs', () async {
  //     // Patch the getter to return a known value
  //     manager.slowFrameThresholdMs = 0.0;
  //     manager.getSlowFrameThresholdMsFuture = () async => 42.0;
  //     await manager.callInitStaticValues();
  //     expect(manager.slowFrameThresholdMs, 42.0);
  //   });
  //
  //   test('should initialize _screenRenderForAutoUiTrace and _screenRenderForCustomUiTrace as empty InstabugScreenRenderData', () async {
  //     await manager.callInitStaticValues();
  //     expect(manager.screenRenderForAutoUiTrace, isA<InstabugScreenRenderData>());
  //     expect(manager.screenRenderForAutoUiTrace.frameData, isEmpty);
  //     expect(manager.screenRenderForCustomUiTrace, isA<InstabugScreenRenderData>());
  //     expect(manager.screenRenderForCustomUiTrace.frameData, isEmpty);
  //   });
  //
  //   test('should set _epochOffset on first timing in _timingsCallback', () async {
  //     await manager.callInitStaticValues();
  //     final mockFrameTiming = MockFrameTiming();
  //     manager.epochOffset = null;
  //     manager.timingsCallback([mockFrameTiming]);
  //     expect(manager.epochOffset, isNotNull);
  //   });
  // });

  group('startScreenRenderCollectorForTraceId()', () {
    test('should not attach timing listener if it is attached', () async {
      manager.startScreenRenderCollectorForTraceId(1);
      manager.startScreenRenderCollectorForTraceId(2);
      manager.startScreenRenderCollectorForTraceId(3);

      verify(mWidgetBinding.addTimingsCallback(any)).called(
        1,
      ); // the one form initForTesting()
    });

    test('should attach timing listener if it is not attached', () async {
      manager.stopScreenRenderCollector(); // this should detach listener safely

      manager.startScreenRenderCollectorForTraceId(1);

      verify(mWidgetBinding.addTimingsCallback(any)).called(
        1,
      );
    });

    test('should update the data for same trace type', () {
      const firstTraceId = 123;
      const secondTraceId = 456;

      expect(manager.screenRenderForAutoUiTrace.isActive, false);

      manager.startScreenRenderCollectorForTraceId(
        firstTraceId,
      );
      expect(manager.screenRenderForAutoUiTrace.isActive, true);
      expect(manager.screenRenderForAutoUiTrace.traceId, firstTraceId);

      manager.startScreenRenderCollectorForTraceId(
        secondTraceId,
      );
      expect(manager.screenRenderForAutoUiTrace.isActive, true);
      expect(manager.screenRenderForAutoUiTrace.traceId, secondTraceId);
    });

    test('should not update the data for same trace type', () {
      const firstTraceId = 123;
      const secondTraceId = 456;

      expect(manager.screenRenderForAutoUiTrace.isActive, false);
      expect(manager.screenRenderForCustomUiTrace.isActive, false);

      manager.startScreenRenderCollectorForTraceId(
        firstTraceId,
      );
      expect(manager.screenRenderForAutoUiTrace.isActive, true);
      expect(manager.screenRenderForAutoUiTrace.traceId, firstTraceId);

      manager.startScreenRenderCollectorForTraceId(
        secondTraceId,
        UiTraceType.custom,
      );
      expect(manager.screenRenderForAutoUiTrace.traceId, firstTraceId);
      expect(manager.screenRenderForCustomUiTrace.traceId, secondTraceId);
    });
  });

  group('stopScreenRenderCollector()', () {
    test('should not save data if no UI trace is started', () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );

      manager.setFrameData(frameTestData);

      manager.stopScreenRenderCollector();

      expect(manager.screenRenderForAutoUiTrace.isActive, false);
      expect(manager.screenRenderForAutoUiTrace == frameTestData, false);

      expect(manager.screenRenderForCustomUiTrace.isActive, false);
      expect(manager.screenRenderForCustomUiTrace == frameTestData, false);
    });

    test(
        'should save and data to screenRenderForAutoUiTrace when for autoUITrace',
        () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 400),
          InstabugFrameData(10000, 600),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 1000,
        endTimeMicro: 30000,
      );

      manager.startScreenRenderCollectorForTraceId(
        frameTestData.traceId,
      );

      manager.setFrameData(frameTestData);

      manager.stopScreenRenderCollector();

      expect(manager.screenRenderForAutoUiTrace.isActive, true);

      expect(manager.screenRenderForCustomUiTrace.isActive, false);

      expect(manager.screenRenderForAutoUiTrace == frameTestData, true);

      verify(
        mApmHost.endScreenRenderForAutoUiTrace(any),
      ); // the content has been verified in the above assertion.
    });

    test(
        'should save and data to screenRenderForCustomUiTrace when for customUITrace',
        () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 400),
          InstabugFrameData(10000, 600),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 1000,
        endTimeMicro: 30000,
      );

      manager.startScreenRenderCollectorForTraceId(
        frameTestData.traceId,
        UiTraceType.custom,
      );

      manager.setFrameData(frameTestData);

      manager.stopScreenRenderCollector();

      expect(manager.screenRenderForCustomUiTrace.isActive, true);

      expect(manager.screenRenderForAutoUiTrace.isActive, false);

      expect(manager.screenRenderForCustomUiTrace == frameTestData, true);

      verify(
        mApmHost.endScreenRenderForCustomUiTrace(any),
      ); // the content has been verified in the above assertion.
    });

    test('should not remove timing callback listener', () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );

      manager.setFrameData(frameTestData);
      manager.stopScreenRenderCollector();

      verifyNever(mWidgetBinding.removeTimingsCallback(any));
    });

    test('should report data to native side with the correct type', () async {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );

      manager.startScreenRenderCollectorForTraceId(0, UiTraceType.custom);
      manager.setFrameData(frameTestData);
      manager.stopScreenRenderCollector();
      verify(mApmHost.endScreenRenderForCustomUiTrace(any)).called(1);
      verifyNever(mApmHost.endScreenRenderForAutoUiTrace(any));
    });
  });

  group('endScreenRenderCollectorForCustomUiTrace()', () {
    setUp(() {
      manager.screenRenderForAutoUiTrace.clear();
      manager.screenRenderForCustomUiTrace.clear();
    });

    test('should not save data if no custom UI trace is started', () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );

      manager.setFrameData(frameTestData);

      manager.endScreenRenderCollector();

      expect(manager.screenRenderForCustomUiTrace.isActive, false);
      expect(manager.screenRenderForCustomUiTrace == frameTestData, false);
    });

    test(
        'should save data to  screenRenderForCustomUiTrace if custom UI trace is started',
        () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );

      manager.startScreenRenderCollectorForTraceId(
        frameTestData.traceId,
        UiTraceType.custom,
      );

      manager.setFrameData(frameTestData);

      manager.endScreenRenderCollector();
    });

    test('should not remove timing callback listener', () {
      manager.endScreenRenderCollector();

      verifyNever(mWidgetBinding.removeTimingsCallback(any));
    });

    test('should report data to native side', () async {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );

      manager.startScreenRenderCollectorForTraceId(0, UiTraceType.custom);
      manager.setFrameData(frameTestData);
      manager.endScreenRenderCollector(UiTraceType.custom);
      verify(mApmHost.endScreenRenderForCustomUiTrace(any)).called(1);
    });
  });

  group('analyzeFrameTiming()', () {
    late MockFrameTiming mockFrameTiming;

    setUp(() {
      mockFrameTiming = MockFrameTiming();
      when(mockFrameTiming.buildDuration)
          .thenReturn(const Duration(milliseconds: 1));
      when(mockFrameTiming.rasterDuration)
          .thenReturn(const Duration(milliseconds: 1));
      when(mockFrameTiming.totalSpan)
          .thenReturn(const Duration(milliseconds: 2));
      when(mockFrameTiming.timestampInMicroseconds(any)).thenReturn(1000);
    });

    test('should detect slow frame on ui thread and record duration', () {
      const buildDuration = 20;
      when(mockFrameTiming.buildDuration)
          .thenReturn(const Duration(milliseconds: buildDuration));

      manager.startScreenRenderCollectorForTraceId(1); // start new collector
      manager.analyzeFrameTiming(mockFrameTiming); // mock frame timing
      manager.stopScreenRenderCollector(); // should save data

      expect(manager.screenRenderForAutoUiTrace.frameData.length, 1);
      expect(
        manager.screenRenderForAutoUiTrace.slowFramesTotalDurationMicro,
        buildDuration * 1000,
      ); // * 1000 to convert from milliseconds to microseconds
      expect(
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDurationMicro,
        0,
      );
    });

    test('should detect slow frame on raster thread and record duration', () {
      const rasterDuration = 20;
      when(mockFrameTiming.rasterDuration)
          .thenReturn(const Duration(milliseconds: rasterDuration));

      manager.startScreenRenderCollectorForTraceId(1); // start new collector
      manager.analyzeFrameTiming(mockFrameTiming); // mock frame timing
      manager.stopScreenRenderCollector(); // should save data

      expect(manager.screenRenderForAutoUiTrace.frameData.length, 1);
      expect(
        manager.screenRenderForAutoUiTrace.slowFramesTotalDurationMicro,
        rasterDuration * 1000,
      ); // * 1000 to convert from milliseconds to microseconds
      expect(
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDurationMicro,
        0,
      );
    });

    test(
        'should detect frozen frame when durations are greater than or equal 700 ms',
        () {
      const totalTime = 700;
      when(mockFrameTiming.totalSpan)
          .thenReturn(const Duration(milliseconds: totalTime));
      manager.startScreenRenderCollectorForTraceId(1); // start new collector
      manager.analyzeFrameTiming(mockFrameTiming); // mock frame timing
      manager.stopScreenRenderCollector(); // should save data

      expect(manager.screenRenderForAutoUiTrace.frameData.length, 1);
      expect(
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDurationMicro,
        totalTime * 1000,
      ); // * 1000 to convert from milliseconds to microseconds
      expect(
        manager.screenRenderForAutoUiTrace.slowFramesTotalDurationMicro,
        0,
      );
    });

    test('should detect no slow or frozen frame under thresholds', () {
      when(mockFrameTiming.buildDuration)
          .thenReturn(const Duration(milliseconds: 5));
      when(mockFrameTiming.rasterDuration)
          .thenReturn(const Duration(milliseconds: 5));
      when(mockFrameTiming.totalSpan)
          .thenReturn(const Duration(milliseconds: 10));
      manager.analyzeFrameTiming(mockFrameTiming);
      expect(manager.screenRenderForAutoUiTrace.frameData.isEmpty, true);
      expect(
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDurationMicro,
        0,
      ); // * 1000 to convert from milliseconds to microseconds
      expect(
        manager.screenRenderForAutoUiTrace.slowFramesTotalDurationMicro,
        0,
      );
    });
  });

  group('InstabugScreenRenderManager.endScreenRenderCollector', () {
    test('should save and reset cached data if delayed frames exist', () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );
      manager.startScreenRenderCollectorForTraceId(1);
      manager.setFrameData(frameTestData);
      manager.endScreenRenderCollector();
      verify(mApmHost.endScreenRenderForAutoUiTrace(any)).called(1);
      expect(manager.screenRenderForAutoUiTrace.isEmpty, true);
      expect(manager.screenRenderForAutoUiTrace.isActive, false);
    });

    test('should report and clear custom trace if type is custom and active',
        () {
      final frameTestData = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDurationMicro: 1000,
        slowFramesTotalDurationMicro: 200,
      );
      manager.startScreenRenderCollectorForTraceId(1, UiTraceType.custom);
      manager.setFrameData(frameTestData);
      manager.endScreenRenderCollector(UiTraceType.custom);
      verify(mApmHost.endScreenRenderForCustomUiTrace(any)).called(1);
      expect(manager.screenRenderForCustomUiTrace.isEmpty, true);
      expect(manager.screenRenderForCustomUiTrace.isActive, false);
    });

    test('should return early if not enabled or timings not attached', () {
      manager.screenRenderEnabled = false;
      manager.endScreenRenderCollector();
      verifyNever(mApmHost.endScreenRenderForAutoUiTrace(any));
      verifyNever(mApmHost.endScreenRenderForCustomUiTrace(any));
    });
  });
}
