import 'package:instabug_flutter/src/models/exception_data.dart';

class CrashData {
  const CrashData({
    required this.os,
    required this.message,
    required this.exception,
  });

  static const platform = 'flutter';
  final String message;
  final String os;
  final List<ExceptionData> exception;

  Map<String, dynamic> toJson() {
    return {
      'os': os,
      'message': message,
      'platform': platform,
      'exception': exception,
    };
  }
}
