import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/models/instabug_frame_data.dart';
import 'package:instabug_flutter/src/models/instabug_screen_render_data.dart';

import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:mockito/mockito.dart';

import 'instabug_screen_render_manager_test_manual_mocks.dart';

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
    when(mApmHost.deviceRefreshRate()).thenAnswer((_) async => 60);
    manager.init(mWidgetBinding);
  });

  tearDown(() {
    // Clean up state after each test
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

      expect(true, isTrue); // no crash
    });
  });

  group('startScreenRenderCollectorForTraceId()', () {
    test('should not attach timing listener if it is attached', () async {
      manager.startScreenRenderCollectorForTraceId(1);
      manager.startScreenRenderCollectorForTraceId(2);
      manager.startScreenRenderCollectorForTraceId(3);

      verify(mWidgetBinding.addTimingsCallback(any)).called(
        1,
      ); // the one form initForTesting()
    });

    test(
        'should report data to native when starting new trace from the same type',
        () async {
      ///todo: will be implemented in next sprint
    });

    test('should attach timing listener if it is not attached', () async {
      manager.stopScreenRenderCollector(); // this should detach listener safely

      manager.startScreenRenderCollectorForTraceId(1);

      verify(mWidgetBinding.addTimingsCallback(any)).called(
        2,
      ); // one form initForTesting() and one form startScreenRenderCollectorForTraceId()
    });

    test('should update the data for same trace type', () {
      const firstTraceId = 123;
      const secondTraceId = 456;

      expect(manager.screenRenderForAutoUiTrace.isNotEmpty, false);

      manager.startScreenRenderCollectorForTraceId(
        firstTraceId,
      );
      expect(manager.screenRenderForAutoUiTrace.isNotEmpty, true);
      expect(manager.screenRenderForAutoUiTrace.traceId, firstTraceId);

      manager.startScreenRenderCollectorForTraceId(
        secondTraceId,
      );
      expect(manager.screenRenderForAutoUiTrace.isNotEmpty, true);
      expect(manager.screenRenderForAutoUiTrace.traceId, secondTraceId);
    });

    test('should not update the data for same trace type', () {
      const firstTraceId = 123;
      const secondTraceId = 456;

      expect(manager.screenRenderForAutoUiTrace.isNotEmpty, false);
      expect(manager.screenRenderForCustomUiTrace.isNotEmpty, false);

      manager.startScreenRenderCollectorForTraceId(
        firstTraceId,
      );
      expect(manager.screenRenderForAutoUiTrace.isNotEmpty, true);
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
      final frameTestdata = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDuration: 1000,
        slowFramesTotalDuration: 200,
      );

      manager.setFrameData(frameTestdata);

      manager.stopScreenRenderCollector();

      expect(manager.screenRenderForAutoUiTrace.isEmpty, true);
      expect(manager.screenRenderForAutoUiTrace == frameTestdata, false);

      expect(manager.screenRenderForCustomUiTrace.isEmpty, true);
      expect(manager.screenRenderForCustomUiTrace == frameTestdata, false);
    });

    test(
        'should save and data to screenRenderForAutoUiTrace when for autoUITrace',
        () {
      final frameTestdata = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDuration: 1000,
        slowFramesTotalDuration: 200,
      );

      manager.startScreenRenderCollectorForTraceId(
        frameTestdata.traceId,
      );

      manager.setFrameData(frameTestdata);

      manager.stopScreenRenderCollector();

      expect(manager.screenRenderForAutoUiTrace.isNotEmpty, true);

      expect(manager.screenRenderForAutoUiTrace == frameTestdata, true);

      expect(manager.screenRenderForCustomUiTrace.isEmpty, true);
    });

    test(
        'should save and data to screenRenderForCustomUiTrace when for customUITrace',
        () {
      final frameTestdata = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDuration: 1000,
        slowFramesTotalDuration: 200,
      );

      manager.startScreenRenderCollectorForTraceId(
        frameTestdata.traceId,
        UiTraceType.custom,
      );

      manager.setFrameData(frameTestdata);

      manager.stopScreenRenderCollector();

      expect(manager.screenRenderForCustomUiTrace.isNotEmpty, true);

      expect(manager.screenRenderForCustomUiTrace == frameTestdata, true);

      expect(manager.screenRenderForAutoUiTrace.isEmpty, true);
    });

    test('should remove timing callback listener', () {
      manager.stopScreenRenderCollector();

      verify(mWidgetBinding.removeTimingsCallback(any)).called(1);
    });

    test(
        'should report data to native when starting new trace from the same type',
        () async {
      ///todo: will be implemented in next sprint
    });
  });

  group('endScreenRenderCollectorForCustomUiTrace()', () {
    setUp(() {
      manager.screenRenderForAutoUiTrace.clear();
      manager.screenRenderForCustomUiTrace.clear();
    });

    test('should not save data if no custom UI trace is started', () {
      final frameTestdata = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDuration: 1000,
        slowFramesTotalDuration: 200,
      );

      manager.setFrameData(frameTestdata);

      manager.endScreenRenderCollectorForCustomUiTrace();

      expect(manager.screenRenderForCustomUiTrace.isEmpty, true);
      expect(manager.screenRenderForCustomUiTrace == frameTestdata, false);
    });

    test(
        'should save data to  screenRenderForCustomUiTrace if custom UI trace is started',
        () {
      final frameTestdata = InstabugScreenRenderData(
        traceId: 123,
        frameData: [
          InstabugFrameData(10000, 200),
          InstabugFrameData(20000, 1000),
        ],
        frozenFramesTotalDuration: 1000,
        slowFramesTotalDuration: 200,
      );

      manager.startScreenRenderCollectorForTraceId(
        frameTestdata.traceId,
        UiTraceType.custom,
      );

      manager.setFrameData(frameTestdata);

      manager.endScreenRenderCollectorForCustomUiTrace();
    });

    test('should not remove timing callback listener', () {
      manager.endScreenRenderCollectorForCustomUiTrace();

      verifyNever(mWidgetBinding.removeTimingsCallback(any));
    });

    test(
        'should report data to native when starting new trace from the same type',
        () async {
      ///todo: will be implemented in next sprint
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
        manager.screenRenderForAutoUiTrace.slowFramesTotalDuration,
        buildDuration * 1000,
      ); // * 1000 to convert from milli to micro
      expect(manager.screenRenderForAutoUiTrace.frozenFramesTotalDuration, 0);
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
        manager.screenRenderForAutoUiTrace.slowFramesTotalDuration,
        rasterDuration * 1000,
      ); // * 1000 to convert from milli to micro
      expect(manager.screenRenderForAutoUiTrace.frozenFramesTotalDuration, 0);
    });

    test(
        'should detect frozen frame on build thread when durations are greater than or equal 700 ms',
        () {
      const buildDuration = 700;
      when(mockFrameTiming.buildDuration)
          .thenReturn(const Duration(milliseconds: buildDuration));
      manager.startScreenRenderCollectorForTraceId(1); // start new collector
      manager.analyzeFrameTiming(mockFrameTiming); // mock frame timing
      manager.stopScreenRenderCollector(); // should save data

      expect(manager.screenRenderForAutoUiTrace.frameData.length, 1);
      expect(
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDuration,
        buildDuration * 1000,
      ); // * 1000 to convert from milli to micro
      expect(manager.screenRenderForAutoUiTrace.slowFramesTotalDuration, 0);
    });

    test(
        'should detect frozen frame on raster thread when durations are greater than or equal 700 ms',
        () {
      const rasterBuild = 700;
      when(mockFrameTiming.buildDuration)
          .thenReturn(const Duration(milliseconds: rasterBuild));
      manager.startScreenRenderCollectorForTraceId(1); // start new collector
      manager.analyzeFrameTiming(mockFrameTiming); // mock frame timing
      manager.stopScreenRenderCollector(); // should save data

      expect(manager.screenRenderForAutoUiTrace.frameData.length, 1);
      expect(
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDuration,
        rasterBuild * 1000,
      ); // * 1000 to convert from milli to micro
      expect(manager.screenRenderForAutoUiTrace.slowFramesTotalDuration, 0);
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
        manager.screenRenderForAutoUiTrace.frozenFramesTotalDuration,
        0,
      ); // * 1000 to convert from milli to micro
      expect(manager.screenRenderForAutoUiTrace.slowFramesTotalDuration, 0);
    });
  });
}
