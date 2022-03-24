import 'package:meta/meta.dart';

/// Mockable [DateTime] class.
class InstaDateTime {
  InstaDateTime._();

  static InstaDateTime _instance = InstaDateTime._();
  static InstaDateTime get instance => _instance;

  @visibleForTesting
  static void setInstance(InstaDateTime instance) {
    _instance = instance;
  }

  DateTime now() => DateTime.now();
}
