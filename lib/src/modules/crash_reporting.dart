// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:instabug_flutter/src/generated/crash_reporting.api.g.dart';
import 'package:instabug_flutter/src/models/crash_data.dart';
import 'package:instabug_flutter/src/models/error_analysis.dart';
import 'package:instabug_flutter/src/models/exception_data.dart';
import 'package:instabug_flutter/src/modules/smart_error_analyzer.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:stack_trace/stack_trace.dart';

enum NonFatalExceptionLevel { error, critical, info, warning }

class CrashReporting {
  static var _host = CrashReportingHostApi();
  static bool enabled = true;

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(CrashReportingHostApi host) {
    _host = host;
  }

  /// Enables and disables Enables and disables automatic crash reporting.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    enabled = isEnabled;
    return _host.setEnabled(isEnabled);
  }

  static Future<void> reportCrash(Object exception, StackTrace stack) async {
    if (IBGBuildInfo.instance.isReleaseMode && enabled) {
      await _reportUnhandledCrash(exception, stack);
    } else {
      FlutterError.dumpErrorToConsole(
        FlutterErrorDetails(stack: stack, exception: exception),
      );
    }
  }

  /// Reports a handled crash to you dashboard
  /// [Object] exception
  /// [StackTrace] stack
  static Future<void> reportHandledCrash(
    Object exception,
    StackTrace? stack, {
    Map<String, String>? userAttributes,
    String? fingerprint,
    NonFatalExceptionLevel level = NonFatalExceptionLevel.error,
  }) async {
    await _sendHandledCrash(
      exception,
      stack ?? StackTrace.current,
      userAttributes,
      fingerprint,
      level,
    );
  }

  static Future<void> _reportUnhandledCrash(
    Object exception,
    StackTrace stack,
  ) async {
    await _sendCrash(exception, stack, false);
  }

  static Future<void> _sendCrash(
    Object exception,
    StackTrace stack,
    bool handled,
  ) async {
    final crashData = getCrashDataFromException(stack, exception);

    return _host.send(jsonEncode(crashData), handled);
  }

  static Future<void> _sendHandledCrash(
    Object exception,
    StackTrace stack,
    Map<String, String>? userAttributes,
    String? fingerprint,
    NonFatalExceptionLevel? nonFatalExceptionLevel,
  ) async {
    final crashData = getCrashDataFromException(stack, exception);

    return _host.sendNonFatalError(
      jsonEncode(crashData),
      userAttributes,
      fingerprint,
      nonFatalExceptionLevel.toString(),
    );
  }

  static CrashData getCrashDataFromException(
    StackTrace stack,
    Object exception,
  ) {
    final trace = Trace.from(stack);
    final frames = trace.frames
        .map(
          (frame) => ExceptionData(
            file: frame.uri.toString(),
            methodName: frame.member,
            lineNumber: frame.line,
            column: frame.column ?? 0,
          ),
        )
        .toList();

    final crashData = CrashData(
      os: IBGBuildInfo.instance.operatingSystem,
      message: exception.toString(),
      exception: frames,
    );
    return crashData;
  }


  /// Reports an error with smart analysis and categorization
  /// [Object] error - The error to analyze and report
  /// [StackTrace?] stack - Optional stack trace
  /// [Map<String, String>?] userAttributes - Additional user attributes
  /// [String?] fingerprint - Custom fingerprint for grouping
  /// [NonFatalExceptionLevel] level - Error level
  static Future<void> reportErrorWithAnalysis(
      Object error, {
        StackTrace? stack,
        Map<String, String>? userAttributes,
        String? fingerprint,
        NonFatalExceptionLevel level = NonFatalExceptionLevel.error,
      }) async {
    // Analyze the error
    final analysis = await SmartErrorAnalyzer.analyzeError(error);

    // Prepare additional data with analysis results
    final enhancedUserAttributes = <String, String>{
      ...?userAttributes,
      'error_category': analysis.category.name,
      'error_severity': analysis.severity.name,
      'suggested_solutions': analysis.suggestedSolutions.join('; '),
      'estimated_fix_time_minutes': analysis.estimatedFixTime.toString(),
      'analysis_timestamp': analysis.timestamp.toIso8601String(),
    };

    // Report with enhanced data
    await reportHandledCrash(
      error,
      stack ?? StackTrace.current,
      userAttributes: enhancedUserAttributes,
      fingerprint: fingerprint ?? generateFingerprint(analysis),
      level: level,
    );
  }

  /// Generates a fingerprint based on error analysis for better grouping
  static String generateFingerprint(ErrorAnalysis analysis) {
    return '${analysis.category.name}_${analysis.severity.name}_${analysis.errorMessage.hashCode}';
  }

  /// Reports multiple errors with batch analysis
  /// [List<Object>] errors - List of errors to analyze
  static Future<void> reportErrorsWithBatchAnalysis(List<Object> errors) async {
    final analyses = <ErrorAnalysis>[];

    // Analyze all errors
    for (final error in errors) {
      final analysis = await SmartErrorAnalyzer.analyzeError(error);
      analyses.add(analysis);
    }

    // Group by category and severity
    final groupedErrors = <String, List<ErrorAnalysis>>{};
    for (final analysis in analyses) {
      final key = '${analysis.category.name}_${analysis.severity.name}';
      groupedErrors.putIfAbsent(key, () => []).add(analysis);
    }

    // Report each group
    for (final entry in groupedErrors.entries) {
      final groupAnalyses = entry.value;
      final totalFixTime = groupAnalyses.fold<int>(0, (sum, analysis) => sum + analysis.estimatedFixTime);

      await reportHandledCrash(
        Exception('Batch Error: ${entry.key} (${groupAnalyses.length} errors)'),
        StackTrace.current,
        userAttributes: {
          'error_group': entry.key,
          'error_count': groupAnalyses.length.toString(),
          'total_fix_time_minutes': totalFixTime.toString(),
          'error_categories': groupAnalyses.map((a) => a.category.name).join(', '),
        },
        fingerprint: 'batch_${entry.key}',
        level: _getHighestSeverityLevel(groupAnalyses),
      );
    }
  }

  /// Determines the highest severity level from a list of analyses
  static NonFatalExceptionLevel _getHighestSeverityLevel(List<ErrorAnalysis> analyses) {
    if (analyses.any((a) => a.severity == ErrorSeverity.critical)) {
      return NonFatalExceptionLevel.critical;
    }
    if (analyses.any((a) => a.severity == ErrorSeverity.high)) {
      return NonFatalExceptionLevel.error;
    }
    if (analyses.any((a) => a.severity == ErrorSeverity.medium)) {
      return NonFatalExceptionLevel.warning;
    }
    return NonFatalExceptionLevel.info;
  }
}
