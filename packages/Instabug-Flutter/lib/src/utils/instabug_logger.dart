import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/ibg_date_time.dart';

abstract class Logger {
  void log(
    String message, {
    required LogLevel level,
    required String tag,
  });
}

class InstabugLogger implements Logger {
  InstabugLogger._();

  static InstabugLogger _instance = InstabugLogger._();

  static InstabugLogger get instance => _instance;

  /// Shorthand for [instance]
  static InstabugLogger get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(InstabugLogger instance) {
    _instance = instance;
  }

  LogLevel _logLevel = LogLevel.error;

  // ignore: avoid_setters_without_getters
  set logLevel(LogLevel level) {
    _logLevel = level;
  }

  @override
  void log(
    String message, {
    required LogLevel level,
    String tag = '',
  }) {
    if (level.getValue() >= _logLevel.getValue()) {
      developer.log(
        message,
        name: tag,
        time: IBGDateTime.I.now(),
        level: level.getValue(),
      );
    }
  }

  void e(
    String message, {
    String tag = '',
  }) {
    log(message, tag: tag, level: LogLevel.error);
  }

  void d(
    String message, {
    String tag = '',
  }) {
    log(message, tag: tag, level: LogLevel.debug);
  }

  void v(
    String message, {
    String tag = '',
  }) {
    log(message, tag: tag, level: LogLevel.verbose);
  }
}

extension LogLevelExtension on LogLevel {
  /// Returns the severity level to be used in the `developer.log` function.
  ///
  /// The severity level is a value between 0 and 2000.
  /// The values used here are based on the `package:logging` `Level` class.
  int getValue() {
    switch (this) {
      case LogLevel.none:
        return 2000;
      case LogLevel.error:
        return 1000;
      case LogLevel.debug:
        return 500;
      case LogLevel.verbose:
        return 0;
    }
  }
}
