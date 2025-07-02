part of '../../main.dart';

class APMSwitch extends StatefulWidget {
  const APMSwitch({Key? key}) : super(key: key);

  @override
  State<APMSwitch> createState() => _APMSwitchState();
}

class _APMSwitchState extends State<APMSwitch> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: APM.isEnabled(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isEnabled = snapshot.data ?? false;
            return SwitchListTile.adaptive(
              title: const Text('APM Enabled'),
              value: isEnabled,
              onChanged: (value) => onAPMChanged(context, value),
            );
          }
          return const SizedBox.shrink();
        });
  }

  void onAPMChanged(BuildContext context, bool value) {
    APM.setEnabled(value);
    showSnackBar(context, "APM is ${value ? "enabled" : "disabled"}");
    setState(() => isEnabled = value);
  }
}
