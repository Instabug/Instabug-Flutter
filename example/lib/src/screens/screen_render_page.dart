part of '../../main.dart';

class ScreenRenderPage extends StatefulWidget {
  const ScreenRenderPage({Key? key}) : super(key: key);
  static const String screenName = "/screenRenderPageRoute";

  @override
  State<ScreenRenderPage> createState() => _ScreenRenderPageState();
}

class _ScreenRenderPageState extends State<ScreenRenderPage> {
  @override
  Widget build(BuildContext context) {
    return Page(title: 'Screen Render', children: [
      const ScreenRenderSwitch(),
      SizedBox.fromSize(size: const Size.fromHeight(16.0)),
      const AnimatedBox(),
      SizedBox.fromSize(
        size: const Size.fromHeight(50),
      ),
      SizedBox.fromSize(size: const Size.fromHeight(16.0)),
      InstabugButton(
        text: 'Trigger Slow Frame',
        onPressed: () => _simulateHeavyComputationForSlowFrames(),
      ),
      InstabugButton(
        text: 'Trigger Frozen Frame',
        onPressed: () => _simulateHeavyComputationForFrozenFrames(),
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
  void _simulateHeavyComputationForSlowFrames() {
    Random random = Random();
    for (int i = 0; i < 1000000; i++) {
      random.nextInt(100) * random.nextInt(100);
    }
  }

  _simulateHeavyComputationForFrozenFrames() {
    final startTime = DateTime.now();
    const pauseTime = 1000;
    // Block the UI thread for ~1000ms
    while (DateTime.now().difference(startTime).inMilliseconds <= pauseTime) {
      // Busy waiting
    }
  }
}
