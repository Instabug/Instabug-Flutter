import 'package:stack_trace/stack_trace.dart';

class ExceptionData {
  const ExceptionData({
    required this.file,
    required this.methodName,
    required this.lineNumber,
    required this.column,
  });

  factory ExceptionData.fromFrame(Frame frame) {
    return ExceptionData(
      file: frame.uri.toString(),
      methodName: frame.member,
      lineNumber: frame.line,
      column: frame.column ?? 0,
    );
  }

  final String file;
  final String? methodName;
  final int? lineNumber;
  final int column;

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'file': file,
        'methodName': methodName,
        'arguments': [],
        'lineNumber': lineNumber,
        'column': column,
      };
}
