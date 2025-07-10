class ThemeConfig {
  /// Primary color for UI elements indicating interactivity or call to action.
  final String? primaryColor;

  /// Background color for the main UI.
  final String? backgroundColor;

  /// Color for title text elements.
  final String? titleTextColor;

  /// Color for subtitle text elements.
  final String? subtitleTextColor;

  /// Color for primary text elements.
  final String? primaryTextColor;

  /// Color for secondary text elements.
  final String? secondaryTextColor;

  /// Color for call-to-action text elements.
  final String? callToActionTextColor;

  /// Background color for header elements.
  final String? headerBackgroundColor;

  /// Background color for footer elements.
  final String? footerBackgroundColor;

  /// Background color for row elements.
  final String? rowBackgroundColor;

  /// Background color for selected row elements.
  final String? selectedRowBackgroundColor;

  /// Color for row separator lines.
  final String? rowSeparatorColor;

  /// Text style for primary text (Android only).
  final String? primaryTextStyle;

  /// Text style for secondary text (Android only).
  final String? secondaryTextStyle;

  /// Text style for title text (Android only).
  final String? titleTextStyle;

  /// Text style for call-to-action text (Android only).
  final String? ctaTextStyle;

  /// Path to primary font file.
  final String? primaryFontPath;

  /// Asset path to primary font file.
  final String? primaryFontAsset;

  /// Path to secondary font file.
  final String? secondaryFontPath;

  /// Asset path to secondary font file.
  final String? secondaryFontAsset;

  /// Path to call-to-action font file.
  final String? ctaFontPath;

  /// Asset path to call-to-action font file.
  final String? ctaFontAsset;

  const ThemeConfig({
    this.primaryColor,
    this.backgroundColor,
    this.titleTextColor,
    this.subtitleTextColor,
    this.primaryTextColor,
    this.secondaryTextColor,
    this.callToActionTextColor,
    this.headerBackgroundColor,
    this.footerBackgroundColor,
    this.rowBackgroundColor,
    this.selectedRowBackgroundColor,
    this.rowSeparatorColor,
    this.primaryTextStyle,
    this.secondaryTextStyle,
    this.titleTextStyle,
    this.ctaTextStyle,
    this.primaryFontPath,
    this.primaryFontAsset,
    this.secondaryFontPath,
    this.secondaryFontAsset,
    this.ctaFontPath,
    this.ctaFontAsset,
  });

  Map<String, dynamic> toMap() {
    return Map.fromEntries(
      [
        MapEntry('primaryColor', primaryColor),
        MapEntry('backgroundColor', backgroundColor),
        MapEntry('titleTextColor', titleTextColor),
        MapEntry('subtitleTextColor', subtitleTextColor),
        MapEntry('primaryTextColor', primaryTextColor),
        MapEntry('secondaryTextColor', secondaryTextColor),
        MapEntry('callToActionTextColor', callToActionTextColor),
        MapEntry('headerBackgroundColor', headerBackgroundColor),
        MapEntry('footerBackgroundColor', footerBackgroundColor),
        MapEntry('rowBackgroundColor', rowBackgroundColor),
        MapEntry('selectedRowBackgroundColor', selectedRowBackgroundColor),
        MapEntry('rowSeparatorColor', rowSeparatorColor),
        MapEntry('primaryTextStyle', primaryTextStyle),
        MapEntry('secondaryTextStyle', secondaryTextStyle),
        MapEntry('titleTextStyle', titleTextStyle),
        MapEntry('ctaTextStyle', ctaTextStyle),
        MapEntry('primaryFontPath', primaryFontPath),
        MapEntry('primaryFontAsset', primaryFontAsset),
        MapEntry('secondaryFontPath', secondaryFontPath),
        MapEntry('secondaryFontAsset', secondaryFontAsset),
        MapEntry('ctaFontPath', ctaFontPath),
        MapEntry('ctaFontAsset', ctaFontAsset),
      ].where((entry) => entry.value != null),
    );
  }
}
