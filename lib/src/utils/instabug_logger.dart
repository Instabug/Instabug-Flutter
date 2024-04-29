import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'dart:developer' as developer;
import 'package:logging/logging.dart' as logging;

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

  LogLevel _logLevel = LogLevel.none;

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
        return logging.Level.OFF.value;
      case LogLevel.error:
        return logging.Level.SEVERE.value;
      case LogLevel.debug:
        return logging.Level.FINE.value;
      case LogLevel.verbose:
        return logging.Level.ALL.value;
    }
  }
}
