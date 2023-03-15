extension EnumLabel on Enum {
  String capitalizedName([String? substringToRemove]) {
    return name
        .replaceAll(substringToRemove ?? '', '')
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
