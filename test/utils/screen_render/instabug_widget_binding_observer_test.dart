import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_widget_binding_observer.dart';
import 'package:instabug_flutter/src/utils/ui_trace/ui_trace.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_widget_binding_observer_test.mocks.dart';

@GenerateMocks([
  InstabugScreenRenderManager,
  ScreenLoadingManager,
  ScreenNameMasker,
  UiTrace,
])
void main() {
  late MockInstabugScreenRenderManager mockRenderManager;
  late MockScreenLoadingManager mockLoadingManager;
  late MockScreenNameMasker mockNameMasker;
  late MockUiTrace mockUiTrace;

  setUp(() {
    mockRenderManager = MockInstabugScreenRenderManager();
    mockLoadingManager = MockScreenLoadingManager();
    mockNameMasker = MockScreenNameMasker();
    mockUiTrace = MockUiTrace();

    // Inject singleton mocks
    InstabugScreenRenderManager.setInstance(mockRenderManager);
    ScreenLoadingManager.setInstance(mockLoadingManager);
    ScreenNameMasker.setInstance(mockNameMasker);
  });

  group('InstabugWidgetsBindingObserver', () {
    test('returns the singleton instance', () {
      final instance = InstabugWidgetsBindingObserver.instance;
      final shorthand = InstabugWidgetsBindingObserver.I;
      expect(instance, isA<InstabugWidgetsBindingObserver>());
      expect(shorthand, same(instance));
    });

    test('handles AppLifecycleState.resumed and starts UiTrace', () async {
      when(mockLoadingManager.currentUiTrace).thenReturn(mockUiTrace);
      when(mockUiTrace.screenName).thenReturn("HomeScreen");
      when(mockNameMasker.mask("HomeScreen")).thenReturn("MaskedHome");
      when(mockLoadingManager.startUiTrace("MaskedHome", "HomeScreen"))
          .thenAnswer((_) async => 123);

      InstabugWidgetsBindingObserver.I
          .didChangeAppLifecycleState(AppLifecycleState.resumed);

      // wait for async call to complete
      await untilCalled(
          mockRenderManager.startScreenRenderCollectorForTraceId(123));

      verify(mockRenderManager.startScreenRenderCollectorForTraceId(123))
          .called(1);
    });

    test('handles AppLifecycleState.paused and stops render collector', () {
      InstabugWidgetsBindingObserver.I
          .didChangeAppLifecycleState(AppLifecycleState.paused);
      verify(mockRenderManager.stopScreenRenderCollector()).called(1);
    });

    test('handles AppLifecycleState.detached and stops render collector', () {
      InstabugWidgetsBindingObserver.I
          .didChangeAppLifecycleState(AppLifecycleState.detached);
      verify(mockRenderManager.stopScreenRenderCollector()).called(1);
    });

    test('handles AppLifecycleState.inactive with no action', () {
      // Just ensure it doesn't crash
      expect(() {
        InstabugWidgetsBindingObserver.I
            .didChangeAppLifecycleState(AppLifecycleState.inactive);
      }, returnsNormally);
    });

    test('handles AppLifecycleState.hidden with no action', () {
      expect(() {
        InstabugWidgetsBindingObserver.I
            .didChangeAppLifecycleState(AppLifecycleState.hidden);
      }, returnsNormally);
    });

    test('_handleResumedState does nothing if no currentUiTrace', () {
      when(mockLoadingManager.currentUiTrace).thenReturn(null);

      InstabugWidgetsBindingObserver.I
          .didChangeAppLifecycleState(AppLifecycleState.resumed);

      verifyNever(mockRenderManager.startScreenRenderCollectorForTraceId(any));
    });

    test('checkForWidgetBinding ensures initialization', () {
      expect(() => checkForWidgetBinding(), returnsNormally);
    });
  });
}
