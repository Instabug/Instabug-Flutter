part of '../../main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _alertShown = false;
  final buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  );

  List<ReportType> reportTypes = [];

  final primaryColorController = TextEditingController();
  final screenNameController = TextEditingController();
  final featureFlagsController = TextEditingController();

  @override
  void dispose() {
    featureFlagsController.dispose();
    screenNameController.dispose();
    primaryColorController.dispose();
    super.dispose();
  }

  void restartInstabug() {
    Instabug.setEnabled(false);
    Instabug.setEnabled(true);
    BugReporting.setInvocationEvents([InvocationEvent.floatingButton]);
  }

  void setOnDismissCallback() {
    BugReporting.setOnDismissCallback((dismissType, reportType) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('On Dismiss'),
            content: Text(
              'onDismiss callback called with $dismissType and $reportType',
            ),
          );
        },
      );
    });
  }

  void show() {
    Instabug.show();
  }

  void reportScreenChange() {
    Instabug.reportScreenChange(screenNameController.text);
  }

  void sendBugReport() {
    BugReporting.show(ReportType.bug, [InvocationOption.emailFieldOptional]);
  }

  void sendFeedback() {
    BugReporting.show(
        ReportType.feedback, [InvocationOption.emailFieldOptional]);
  }

  void showNpsSurvey() {
    Surveys.showSurvey('pcV_mE2ttqHxT1iqvBxL0w');
  }

  void showManualSurvey() {
    Surveys.showSurvey('PMqUZXqarkOR2yGKiENB4w');
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void getCurrentSessionReplaylink() async {
    final result = await SessionReplay.getSessionReplayLink();
    if (result == null) {
      const snackBar = SnackBar(
        content: Text('No Link Found'),
      );
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
    } else {
      var snackBar = SnackBar(
        content: Text(result),
      );
      ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(snackBar);
    }
  }

  void showFeatureRequests() {
    FeatureRequests.show();
  }

  void toggleReportType(ReportType reportType) {
    if (reportTypes.contains(reportType)) {
      reportTypes.remove(reportType);
    } else {
      reportTypes.add(reportType);
    }
    BugReporting.setReportTypes(reportTypes);
  }

  void changeFloatingButtonEdge() {
    BugReporting.setFloatingButtonEdge(FloatingButtonEdge.left, 200);
  }

  void setInvocationEvent(InvocationEvent invocationEvent) {
    BugReporting.setInvocationEvents([invocationEvent]);
  }

  void changePrimaryColor() {
    String text = 'FF' + primaryColorController.text.replaceAll('#', '');
    Color color = Color(int.parse(text, radix: 16));
    Instabug.setPrimaryColor(color);
  }

  void setColorTheme(ColorTheme colorTheme) {
    Instabug.setColorTheme(colorTheme);
  }

  void _navigateToCrashes() {
    ///This way of navigation utilize screenLoading automatic approach [Navigator 1]
    Navigator.pushNamed(context, CrashesPage.screenName);

    ///This way of navigation utilize screenLoading manual approach [Navigator 1]
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => const CrashesPage(),
    //     settings: const RouteSettings(name: CrashesPage.screenName),
    //   ),
    // );
  }

  void _navigateToApm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const InstabugCaptureScreenLoading(
          screenName: ApmPage.screenName,
          child: ApmPage(),
        ),
        settings: const RouteSettings(name: ApmPage.screenName),
      ),
    );
  }

  void _navigateToComplex() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ComplexPage(),
        settings: const RouteSettings(name: ComplexPage.screenName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Page(
      scaffoldKey: _scaffoldKey,
      title: widget.title,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          child: const Text(
            'Hello Instabug\'s awesome user! The purpose of this application is to show you the different options for customizing the SDK and how easy it is to integrate it to your existing app',
            textAlign: TextAlign.center,
          ),
        ),
        InstabugButton(
          onPressed: restartInstabug,
          text: 'Restart Instabug',
        ),
        const SectionTitle('Primary Color'),
        InstabugTextField(
          controller: primaryColorController,
          label: 'Enter primary color',
        ),
        InstabugButton(
          text: 'Change Primary Color',
          onPressed: changePrimaryColor,
        ),
        const SectionTitle('Change Invocation Event'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => setInvocationEvent(InvocationEvent.none),
              style: buttonStyle,
              child: const Text('None'),
            ),
            ElevatedButton(
              onPressed: () => setInvocationEvent(InvocationEvent.shake),
              style: buttonStyle,
              child: const Text('Shake'),
            ),
            ElevatedButton(
              onPressed: () => setInvocationEvent(InvocationEvent.screenshot),
              style: buttonStyle,
              child: const Text('Screenshot'),
            ),
          ],
        ),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () =>
                  setInvocationEvent(InvocationEvent.floatingButton),
              style: buttonStyle,
              child: const Text('Floating Button'),
            ),
            ElevatedButton(
              onPressed: () =>
                  setInvocationEvent(InvocationEvent.twoFingersSwipeLeft),
              style: buttonStyle,
              child: const Text('Two Fingers Swipe Left'),
            ),
          ],
        ),
        InstabugButton(
          onPressed: show,
          text: 'Invoke',
        ),
        InstabugButton(
          onPressed: setOnDismissCallback,
          text: 'Set On Dismiss Callback',
        ),
        const SectionTitle('Repro Steps'),
        InstabugTextField(
          controller: screenNameController,
          label: 'Enter screen name',
        ),
        InstabugButton(
          text: 'Report Screen Change',
          onPressed: reportScreenChange,
        ),
        InstabugButton(
          onPressed: sendBugReport,
          text: 'Send Bug Report',
        ),
        InstabugButton(
          onPressed: showManualSurvey,
          text: 'Show Manual Survey',
        ),
        const SectionTitle('Change Report Types'),
        ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.start,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => toggleReportType(ReportType.bug),
              style: buttonStyle,
              child: const Text('Bug'),
            ),
            ElevatedButton(
              onPressed: () => toggleReportType(ReportType.feedback),
              style: buttonStyle,
              child: const Text('Feedback'),
            ),
            ElevatedButton(
              onPressed: () => toggleReportType(ReportType.question),
              style: buttonStyle,
              child: const Text('Question'),
            ),
          ],
        ),
        InstabugButton(
          onPressed: changeFloatingButtonEdge,
          text: 'Move Floating Button to Left',
        ),
        InstabugButton(
          onPressed: sendFeedback,
          text: 'Send Feedback',
        ),
        InstabugButton(
          onPressed: showNpsSurvey,
          text: 'Show NPS Survey',
        ),
        InstabugButton(
          onPressed: showManualSurvey,
          text: 'Show Multiple Questions Survey',
        ),
        InstabugButton(
          onPressed: showFeatureRequests,
          text: 'Show Feature Requests',
        ),
        InstabugButton(
          onPressed: _navigateToCrashes,
          text: 'Crashes',
        ),
        InstabugButton(
          onPressed: _navigateToApm,
          text: 'APM',
        ),
        InstabugButton(
          onPressed: _navigateToComplex,
          text: 'Complex',
        ),
        const SectionTitle('Smart Error Analyzer'),
        InstabugButton(
          onPressed: _testSmartErrorAnalyzer,
          text: 'Test Smart Error Analyzer',
        ),
        InstabugButton(
          onPressed: () {
            PerformanceAlertSystem.startAllMonitoring(
              onAlert: (type, message) {
                if (!_alertShown) {
                  _alertShown = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      backgroundColor:
                          type == 'critical' ? Colors.red : Colors.orange,
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
            );
          },
          text: 'Start Performance Monitoring',
        ),
        const SectionTitle('Sessions Replay'),
        InstabugButton(
          onPressed: getCurrentSessionReplaylink,
          text: 'Get current session replay link',
        ),
        const SectionTitle('Color Theme'),
        ButtonBar(
          mainAxisSize: MainAxisSize.max,
          alignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () => setColorTheme(ColorTheme.light),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.white),
                foregroundColor: MaterialStateProperty.all(Colors.lightBlue),
              ),
              child: const Text('Light'),
            ),
            ElevatedButton(
              onPressed: () => setColorTheme(ColorTheme.dark),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black),
                foregroundColor: MaterialStateProperty.all(Colors.white),
              ),
              child: const Text('Dark'),
            ),
          ],
        ),
        SectionTitle('FeatureFlags'),
        InstabugTextField(
          controller: featureFlagsController,
          label: 'Feature Flag name',
        ),
        InstabugButton(
          onPressed: () => setFeatureFlag(),
          text: 'SetFeatureFlag',
        ),
        InstabugButton(
          onPressed: () => removeFeatureFlag(),
          text: 'RemoveFeatureFlag',
        ),
        InstabugButton(
          onPressed: () => removeAllFeatureFlags(),
          text: 'RemoveAllFeatureFlags',
        ),
      ],
    );
  }

  setFeatureFlag() {
    Instabug.addFeatureFlags([FeatureFlag(name: featureFlagsController.text)]);
  }

  removeFeatureFlag() {
    Instabug.removeFeatureFlags([featureFlagsController.text]);
  }

  removeAllFeatureFlags() {
    Instabug.clearAllFeatureFlags();
  }

  void _testSmartErrorAnalyzer() async {
    try {
      // Simulate different types of errors
      final errors = [
        Exception('Network connection timeout'),
        Exception('Database query failed: table not found'),
        Exception('Widget build failed: overflow error'),
        Exception('Memory allocation failed: out of memory'),
        Exception('Authentication failed: invalid token'),
        Exception('Unknown error occurred'),
      ];

      for (final error in errors) {
        // Analyze the error
        final analysis = await SmartErrorAnalyzer.analyzeError(error);

        // Show analysis results
        _showAnalysisResults(error.toString(), analysis);

        // Wait a bit before next error
        await Future.delayed(const Duration(seconds: 2));
      }
    } catch (e) {
      _showError('Error testing Smart Error Analyzer: $e');
    }
  }

  void _showAnalysisResults(String errorMessage, ErrorAnalysis analysis) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('🔍 Smart Error Analysis'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Error: $errorMessage',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                _buildAnalysisRow('Category', analysis.category.name),
                _buildAnalysisRow('Severity', analysis.severity.name),
                _buildAnalysisRow(
                    'Fix Time', '${analysis.estimatedFixTime} minutes'),
                const SizedBox(height: 8),
                const Text(
                  'Suggested Solutions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                ...analysis.suggestedSolutions.map(
                  (solution) => Padding(
                    padding: const EdgeInsets.only(left: 8, top: 2),
                    child: Text('• $solution'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _reportErrorWithAnalysis(errorMessage);
              },
              child: const Text('Report to Instabug'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAnalysisRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  void _reportErrorWithAnalysis(String errorMessage) async {
    try {
      final error = Exception(errorMessage);
      await CrashReporting.reportErrorWithAnalysis(error);
      _showSuccess('Error reported to Instabug with analysis!');
    } catch (e) {
      _showError('Failed to report error: $e');
    }
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
