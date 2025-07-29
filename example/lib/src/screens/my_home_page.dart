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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.psychology,
                      color: Color(0xFF667EEA),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Suggested new features',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2D3748),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _testSmartErrorAnalyzer,
                  icon: const Icon(Icons.analytics, size: 18),
                  label: const Text('Smart Error Analyzer'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF667EEA),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),

        ElevatedButton.icon(
          onPressed: () {
            PerformanceAlertSystem.startAllMonitoring(
              onAlert: (type, message) {
                if (!_alertShown) {
                  _alertShown = true;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          Icon(
                            type == 'critical' ? Icons.warning : Icons.info_outline,
                            color: Colors.white,
                            size: 20,
                          ),
                          const SizedBox(width: 12),
                          Expanded(child: Text(message)),
                        ],
                      ),
                      backgroundColor: type == 'critical'
                          ? const Color(0xFFE53E3E)
                          : const Color(0xFFED8936),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      duration: const Duration(seconds: 4),
                    ),
                  );
                }
              },
            );
          },
          icon: const Icon(Icons.speed),
          label: const Text('Monitor Performance'),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF3182CE),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 2,
          ),
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
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Color(0xFF667EEA),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.psychology, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Smart Analysis',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close, color: Colors.white),
                        iconSize: 20,
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Error message
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFED7D7),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFFEB2B2)),
                          ),
                          child: Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Color(0xFF742A2A),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Analysis details
                        _buildModernAnalysisCard('Category', analysis.category.name,
                            Icons.category, const Color(0xFF38B2AC)),
                        const SizedBox(height: 12),
                        _buildModernAnalysisCard('Severity', analysis.severity.name,
                            Icons.priority_high, const Color(0xFFED8936)),
                        const SizedBox(height: 12),
                        _buildModernAnalysisCard('Est. Fix Time', '${analysis.estimatedFixTime} min',
                            Icons.schedule, const Color(0xFF805AD5)),

                        const SizedBox(height: 20),

                        // Solutions
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFFE2E8F0)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.lightbulb,
                                      color: Color(0xFFD69E2E), size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Suggested Solutions',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF2D3748),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ...analysis.suggestedSolutions.map(
                                    (solution) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(top: 6),
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF667EEA),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          solution,
                                          style: const TextStyle(
                                            color: Color(0xFF4A5568),
                                            height: 1.4,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Actions
                Container(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            side: const BorderSide(color: Color(0xFFE2E8F0)),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.of(context).pop();
                            _reportErrorWithAnalysis(errorMessage);
                          },
                          icon: const Icon(Icons.bug_report, size: 18),
                          label: const Text('Report'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF667EEA),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernAnalysisCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xFF4A5568),
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
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
