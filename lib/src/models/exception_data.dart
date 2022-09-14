class ExceptionData {
  const ExceptionData(this.file, this.methodName, this.lineNumber, this.column);

  final String file;
  final String? methodName;
  final int? lineNumber;
  final int column;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'file': file,
        'methodName': methodName,
        'arguments': <dynamic>[],
        'lineNumber': lineNumber,
        'column': column,
      };

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['file'] = file;
    map['methodName'] = methodName;
    map['arguments'] = <dynamic>[];
    map['lineNumber'] = lineNumber;
    map['column'] = column;
    return map;
  }
}
