class UiTrace {
  final String screenName;
  final int traceId;
  bool isScreenLoadingTraceReported = false;

  UiTrace(
    this.screenName, {
    required this.traceId,
  });

  UiTrace copyWith({
    String? screenName,
    int? traceId,
  }) {
    return UiTrace(
      screenName ?? this.screenName,
      traceId: traceId ?? this.traceId,
    );
  }
}
