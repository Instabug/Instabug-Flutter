import '../apm.dart';

class Trace {
  String id;
  String name = '';
  Map<String, dynamic> attributes;
  Trace(this.id, this.name, {Map<String, dynamic>? listOfAttributes})
      : this.attributes = listOfAttributes ?? new Map<String, dynamic>();

  Map<String, dynamic> toMap() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['attributes'] = attributes;
    return map;
  }

  void setAttribute(String key, String value) {
    APM.setExecutionTraceAttribute(id, key, value);
    attributes[key] = value;
  }

  void end() {
    APM.endExecutionTrace(id);
  }
}
