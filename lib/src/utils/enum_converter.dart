extension EnumConverter on List<Enum>? {
  /// Converts a list of enums to a strings.
  List<String> mapToString() {
    return this?.map((x) => x.toString()).toList() ?? [];
  }
}
