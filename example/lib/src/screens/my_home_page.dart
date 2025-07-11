part of '../../main.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final buttonStyle = ButtonStyle(
    backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
    foregroundColor: MaterialStateProperty.all(Colors.white),
  );

  List<ReportType> reportTypes = [];

  final primaryColorController = TextEditingController();
  final screenNameController = TextEditingController();
  final featureFlagsController = TextEditingController();
  final userAttributeKeyController = TextEditingController();

  final userAttributeValueController = TextEditingController();

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

  void _navigateToBugs() {
    ///This way of navigation utilize screenLoading automatic approach [Navigator 1]
    Navigator.pushNamed(context, BugReportingPage.screenName);
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

  void _navigateToSessionReplay() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SessionReplayPage(),
        settings: const RouteSettings(name: SessionReplayPage.screenName),
      ),
    );
  }

  final _formUserAttributeKey = GlobalKey<FormState>();

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
        InstabugButton(
          onPressed: _navigateToBugs,
          text: 'Bug Reporting',
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
        InstabugButton(
          onPressed: _navigateToSessionReplay,
          text: 'Session Replay',

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
        const SectionTitle('FeatureFlags'),
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

        const SectionTitle('Set User Attribute'),

        Form(
          key: _formUserAttributeKey,
          child: Column(
            children: [
              Row(
                children: <Widget>[
                  Expanded(
                      child: InstabugTextField(
                    label: "User Attribute key",
                    key: const Key("user_attribute_key_textfield"),
                    controller: userAttributeKeyController,
                    validator: (value) {
                      if (value?.trim().isNotEmpty == true) return null;
                      return 'this field is required';
                    },
                  )),
                  Expanded(
                      child: InstabugTextField(
                    label: "User Attribute  Value",
                    key: const Key("user_attribute_value_textfield"),
                    controller: userAttributeValueController,
                    validator: (value) {
                      if (value?.trim().isNotEmpty == true) return null;

                      return 'this field is required';
                    },
                  )),
                ],
              ),
              const SizedBox(height: 8,),
              InstabugButton(
                text: 'Set User attribute',
                key: const Key('set_user_data_btn'),
                onPressed: () {
                  if (_formUserAttributeKey.currentState?.validate() == true) {
                    Instabug.setUserAttribute(userAttributeKeyController.text,
                        userAttributeValueController.text);
                  }
                },
              ),
              InstabugButton(
                text: 'remove User attribute',
                key: const Key('remove_user_data_btn'),
                onPressed: () {
                  if (_formUserAttributeKey.currentState?.validate() == true) {
                    Instabug.removeUserAttribute(userAttributeKeyController.text);
                  }
                },
              ),
              const SizedBox(height: 10,),
              const SectionTitle('Log'),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InstabugButton(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        key: const ValueKey('log_hello_debug_btn'),
                        onPressed: () {
                          InstabugLog.logDebug("hello Debug");
                        },
                        text: 'Log Hello Debug',
                      ),
                    ),
                    Expanded(
                      child: InstabugButton(
                        margin: const EdgeInsets.symmetric(horizontal: 2),

                        key: const ValueKey('log_hello_error_btn'),
                        onPressed: () {
                          InstabugLog.logError("hello Error");
                        },
                        text: 'Log Hello Error',
                      ),
                    ),
                    Expanded(
                      child: InstabugButton(
                        margin: const EdgeInsets.symmetric(horizontal: 2),

                        key: const ValueKey('hello_warning_btn'),
                        onPressed: () {
                          InstabugLog.logWarn("hello Warning");
                        },
                        text: 'Log Hello Warn',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InstabugButton(
                        margin: const EdgeInsets.symmetric(horizontal: 2),

                        key: const ValueKey('log_hello_info_btn'),
                        onPressed: () {
                          InstabugLog.logInfo("hello Info");
                        },
                        text: 'Log Hello Info',
                      ),
                    ),
                    Expanded(
                      child: InstabugButton(
                        margin: const EdgeInsets.symmetric(horizontal: 2),

                        key: const ValueKey('log_hello_verbose_btn'),
                        onPressed: () {
                          InstabugLog.logVerbose("hello Verbose");
                        },
                        text: 'Log Hello Verbose',
                      ),
                    ),

                    Expanded(
                      child: InstabugButton(
                        margin: const EdgeInsets.symmetric(horizontal: 2),

                        key: const ValueKey('clear_logs_btn'),
                        onPressed: () {
                          InstabugLog.clearAllLogs();
                        },
                        text: 'Clear All logs',
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
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
}
