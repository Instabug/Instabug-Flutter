part of '../../main.dart';

class ScreenRenderPage extends StatelessWidget {
  const ScreenRenderPage({Key? key}) : super(key: key);
  static const String screenName = "/screenRenderPageRoute";

  @override
  Widget build(BuildContext context) {
    return Page(title: 'Screen Render', children: [

      const AnimatedBox(),
       SizedBox.fromSize(size: const Size.fromHeight(50),),
      InstabugButton(
        text: 'Perform Frozen Frame',
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
    // Block the UI thread for ~500ms
    while (DateTime.now().difference(startTime).inMilliseconds <= 1000) {
      // Busy waiting (not recommended in real apps)
    }
  }
}
