import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/screen_loading/ui_trace.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'screen_loading_manager_test.mocks.dart';

@GenerateMocks([RouteMatcher])
void main() {
  test('UiTrace copyWith method updates fields correctly', () {
    final trace = UiTrace(
      screenName: 'TestScreen',
      traceId: 123,
      matchingScreenName: 'MatchingScreen',
    );

    final updatedTrace = trace.copyWith(
      screenName: 'UpdatedScreen',
      traceId: 456,
    );

    expect(updatedTrace.screenName, 'UpdatedScreen');
    expect(updatedTrace.traceId, 456);
  });

  test('UiTrace matches method returns correct result', () {
    final mockRouteMatcher = MockRouteMatcher();
    RouteMatcher.setInstance(mockRouteMatcher);
    when(
      mockRouteMatcher.match(
        routePath: 'test/path',
        actualPath: 'MatchingScreen',
      ),
    ).thenReturn(true);

    final trace = UiTrace(
      screenName: 'TestScreen',
      traceId: 123,
      matchingScreenName: 'MatchingScreen',
    );

    expect(trace.matches('test/path'), isTrue);
  });

  test('UiTrace toString method returns correct format', () {
    final trace = UiTrace(
      screenName: 'TestScreen',
      traceId: 123,
      matchingScreenName: 'MatchingScreen',
    );

    expect(
      trace.toString(),
      'UiTrace{screenName: TestScreen, traceId: 123, isFirstScreenLoadingReported: false, isFirstScreenLoading: false}',
    );
  });
}
