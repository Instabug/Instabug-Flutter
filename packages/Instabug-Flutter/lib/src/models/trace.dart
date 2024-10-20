import 'package:instabug_flutter/src/modules/apm.dart';

class Trace {
  Trace({
    required this.id,
    required this.name,
  });

  final String id;
  final String name;
  final Map<String, dynamic> attributes = {};

  /// Sets attribute of execution trace.
  /// [String] id of the trace.
  /// [String] key of attribute.
  /// [String] value of attribute.
  ///
  /// Please migrate to the App Flows APIs: [APM.startFlow], [APM.setFlowAttribute], and [APM.endFlow].
  @Deprecated(
    'Please migrate to the App Flows APIs: APM.startAppFlow, APM.endFlow, and APM.setFlowAttribute. This feature was deprecated in v13.0.0',
  )
  void setAttribute(String key, String value) {
    APM.setExecutionTraceAttribute(id, key, value);
    attributes[key] = value;
  }

  /// Ends Execution Trace
  ///
  /// Please migrate to the App Flows APIs: [APM.startFlow], [APM.setFlowAttribute], and [APM.endFlow].
  @Deprecated(
    'Please migrate to the App Flows APIs: APM.startAppFlow, APM.endFlow, and APM.setFlowAttribute. This feature was deprecated in v13.0.0',
  )
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
