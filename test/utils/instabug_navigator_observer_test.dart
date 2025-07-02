import 'package:fake_async/fake_async.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_navigator_observer_test.mocks.dart';

@GenerateMocks([
  InstabugHostApi,
  ScreenLoadingManager,
  InstabugScreenRenderManager,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final mHost = MockInstabugHostApi();
  final mScreenLoadingManager = MockScreenLoadingManager();
  final mScreenRenderManager = MockInstabugScreenRenderManager();

  late InstabugNavigatorObserver observer;
  const screen = '/screen';
  const previousScreen = '/previousScreen';
  late Route route;
  late Route previousRoute;

  setUpAll(() {
    Instabug.$setHostApi(mHost);
    ScreenLoadingManager.setInstance(mScreenLoadingManager);
  });

  setUp(() {
    observer = InstabugNavigatorObserver();
    route = createRoute(screen);
    previousRoute = createRoute(previousScreen);

    ScreenNameMasker.I.setMaskingCallback(null);
    when(mScreenRenderManager.screenRenderEnabled).thenReturn(false);
  });

  test('should report screen change when a route is pushed', () {
    fakeAsync((async) async {
      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenLoadingManager.startUiTrace(screen, screen),
      ).called(1);

      verify(
        mHost.reportScreenChange(screen),
      ).called(1);
    });
  });

  test(
      'should report screen change when a route is popped and previous is known',
      () {
    fakeAsync((async) {
      when(mScreenLoadingManager.startUiTrace(previousScreen, previousScreen))
          .thenAnswer((realInvocation) async => null);

      observer.didPop(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenLoadingManager.startUiTrace(previousScreen, previousScreen),
      ).called(1);

      verify(
        mHost.reportScreenChange(previousScreen),
      ).called(1);
    });
  });

  test(
      'should not report screen change when a route is popped and previous is not known',
      () {
    fakeAsync((async) {
      observer.didPop(route, null);

      async.elapse(const Duration(milliseconds: 1000));

      verifyNever(
        mScreenLoadingManager.startUiTrace(any, any),
      );

      verifyNever(
        mHost.reportScreenChange(any),
      );
    });
  });

  test('should fallback to "N/A" when the screen name is empty', () {
    fakeAsync((async) {
      final route = createRoute('');
      const fallback = 'N/A';

      when(mScreenLoadingManager.startUiTrace(fallback, fallback))
          .thenAnswer((realInvocation) async => null);

      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenLoadingManager.startUiTrace(fallback, fallback),
      ).called(1);

      verify(
        mHost.reportScreenChange(fallback),
      ).called(1);
    });
  });

  test('should mask screen name when masking callback is set', () {
    const maskedScreen = 'maskedScreen';

    when(mScreenLoadingManager.startUiTrace(maskedScreen, screen))
        .thenAnswer((realInvocation) async => null);

    ScreenNameMasker.I.setMaskingCallback((_) => maskedScreen);

    fakeAsync((async) {
      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenLoadingManager.startUiTrace(maskedScreen, screen),
      ).called(1);

      verify(
        mHost.reportScreenChange(maskedScreen),
      ).called(1);
    });
  });

  test('should start new screen render collector when a route is pushed', () {
    fakeAsync((async) async {
      const traceID = 123;

      when(mScreenLoadingManager.startUiTrace(screen, screen))
          .thenAnswer((_) async => traceID);
      when(mScreenRenderManager.screenRenderEnabled).thenReturn(true);

      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verify(
        mScreenRenderManager.startScreenRenderCollectorForTraceId(traceID),
      ).called(1);
    });
  });

  test(
      'should not start new screen render collector when a route is pushed and [traceID] is null',
      () {
    fakeAsync((async) async {
      when(mScreenLoadingManager.startUiTrace(screen, screen))
          .thenAnswer((_) async => null);

      when(mScreenRenderManager.screenRenderEnabled).thenReturn(true);

      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verifyNever(
        mScreenRenderManager.startScreenRenderCollectorForTraceId(any),
      );
    });
  });

  test(
      'should not start new screen render collector when a route is pushed and [mScreenRenderManager.screenRenderEnabled] is false',
      () {
    fakeAsync((async) async {
      when(mScreenLoadingManager.startUiTrace(screen, screen))
          .thenAnswer((_) async => 123);

      when(mScreenRenderManager.screenRenderEnabled).thenReturn(false);

      observer.didPush(route, previousRoute);

      async.elapse(const Duration(milliseconds: 1000));

      verifyNever(
        mScreenRenderManager.startScreenRenderCollectorForTraceId(any),
      );
    });
  });
}

Route createRoute(String? name) {
  return MaterialPageRoute(
    builder: (_) => Container(),
    settings: RouteSettings(name: name),
  );
}
