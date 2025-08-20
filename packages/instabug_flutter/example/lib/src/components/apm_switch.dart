import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_example/src/utils/show_messages.dart';

class APMSwitch extends StatefulWidget {
  const APMSwitch({Key? key}) : super(key: key);

  @override
  State<APMSwitch> createState() => _APMSwitchState();
}

class _APMSwitchState extends State<APMSwitch> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile.adaptive(
          title: const Text('APM Enabled'),
          value: isEnabled,
          onChanged: (value) => onAPMChanged(context, value),
        ),
      ],
    );
  }

  void onAPMChanged(BuildContext context, bool value) {
    APM.setEnabled(value);
    showSnackBar(context, "APM is ${value ? "enabled" : "disabled"}");
    setState(() => isEnabled = value);
  }
}
