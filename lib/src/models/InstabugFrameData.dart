class InstabugFrameData {
  int startTimeTimestamp;
  int duration;

  InstabugFrameData(this.startTimeTimestamp, this.duration);

  @override
  String toString() => "start time: $startTimeTimestamp, duration: $duration";

  @override
  bool operator == (covariant InstabugFrameData other) {
    if (identical(this, other)) return true;
    return startTimeTimestamp == other.startTimeTimestamp &&
        duration == other.duration;
  }
}
