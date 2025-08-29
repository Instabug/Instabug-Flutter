part of '../../main.dart';

class ApmPage extends StatefulWidget {
  static const screenName = 'apm';

  const ApmPage({Key? key}) : super(key: key);

  @override
  State<ApmPage> createState() => _ApmPageState();
}

class _ApmPageState extends State<ApmPage> {
  void _navigateToScreenLoading() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScreenLoadingPage(),
        settings: const RouteSettings(
          name: ScreenLoadingPage.screenName,
        ),
      ),
    );
  }

  _endAppLaunch() => APM.endAppLaunch();

  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'APM',
      children: [
        const APMSwitch(),
        InstabugButton(
          text: 'End App Launch',
          onPressed: _endAppLaunch,
        ),
        const SectionTitle('Network'),
        const NetworkContent(),
        const SectionTitle('Flows'),
        const FlowsContent(),
        const SectionTitle('Screen Loading'),
        SizedBox.fromSize(
          size: const Size.fromHeight(12),
        ),
        InstabugButton(
          text: 'Screen Loading',
          onPressed: _navigateToScreenLoading,
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(12),
        ),
      ],
    );
  }
}
