class UiTrace {
  final String screenName;
  final int traceId;
  bool didReportScreenLoading = false;
  bool didStartScreenLoading = false;

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

  @override
  String toString() {
    return 'UiTrace{screenName: $screenName, traceId: $traceId, isFirstScreenLoadingReported: $didReportScreenLoading, isFirstScreenLoading: $didStartScreenLoading}';
  }
}
