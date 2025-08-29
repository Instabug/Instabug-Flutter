class TracePartialId {
  int numberPartialId;
  String hexPartialId;

  TracePartialId({
    required this.numberPartialId,
    required this.hexPartialId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TracePartialId &&
          runtimeType == other.runtimeType &&
          numberPartialId == other.numberPartialId &&
          hexPartialId == other.hexPartialId);

  @override
  int get hashCode => numberPartialId.hashCode ^ hexPartialId.hashCode;
}
