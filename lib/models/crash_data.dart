import 'package:instabug_flutter/models/exception_data.dart';

class CrashData {
  CrashData(this.message, this.os, this.exception);

  String message;
  String os;
  String platform = 'flutter';
  List<ExceptionData> exception;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'message': message,
        'os': os,
        'platform': platform,
        'exception': exception,
      };

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map['message'] = message;
    map['os'] = os;
    map['platform'] = platform;
    map['exception'] = exception;
    return map;
  }
}
