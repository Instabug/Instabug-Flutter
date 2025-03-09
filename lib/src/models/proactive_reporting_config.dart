import 'package:flutter/foundation.dart';

class ProactiveReportingConfigs {
  final int gapBetweenModals; // Time in seconds
  final int modalDelayAfterDetection; // Time in seconds
  final bool enabled;

  // Private constructor to ensure it can only be created through the builder
  const ProactiveReportingConfigs._({
    required this.gapBetweenModals,
    required this.modalDelayAfterDetection,
    required this.enabled,
  });
}

// Builder class for ProactiveReportingConfigs
class ProactiveReportingConfigsBuilder {
  int gapBetweenModals = 30; // Default: 30 seconds
  int modalDelayAfterDetection = 15; // Default: 15 seconds
  bool enabled = true; // Default: enabled

  // Logger method to handle logging
  void _logWarning(String message) {
    if (kDebugMode) {
      print('Warning: $message');
    }
  }

  /// Controls the time gap between showing 2 proactive reporting dialogs in seconds
  ProactiveReportingConfigsBuilder setGapBetweenModals(int gap) {
    if (gap <= 0) {
      _logWarning(
          'gapBetweenModals must be a positive number. Using default value of 30 seconds.');
      return this;
    }
    gapBetweenModals = gap;
    return this;
  }

  /// Controls the time gap between detecting a frustrating experience
  ProactiveReportingConfigsBuilder setModalDelayAfterDetection(int delay) {
    if (delay <= 0) {
      _logWarning(
          'modalDelayAfterDetection must be a positive number. Using default value of 15 seconds.');
      return this;
    }
    modalDelayAfterDetection = delay;
    return this;
  }

  /// Controls the state of the feature
  ProactiveReportingConfigsBuilder isEnabled(bool value) {
    enabled = value;
    return this;
  }

  ProactiveReportingConfigs build() {
    return ProactiveReportingConfigs._(
      gapBetweenModals: gapBetweenModals,
      modalDelayAfterDetection: modalDelayAfterDetection,
      enabled: enabled,
    );
  }
}
