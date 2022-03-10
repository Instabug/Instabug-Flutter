import 'exception_data.dart';

class CrashData {
  const CrashData({
    required this.message,
    required this.os,
    required this.exception,
  });

  final String message;
  final String os;
  final List<ExceptionData> exception;

  String get platform => 'flutter';

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'message': message,
        'os': os,
        'exception': exception,
        'platform': platform,
      };
}
