part of '../../main.dart';

class UITracesContent extends StatefulWidget {
  const UITracesContent({Key? key}) : super(key: key);

  @override
  State<UITracesContent> createState() => _UITracesContentState();
}

class _UITracesContentState extends State<UITracesContent> {
  final traceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        InstabugTextField(
          label: 'UI Trace name',
          labelStyle: textTheme.labelMedium,
          controller: traceNameController,
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(10.0),
        ),
        Row(
          children: [
            Flexible(
              flex: 5,
              child: InstabugButton.smallFontSize(
                text: 'Start UI Trace',
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
                text: 'End UI Trace',
                onPressed: () => _endTrace(),
                margin: const EdgeInsetsDirectional.only(
                  start: 10.0,
                  end: 20.0,
                ),
              ),
            ),
          ],
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
      Future.delayed(Duration(milliseconds: delayInMilliseconds),
          () => APM.startUITrace(traceName));
    } else {
      log('startUITrace - Please enter a trace name');
    }
  }

  void _endTrace() {
    log('endUITrace - ');
    APM.endUITrace();
  }
}
