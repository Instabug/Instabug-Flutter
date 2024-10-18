class FeatureFlag {
  /// the name of feature flag
  String name;

  /// The variant of the feature flag.
  String? variant;

  FeatureFlag({required this.name, this.variant});
}
