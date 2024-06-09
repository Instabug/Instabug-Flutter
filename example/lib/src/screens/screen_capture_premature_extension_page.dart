part of '../../main.dart';

class ScreenCapturePrematureExtensionPage extends StatefulWidget {
  static const screenName = 'screenCapturePrematureExtension';

  const ScreenCapturePrematureExtensionPage({Key? key}) : super(key: key);

  @override
  State<ScreenCapturePrematureExtensionPage> createState() =>
      _ScreenCapturePrematureExtensionPageState();
}

class _ScreenCapturePrematureExtensionPageState
    extends State<ScreenCapturePrematureExtensionPage> {
  void _extendScreenLoading() {
    APM.endScreenLoading();
  }

  @override
  Widget build(BuildContext context) {
    _extendScreenLoading();
    return const Page(
      title: 'Screen Capture Premature Extension',
      children: [
        Text(
            'This page calls endScreenLoading before it fully renders allowing us to test the scenario of premature extension of screen loading'),
      ],
    );
  }
}
