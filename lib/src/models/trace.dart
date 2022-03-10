import '../modules/apm.dart';

class Trace {
  const Trace({
    required this.id,
    this.name = '',
    Map<String, dynamic>? listOfAttributes,
  }) : attributes = listOfAttributes ?? const <String, dynamic>{};

  final String id;
  final String name;
  final Map<String, dynamic> attributes;

  void setAttribute(String key, String value) {
    APM.setExecutionTraceAttribute(id, key, value);
    attributes[key] = value;
  }

  void end() {
    APM.endExecutionTrace(id);
  }

  Map<String, dynamic> toJson() => toMap();

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'attributes': attributes,
      };
}
