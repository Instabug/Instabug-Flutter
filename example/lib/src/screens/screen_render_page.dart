part of '../../main.dart';

class ScreenRenderPage extends StatefulWidget {
  const ScreenRenderPage({Key? key}) : super(key: key);
  static const String screenName = "/screenRenderPageRoute";

  @override
  State<ScreenRenderPage> createState() => _ScreenRenderPageState();
}

class _ScreenRenderPageState extends State<ScreenRenderPage> {
  final durationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Page(title: 'Screen Render', children: [
      SizedBox.fromSize(size: const Size.fromHeight(16.0)),
      const AnimatedBox(),
      SizedBox.fromSize(
        size: const Size.fromHeight(50),
      ),
      InstabugTextField(
        label: 'Frame duration in milliseconds',
        labelStyle: Theme.of(context).textTheme.labelMedium,
        controller: durationController,
      ),
      SizedBox.fromSize(size: const Size.fromHeight(16.0)),
      InstabugButton(
        text: 'Perform Heavy Computation',
        onPressed: () => _simulateHeavyComputation(),
      ),
      InstabugButton(
        text: 'Monitored Complex Page',
        onPressed: () => _navigateToComplexPage(context),
      ),
    ]);
  }

  void _navigateToComplexPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComplexPage.monitored(),
        settings: const RouteSettings(
          name: ComplexPage.screenName,
        ),
      ),
    );
  }

  // Simulates a computationally expensive task
  void _simulateHeavyComputation() {
    final startTime = DateTime.now();
    final pauseTime = double.tryParse(durationController.text.trim());
    // Block the UI thread for ~500ms
    if (pauseTime == null) {
      return log("enter a valid number");
    }
    while (DateTime.now().difference(startTime).inMilliseconds <= pauseTime) {
      // Busy waiting
    }
  }
}
