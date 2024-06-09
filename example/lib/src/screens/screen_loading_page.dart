part of '../../main.dart';

class ScreenLoadingPage extends StatefulWidget {
  static const screenName = 'screenLoading';

  const ScreenLoadingPage({Key? key}) : super(key: key);

  @override
  State<ScreenLoadingPage> createState() => _ScreenLoadingPageState();
}

class _ScreenLoadingPageState extends State<ScreenLoadingPage> {
  final durationController = TextEditingController();
  GlobalKey _reloadKey = GlobalKey();
  final List<int> _capturedWidgets = [];

  void _render() {
    setState(() {
      // Key can be changed to force reload and re-render
      _reloadKey = GlobalKey();
    });
  }

  void _addCapturedWidget() {
    setState(() {
      debugPrint('adding captured widget');
      _capturedWidgets.add(0);
    });
  }

  ///This is the production implementation as [APM.endScreenLoading()] is the method which users use from [APM] class
  void _extendScreenLoading() async {
    APM.endScreenLoading();
  }

  ///This is a testing implementation as [APM.endScreenLoadingCP()] is marked as @internal method,
  ///Therefor we check if SCL is enabled before proceeding
  ///This check is internally done inside the production method [APM.endScreenLoading()]
  void _extendScreenLoadingTestingEnvironment() async {
    final isScreenLoadingEnabled = await APM.isScreenLoadingEnabled();
    if (isScreenLoadingEnabled) {
      final currentUiTrace = ScreenLoadingManager.I.currentUiTrace;
      final currentScreenLoadingTrace =
          ScreenLoadingManager.I.currentScreenLoadingTrace;
      final extendedEndTime =
          (currentScreenLoadingTrace?.endTimeInMicroseconds ?? 0) +
              (int.tryParse(durationController.text.toString()) ?? 0);
      APM.endScreenLoadingCP(
        extendedEndTime,
        currentUiTrace?.traceId ?? 0,
      );
    } else {
      debugPrint(
        'Screen loading monitoring is disabled, skipping ending screen loading monitoring with APM.endScreenLoading().\n'
        'Please refer to the documentation for how to enable screen loading monitoring in your app: '
        'https://docs.instabug.com/docs/flutter-apm-screen-loading#disablingenabling-screen-loading-tracking'
        "If Screen Loading is enabled but you're still seeing this message, please reach out to support.",
      );
    }
  }

  void _navigateToComplexPage() {
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

  void _navigateToMonitoredScreenCapturePrematureExtensionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InstabugCaptureScreenLoading(
          screenName: ScreenCapturePrematureExtensionPage.screenName,
          child: ScreenCapturePrematureExtensionPage(),
        ),
        settings: const RouteSettings(
          name: ScreenCapturePrematureExtensionPage.screenName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'Screen Loading',
      floatingActionButton: Container(
        height: 40,
        child: FloatingActionButton(
          tooltip: 'Add',
          onPressed: _addCapturedWidget,
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
      children: [
        SectionTitle('6x InstabugCaptureScreen'),
        KeyedSubtree(
          key: _reloadKey,
          child: InstabugCaptureScreenLoading(
            screenName: ScreenLoadingPage.screenName,
            child: InstabugCaptureScreenLoading(
              screenName: ScreenLoadingPage.screenName,
              child: InstabugCaptureScreenLoading(
                screenName: 'different screen name',
                child: InstabugCaptureScreenLoading(
                  screenName: ScreenLoadingPage.screenName,
                  child: InstabugCaptureScreenLoading(
                    screenName: ScreenLoadingPage.screenName,
                    child: InstabugCaptureScreenLoading(
                      screenName: ScreenLoadingPage.screenName,
                      child: Container(
                        margin: const EdgeInsets.only(top: 12),
                        child: InstabugButton(
                          text: 'Reload',
                          onPressed: _render, // Call _render function here
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        InstabugTextField(
          label: 'Duration',
          controller: durationController,
          keyboardType: TextInputType.number,
        ),
        Container(
            margin: const EdgeInsets.only(top: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                InstabugButton(
                  text: 'Extend Screen Loading (Testing)',
                  onPressed: _extendScreenLoadingTestingEnvironment,
                ),
                InstabugButton(
                  text: 'Extend Screen Loading (Production)',
                  onPressed: _extendScreenLoading,
                ),
              ],
            )),
        InstabugButton(
          text: 'Monitored Complex Page',
          onPressed: _navigateToComplexPage,
        ),
        InstabugButton(
          text: 'Screen Capture Premature Extension Page',
          onPressed: _navigateToMonitoredScreenCapturePrematureExtensionPage,
        ),
        SectionTitle('Dynamic Screen Loading list'),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5, childAspectRatio: 5),
              reverse: false,
              shrinkWrap: true,
              itemCount: _capturedWidgets.length,
              itemBuilder: (context, index) {
                return InstabugCaptureScreenLoading(
                  screenName: ScreenLoadingPage.screenName,
                  child: Text(index.toString()),
                );
              },
            ),
          ),
        ),
        SizedBox.fromSize(
          size: const Size.fromHeight(12),
        ),
      ],
    );
  }
}
