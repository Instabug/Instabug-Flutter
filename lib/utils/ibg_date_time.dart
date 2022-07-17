import 'package:meta/meta.dart';

/// Mockable [DateTime] class.
class IBGDateTime {
  IBGDateTime._();

  static IBGDateTime _instance = IBGDateTime._();
  static IBGDateTime get instance => _instance;

  /// Shorthand for [instance]
  static IBGDateTime get I => instance;

  @visibleForTesting
  static void setInstance(IBGDateTime instance) {
    _instance = instance;
  }

  DateTime now() => DateTime.now();
}
