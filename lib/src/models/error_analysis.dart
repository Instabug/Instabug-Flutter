enum ErrorSeverity { low, medium, high, critical }
enum ErrorCategory { ui, network, database, performance, security, unknown }

class ErrorAnalysis {
  final ErrorCategory category;
  final ErrorSeverity severity;
  final List<String> suggestedSolutions;
  final int estimatedFixTime;
  final String errorMessage;
  final DateTime timestamp;
  final Map<String, dynamic> additionalData;

  const ErrorAnalysis({
    required this.category,
    required this.severity,
    required this.suggestedSolutions,
    required this.estimatedFixTime,
    required this.errorMessage,
    required this.timestamp,
    this.additionalData = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'category': category.name,
      'severity': severity.name,
      'suggestedSolutions': suggestedSolutions,
      'estimatedFixTime': estimatedFixTime,
      'errorMessage': errorMessage,
      'timestamp': timestamp.toIso8601String(),
      'additionalData': additionalData,
    };
  }

  factory ErrorAnalysis.fromJson(Map<String, dynamic> json) {
    return ErrorAnalysis(
      category: ErrorCategory.values.firstWhere(
            (e) => e.name == json['category'],
        orElse: () => ErrorCategory.unknown,
      ),
      severity: ErrorSeverity.values.firstWhere(
            (e) => e.name == json['severity'],
        orElse: () => ErrorSeverity.medium,
      ),
      suggestedSolutions: List<String>.from(json['suggestedSolutions']),
      estimatedFixTime: json['estimatedFixTime'],
      errorMessage: json['errorMessage'],
      timestamp: DateTime.parse(json['timestamp']),
      additionalData: Map<String, dynamic>.from(json['additionalData'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'ErrorAnalysis(category: $category, severity: $severity, fixTime: ${estimatedFixTime}min)';
  }
}
