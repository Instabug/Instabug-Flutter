part of '../../main.dart';

class FlowsContent extends StatefulWidget {
  const FlowsContent({Key? key}) : super(key: key);

  @override
  State<FlowsContent> createState() => _FlowsContentState();
}

class _FlowsContentState extends State<FlowsContent> {
  final flowNameController = TextEditingController();
  final flowKeyAttributeController = TextEditingController();
  final flowValueAttributeController = TextEditingController();

  bool? didFlowEnd;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        InstabugTextField(
          label: 'Flow name',
          labelStyle: textTheme.labelMedium,
          controller: flowNameController,
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(10.0),
        ),
        Row(
          children: [
            Flexible(
              flex: 5,
              child: InstabugButton.smallFontSize(
                text: 'Start Flow',
                onPressed: () => _startFlow(flowNameController.text),
                margin: const EdgeInsetsDirectional.only(
                  start: 20.0,
                  end: 10.0,
                ),
              ),
            ),
            Flexible(
              flex: 5,
              child: InstabugButton.smallFontSize(
                text: 'Start flow With Delay',
                onPressed: () => _startFlow(
                  flowNameController.text,
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
                label: 'Flow Key Attribute',
                controller: flowKeyAttributeController,
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
                label: 'Flow Value Attribute',
                labelStyle: textTheme.labelMedium,
                controller: flowValueAttributeController,
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
          text: 'Set Flow Attribute',
          onPressed: () => _setFlowAttribute(
            flowNameController.text,
            flowKeyAttribute: flowKeyAttributeController.text,
            flowValueAttribute: flowValueAttributeController.text,
          ),
        ),
        InstabugButton(
          text: 'End Flow',
          onPressed: () => _endFlow(flowNameController.text),
        ),
      ],
    );
  }

  void _startFlow(
    String flowName, {
    int delayInMilliseconds = 0,
  }) {
    if (flowName.trim().isNotEmpty) {
      log('_startFlow — flowName: $flowName, delay in Milliseconds: $delayInMilliseconds');
      log('flowName: $flowName');
      Future.delayed(Duration(milliseconds: delayInMilliseconds),
          () => APM.startFlow(flowName));
    } else {
      log('_startFlow - Please enter a flow name');
    }
  }

  void _endFlow(String flowName) {
    if (flowName.trim().isEmpty) {
      log('_endFlow - Please enter a flow name');
    }
    if (didFlowEnd == true) {
      log('_endFlow — Please, start a new flow before setting attributes.');
    }
    log('_endFlow — ending Flow.');
    didFlowEnd = true;
  }

  void _setFlowAttribute(
    String flowName, {
    required String flowKeyAttribute,
    required String flowValueAttribute,
  }) {
    if (flowName.trim().isEmpty) {
      log('_endFlow - Please enter a flow name');
    }
    if (didFlowEnd == true) {
      log('_setFlowAttribute — Please, start a new flow before setting attributes.');
    }
    if (flowKeyAttribute.trim().isEmpty) {
      log('_setFlowAttribute — Please, fill the flow key attribute input before settings attributes.');
    }
    if (flowValueAttribute.trim().isEmpty) {
      log('_setFlowAttribute — Please, fill the flow value attribute input before settings attributes.');
    }
    log('_setFlowAttribute — setting attributes -> key: $flowKeyAttribute, value: $flowValueAttribute.');
    APM.setFlowAttribute(flowName, flowKeyAttribute, flowValueAttribute);
  }
}
