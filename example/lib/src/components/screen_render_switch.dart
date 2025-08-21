part of '../../main.dart';

class ScreenRenderSwitch extends StatefulWidget {
  const ScreenRenderSwitch({Key? key}) : super(key: key);

  @override
  State<ScreenRenderSwitch> createState() => _ScreenRenderSwitchState();
}

class _ScreenRenderSwitchState extends State<ScreenRenderSwitch> {
  bool isEnabled = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: APM.isScreenRenderEnabled(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            isEnabled = snapshot.data ?? false;
            return SwitchListTile.adaptive(
              title: const Text('Screen Render Enabled'),
              value: isEnabled,
              onChanged: (value) => onScreenRenderChanged(context, value),
            );
          }
          return const SizedBox.shrink();
        });
  }

  void onScreenRenderChanged(BuildContext context, bool value) {
    APM.setScreenRenderingEnabled(value);
    showSnackBar(context, "Screen Render is ${value ? "enabled" : "disabled"}");
    setState(() => isEnabled = value);
  }
}
