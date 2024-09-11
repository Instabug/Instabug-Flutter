import 'package:flutter/material.dart';

typedef ScreenNameMaskingCallback = String Function(String screen);

/// Mockable [ScreenNameMasker] responsible for masking screen names
/// before they are sent to the native SDKs.
class ScreenNameMasker {
  ScreenNameMasker._();

  static ScreenNameMasker _instance = ScreenNameMasker._();

  static ScreenNameMasker get instance => _instance;

  /// Shorthand for [instance]
  static ScreenNameMasker get I => instance;

  static const emptyScreenNameFallback = "N/A";

  ScreenNameMaskingCallback? _screenNameMaskingCallback;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(ScreenNameMasker instance) {
    _instance = instance;
  }

  // ignore: use_setters_to_change_properties
  void setMaskingCallback(ScreenNameMaskingCallback? callback) {
    _screenNameMaskingCallback = callback;
  }

  String mask(String screen) {
    if (_screenNameMaskingCallback == null) {
      return screen;
    }

    final maskedScreen = _screenNameMaskingCallback!(screen).trim();

    if (maskedScreen.isEmpty) {
      return emptyScreenNameFallback;
    }

    return maskedScreen;
  }
}
