import 'dart:developer';

import 'package:meta/meta.dart';

/// Mockable, monotonic, high-resolution clock.
class InstabugMonotonicClock {
  InstabugMonotonicClock._();

  static InstabugMonotonicClock _instance = InstabugMonotonicClock._();
  static InstabugMonotonicClock get instance => _instance;

  /// Shorthand for [instance]
  static InstabugMonotonicClock get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(InstabugMonotonicClock instance) {
    _instance = instance;
  }

  int get now => Timeline.now;
}
