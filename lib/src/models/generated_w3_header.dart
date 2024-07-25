class GeneratedW3Header {
  num timestampInSeconds;
  int partialId;
  String w3cHeader;

  GeneratedW3Header({
    required this.timestampInSeconds,
    required this.partialId,
    required this.w3cHeader,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GeneratedW3Header &&
          runtimeType == other.runtimeType &&
          timestampInSeconds == other.timestampInSeconds &&
          partialId == other.partialId &&
          w3cHeader == other.w3cHeader;

  @override
  int get hashCode =>
      timestampInSeconds.hashCode ^ partialId.hashCode ^ w3cHeader.hashCode;
}
