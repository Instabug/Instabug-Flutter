import '../models/error_analysis.dart';
import '../utils/error_classifier.dart';

class SmartErrorAnalyzer {
  static Future<ErrorAnalysis> analyzeError(dynamic error) async {
     final category = ErrorClassifier.classifyError(error);

     final severity = ErrorClassifier.determineSeverity(error, category);

     final solutions = await _suggestSolutions(category, error);

     final fixTime = _estimateFixTime(severity, category);

    return ErrorAnalysis(
      category: category,
      severity: severity,
      suggestedSolutions: solutions,
      estimatedFixTime: fixTime,
      errorMessage: error.toString(),
      timestamp: DateTime.now(),
    );
  }

  static Future<List<String>> _suggestSolutions(ErrorCategory category, dynamic error) async {
    final solutions = <String>[];

    switch (category) {
      case ErrorCategory.network:
        solutions.addAll([
          'Check internet connection',
          'Retry after 30 seconds',
          'Verify network settings',
          'Check server status',
          'Try using different network',
        ]);
        break;

      case ErrorCategory.database:
        solutions.addAll([
          'Verify input data validity',
          'Check database connection',
          'Restart the application',
          'Verify access permissions',
          'Check database schema',
        ]);
        break;

      case ErrorCategory.ui:
        solutions.addAll([
          'Restart the application',
          'Clear app cache',
          'Update to latest version',
          'Check device compatibility',
          'Report to support team',
        ]);
        break;

      case ErrorCategory.performance:
        solutions.addAll([
          'Close other applications',
          'Restart the device',
          'Clear device cache',
          'Update device OS',
          'Check available memory',
        ]);
        break;

      case ErrorCategory.security:
        solutions.addAll([
          'Re-authenticate user',
          'Check login credentials',
          'Verify account permissions',
          'Contact support team',
          'Check account status',
        ]);
        break;

      case ErrorCategory.unknown:
        solutions.addAll([
          'Restart the application',
          'Update to latest version',
          'Contact support team',
          'Check system requirements',
          'Report the issue',
        ]);
        break;
    }

    return solutions;
  }

  static int _estimateFixTime(ErrorSeverity severity, ErrorCategory category) {
    switch (severity) {
      case ErrorSeverity.critical:
        return 120; // 2 hours
      case ErrorSeverity.high:
        return 60; // 1 hour
      case ErrorSeverity.medium:
        return 30; // 30 minutes
      case ErrorSeverity.low:
        return 15; // 15 minutes
    }
  }
}
