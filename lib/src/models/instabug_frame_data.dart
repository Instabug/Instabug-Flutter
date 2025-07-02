class InstabugFrameData {
  int startTimeTimestamp;
  int duration;

  InstabugFrameData(this.startTimeTimestamp, this.duration);

  @override
  String toString() => "start time: $startTimeTimestamp, duration: $duration";

  @override
  // ignore: hash_and_equals
  bool operator ==(covariant InstabugFrameData other) {
    if (identical(this, other)) return true;
    return startTimeTimestamp == other.startTimeTimestamp &&
        duration == other.duration;
  }

  /// Serializes the object to a List<int> for efficient channel transfer.
  List<int> toList() => [startTimeTimestamp, duration];
}
