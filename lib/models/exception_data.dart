
class ExceptionData {

  ExceptionData(this.file, this.methodName, this.lineNumber, this.column);

  String file;
  String methodName;
  int lineNumber;
  int column;

  Map<String, dynamic> toJson() =>
  <String, dynamic> {
      'file': file,
      'methodName': methodName,
      'arguments': <dynamic>[],
      'lineNumber': lineNumber,
      'column': column,
  };

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['file'] = file;
    map['methodName'] = methodName; 
    map['arguments'] = <dynamic>[];
    map['lineNumber'] = lineNumber;
    map['column'] = column;
    return map;
  }
}