import '../models/error_analysis.dart';

class ErrorClassifier {
  static ErrorCategory classifyError(dynamic error) {
    final errorString = error.toString().toLowerCase();

    // Network errors
    if (_containsAny(errorString, [
      'network',
      'connection',
      'timeout',
      'socket',
      'http',
      'https',
      'dio',
      'connectivity',
      'internet',
      'wifi',
      'mobile data',
    ])) {
      return ErrorCategory.network;
    }

    // Database errors
    if (_containsAny(errorString, [
      'database',
      'sql',
      'query',
      'table',
      'column',
      'constraint',
      'foreign key',
      'primary key',
      'unique',
      'not null',
    ])) {
      return ErrorCategory.database;
    }

    // UI errors
    if (_containsAny(errorString, [
      'widget',
      'build',
      'render',
      'layout',
      'overflow',
      'constraint',
      'flutter',
      'dart:ui',
      'painting',
      'rendering',
    ])) {
      return ErrorCategory.ui;
    }

    // Performance errors
    if (_containsAny(errorString, [
      'performance',
      'memory',
      'cpu',
      'slow',
      'lag',
      'freeze',
      'out of memory',
      'heap',
      'gc',
      'garbage collection',
    ])) {
      return ErrorCategory.performance;
    }

    // Security errors
    if (_containsAny(errorString, [
      'security',
      'authentication',
      'authorization',
      'token',
      'jwt',
      'permission',
      'access denied',
      'unauthorized',
      'forbidden',
    ])) {
      return ErrorCategory.security;
    }

    return ErrorCategory.unknown;
  }

  static ErrorSeverity determineSeverity(
      dynamic error, ErrorCategory category) {
    final errorString = error.toString().toLowerCase();

    // Critical errors - only for specific critical keywords
    if (_containsAny(errorString, [
      'fatal',
      'critical',
      'crash',
      'null pointer',
      'out of memory',
      'stack overflow',
    ])) {
      return ErrorSeverity.critical;
    }

    // High severity for network and security
    if (category == ErrorCategory.network ||
        category == ErrorCategory.security) {
      if (_containsAny(
          errorString, ['timeout', 'connection failed', 'unauthorized'],)) {
        return ErrorSeverity.high;
      }
    }

    // Medium severity for database
    if (category == ErrorCategory.database) {
      return ErrorSeverity.medium;
    }

    // Low severity for UI
    if (category == ErrorCategory.ui) {
      return ErrorSeverity.low;
    }

    return ErrorSeverity.medium;
  }

  static bool _containsAny(String text, List<String> keywords) {
    return keywords.any((keyword) => text.contains(keyword));
  }
}
