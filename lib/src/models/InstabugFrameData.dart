class InstabugFrameData{
  int startTimeTimestamp;
  int duration;

  InstabugFrameData(this.startTimeTimestamp, this.duration);

  @override
  String toString() => "startTime: $startTimeTimestamp, duration: $duration";
}