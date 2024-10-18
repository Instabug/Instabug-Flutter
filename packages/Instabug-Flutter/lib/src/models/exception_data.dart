class ExceptionData {
  const ExceptionData({
    required this.file,
    required this.methodName,
    required this.lineNumber,
    required this.column,
  });

  final String file;
  final String? methodName;
  final int? lineNumber;
  final int column;

  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'methodName': methodName,
      'arguments': <dynamic>[],
      'lineNumber': lineNumber,
      'column': column,
    };
  }
}
