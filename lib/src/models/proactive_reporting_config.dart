class ProactiveReportingConfigs {
  final int gapBetweenModals; // Time in seconds
  final int modalDelayAfterDetection; // Time in seconds
  final bool enabled;

  const ProactiveReportingConfigs({
    this.gapBetweenModals = 24,
    this.modalDelayAfterDetection = 20,
    this.enabled = true,
  });
}
