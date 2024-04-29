class UiTrace {
  final String screenName;
  final int traceId;
  bool didStartScreenLoading = false;
  bool didReportScreenLoading = false;
  bool didExtendScreenLoading = false;

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
