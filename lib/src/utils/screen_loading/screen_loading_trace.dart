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
    String? screenName,
    int? startTimeInMicroseconds,
    int? endTimeInMicroseconds,
    int? duration,
  }) {
    return ScreenLoadingTrace(
      screenName ?? this.screenName,
      startTimeInMicroseconds:
          startTimeInMicroseconds ?? this.startTimeInMicroseconds,
      endTimeInMicroseconds:
          endTimeInMicroseconds ?? this.endTimeInMicroseconds,
      duration: duration ?? this.duration,
    );
  }

  @override
  String toString() {
    return 'ScreenLoadingTrace{screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds, endTimeInMicroseconds: $endTimeInMicroseconds, duration: $duration}';
  }
}
