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
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScreenLoadingTrace &&
          runtimeType == other.runtimeType &&
          screenName == other.screenName &&
          startTimeInMicroseconds == other.startTimeInMicroseconds;

  @override
  int get hashCode => screenName.hashCode ^ startTimeInMicroseconds.hashCode;

  @override
  String toString() {
    return 'ScreenLoadingTrace{screenName: $screenName, startTimeInMicroseconds: $startTimeInMicroseconds, endTimeInMicroseconds: $endTimeInMicroseconds, duration: $duration}';
  }
}
