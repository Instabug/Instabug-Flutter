import 'package:instabug_flutter/src/modules/apm.dart';

class Trace {
  Trace({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
  final Map<String, dynamic> attributes = {};

  void setAttribute(String key, String value) {
    APM.setExecutionTraceAttribute(id, key, value);
    attributes[key] = value;
  }

  void end() {
    APM.endExecutionTrace(id);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'attributes': attributes,
    };
  }
}
