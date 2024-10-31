class ScreenLoadingTrace {
  ScreenLoadingTrace(
    this.screenName, {
    required this.startTimeInMicroseconds,
    required this.startMonotonicTimeInMicroseconds,
    this.endTimeInMicroseconds,
    this.duration,
  });

  final String screenName;
  int startTimeInMicroseconds;

  /// Start time in microseconds from a monotonic clock like [InstabugMontonicClock.now].
  /// This should be preferred when measuring time durations and [startTimeInMicroseconds]
  /// should only be used when reporting the timestamps in Unix epoch.
  int startMonotonicTimeInMicroseconds;

  // TODO: Only startTimeInMicroseconds should be a Unix epoch timestamp, all
  // other timestamps should be sampled from a monotonic clock like [InstabugMontonicClock.now]
  // for higher precision and to avoid issues with system clock changes.

  // TODO: endTimeInMicroseconds depend on one another, so we can turn one of
  // them into a getter instead of storing both.
  int? endTimeInMicroseconds;
  int? duration;

  ScreenLoadingTrace copyWith({
    String? screenName,
    int? startTimeInMicroseconds,
    int? startMonotonicTimeInMicroseconds,
    int? endTimeInMicroseconds,
    int? duration,
  }) {
    return ScreenLoadingTrace(
      screenName ?? this.screenName,
      startTimeInMicroseconds:
          startTimeInMicroseconds ?? this.startTimeInMicroseconds,
      startMonotonicTimeInMicroseconds: startMonotonicTimeInMicroseconds ??
          this.startMonotonicTimeInMicroseconds,
      endTimeInMicroseconds:
          endTimeInMicroseconds ?? this.endTimeInMicroseconds,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'ScreenLoadingTrace{screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds, startMonotonicTimeInMicroseconds: $startMonotonicTimeInMicroseconds, endTimeInMicroseconds: $endTimeInMicroseconds, duration: $duration}';
  }
}
