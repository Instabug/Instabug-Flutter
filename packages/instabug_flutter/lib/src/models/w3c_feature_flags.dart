class W3cFeatureFlags {
  bool isW3cExternalTraceIDEnabled;
  bool isW3cExternalGeneratedHeaderEnabled;
  bool isW3cCaughtHeaderEnabled;

  W3cFeatureFlags({
    required this.isW3cExternalTraceIDEnabled,
    required this.isW3cExternalGeneratedHeaderEnabled,
    required this.isW3cCaughtHeaderEnabled,
  });
}
