import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:logging/logging.dart';

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
        time: DateTime.now(),
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
  int getValue() {
    switch (this) {
      case LogLevel.none:
        return Level.OFF.value;
      case LogLevel.error:
        return Level.SEVERE.value;
      case LogLevel.debug:
        return Level.FINE.value;
      case LogLevel.verbose:
        return Level.ALL.value;
    }
  }
}
