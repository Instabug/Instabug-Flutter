import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_trace.dart';

void main() {
  test(
      'ScreenLoadingTrace copyWith method should keep original values when no override happens',
      () {
    final trace = ScreenLoadingTrace(
      'TestScreen',
      startTimeInMicroseconds: 1000,
      startMonotonicTimeInMicroseconds: 2000,
      endTimeInMicroseconds: 3000,
      duration: 4000,
    );

    final updatedTrace = trace.copyWith();

    expect(updatedTrace.screenName, 'TestScreen');
    expect(updatedTrace.startTimeInMicroseconds, 1000);
    expect(updatedTrace.startMonotonicTimeInMicroseconds, 2000);
    expect(updatedTrace.endTimeInMicroseconds, 3000);
    expect(updatedTrace.duration, 4000);
  });

  test('ScreenLoadingTrace copyWith method updates fields correctly', () {
    final trace = ScreenLoadingTrace(
      'TestScreen',
      startTimeInMicroseconds: 1000,
      startMonotonicTimeInMicroseconds: 2000,
      endTimeInMicroseconds: 3000,
      duration: 4000,
    );

    final updatedTrace = trace.copyWith(
      startTimeInMicroseconds: 1500,
      startMonotonicTimeInMicroseconds: 2500,
      endTimeInMicroseconds: 3500,
      duration: 4500,
    );

    expect(updatedTrace.screenName, 'TestScreen');
    expect(updatedTrace.startTimeInMicroseconds, 1500);
    expect(updatedTrace.startMonotonicTimeInMicroseconds, 2500);
    expect(updatedTrace.endTimeInMicroseconds, 3500);
    expect(updatedTrace.duration, 4500);
  });

  test('ScreenLoadingTrace toString method returns correct format', () {
    final trace = ScreenLoadingTrace(
      'TestScreen',
      startTimeInMicroseconds: 1000,
      startMonotonicTimeInMicroseconds: 2000,
      endTimeInMicroseconds: 3000,
      duration: 4000,
    );

    expect(
      trace.toString(),
      'ScreenLoadingTrace{screenName: TestScreen, startTimeInMicroseconds: 1000, startMonotonicTimeInMicroseconds: 2000, endTimeInMicroseconds: 3000, duration: 4000}',
    );
  });
}
