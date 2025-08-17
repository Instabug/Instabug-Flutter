part of '../../main.dart';

class TracesContent extends StatefulWidget {
  const TracesContent({Key? key}) : super(key: key);

  @override
  State<TracesContent> createState() => _TracesContentState();
}

class _TracesContentState extends State<TracesContent> {
  final traceNameController = TextEditingController();
  final traceKeyAttributeController = TextEditingController();
  final traceValueAttributeController = TextEditingController();

  bool? didTraceEnd;

  Trace? trace;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        InstabugTextField(
          label: 'Trace name',
          labelStyle: textTheme.labelMedium,
          controller: traceNameController,
          symanticLabel: 'trace_name_input',
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(10.0),
        ),
        Row(
          children: [
            Flexible(
              flex: 5,
              child: InstabugButton.smallFontSize(
                text: 'Start Trace',
                symanticLabel: 'start_trace',
                onPressed: () => _startTrace(traceNameController.text),
                margin: const EdgeInsetsDirectional.only(
                  start: 20.0,
                  end: 10.0,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: InstabugButton.smallFontSize(
                text: 'Start Trace With Delay',
                symanticLabel: 'start_trace_with_delay',
                onPressed: () => _startTrace(
                  traceNameController.text,
                  delayInMilliseconds: 5000,
                ),
                margin: const EdgeInsetsDirectional.only(
                  start: 10.0,
                  end: 20.0,
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Flexible(
              flex: 5,
              child: InstabugTextField(
                label: 'Trace Key Attribute',
                symanticLabel: 'trace_key_attribute_input',
                controller: traceKeyAttributeController,
                labelStyle: textTheme.labelMedium,
                margin: const EdgeInsetsDirectional.only(
                  end: 10.0,
                  start: 20.0,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: InstabugTextField(
                label: 'Trace Value Attribute',
                symanticLabel: 'trace_value_attribute_input',
                labelStyle: textTheme.labelMedium,
                controller: traceValueAttributeController,
                margin: const EdgeInsetsDirectional.only(
                  start: 10.0,
                  end: 20.0,
                ),
              ),
            ),
          ],
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(10.0),
        ),
        InstabugButton(
          text: 'Set Trace Attribute',
          symanticLabel: 'set_trace_attribute',
          onPressed: () => _setTraceAttribute(
            trace,
            traceKeyAttribute: traceKeyAttributeController.text,
            traceValueAttribute: traceValueAttributeController.text,
          ),
        ),
        InstabugButton(
          text: 'End Trace',
          symanticLabel: 'end_trace',
          onPressed: () => _endTrace(),
        ),
      ],
    );
  }

  void _startTrace(
    String traceName, {
    int delayInMilliseconds = 0,
  }) {
    if (traceName.trim().isNotEmpty) {
      log('_startTrace — traceName: $traceName, delay in Milliseconds: $delayInMilliseconds');
      log('traceName: $traceName');
      Future.delayed(
          Duration(milliseconds: delayInMilliseconds),
          () => APM
              .startExecutionTrace(traceName)
              .then((value) => trace = value));
    } else {
      log('startTrace - Please enter a trace name');
    }
  }

  void _endTrace() {
    if (didTraceEnd == true) {
      log('_endTrace — Please, start a new trace before setting attributes.');
    }
    if (trace == null) {
      log('_endTrace — Please, start a trace before ending it.');
    }
    log('_endTrace — ending Trace.');
    trace?.end();
    didTraceEnd = true;
  }

  void _setTraceAttribute(
    Trace? trace, {
    required String traceKeyAttribute,
    required String traceValueAttribute,
  }) {
    if (trace == null) {
      log('_setTraceAttribute — Please, start a trace before setting attributes.');
    }
    if (didTraceEnd == true) {
      log('_setTraceAttribute — Please, start a new trace before setting attributes.');
    }
    if (traceKeyAttribute.trim().isEmpty) {
      log('_setTraceAttribute — Please, fill the trace key attribute input before settings attributes.');
    }
    if (traceValueAttribute.trim().isEmpty) {
      log('_setTraceAttribute — Please, fill the trace value attribute input before settings attributes.');
    }
    log('_setTraceAttribute — setting attributes -> key: $traceKeyAttribute, value: $traceValueAttribute.');
    trace?.setAttribute(traceKeyAttribute, traceValueAttribute);
  }
}
