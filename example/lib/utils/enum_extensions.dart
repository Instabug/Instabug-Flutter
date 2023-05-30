extension EnumLabel on Enum {
  String get capitalizedName {
    return name
        .replaceAllMapped(
          RegExp('([A-Z]+)'),
          (match) => ' ${match.group(0)}',
        )
        .toLowerCase()
        .replaceAllMapped(
          RegExp('(^|\\s)[a-z]'),
          (match) => match.group(0)!.toUpperCase(),
        );
  }
}
