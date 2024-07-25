class W3CHeader {
  final bool? isW3cHeaderFound;
  final num? partialId;
  final num? networkStartTimeInSeconds;
  final String? w3CGeneratedHeader;
  final String? w3CCaughtHeader;

  W3CHeader({
    this.isW3cHeaderFound,
    this.partialId,
    this.networkStartTimeInSeconds,
    this.w3CGeneratedHeader,
    this.w3CCaughtHeader,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is W3CHeader &&
          runtimeType == other.runtimeType &&
          isW3cHeaderFound == other.isW3cHeaderFound &&
          partialId == other.partialId &&
          networkStartTimeInSeconds == other.networkStartTimeInSeconds &&
          w3CGeneratedHeader == other.w3CGeneratedHeader &&
          w3CCaughtHeader == other.w3CCaughtHeader;

  @override
  int get hashCode =>
      isW3cHeaderFound.hashCode ^
      partialId.hashCode ^
      networkStartTimeInSeconds.hashCode ^
      w3CGeneratedHeader.hashCode ^
      w3CCaughtHeader.hashCode;
}
