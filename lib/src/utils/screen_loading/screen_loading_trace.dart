class ScreenLoadingTrace {
  ScreenLoadingTrace(
    this.screenName, {
    required this.startTimeInMicroseconds,
    this.endTimeInMicroseconds,
        this.duration,
  });
  final String screenName;
  int startTimeInMicroseconds;
  int? endTimeInMicroseconds;
  int? duration;

  ScreenLoadingTrace copyWith({
    int? traceId,
    String? screenName,
    int? startTimeInMicros,
    int? endTimeInMicros,
    int? duration,
  }) {
    return ScreenLoadingTrace(
      screenName ?? this.screenName,
      startTimeInMicroseconds: startTimeInMicros ?? this.startTimeInMicroseconds,
      endTimeInMicroseconds: endTimeInMicros ?? this.endTimeInMicroseconds,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'ScreenLoadingTrace{screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds, endTimeInMicroseconds: $endTimeInMicroseconds, duration: $duration}';
  }
}
