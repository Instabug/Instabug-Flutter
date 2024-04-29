import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      Instabug.init(
        token: 'ed6f659591566da19b67857e1b9d40ab',
        invocationEvents: [InvocationEvent.floatingButton],
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(
            details.exception, details.stack ?? StackTrace.current);
      };

      runApp(MyApp());
    },
    CrashReporting.reportCrash,
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        InstabugNavigatorObserver(),
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class InstabugButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  InstabugButton({required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
          foregroundColor: MaterialStateProperty.all(Colors.white),
        ),
        child: Text(text),
      ),
    );
  }
}

class InstabugTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;

  InstabugTextField(
      {required this.label, required this.controller, this.validator});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: TextFormField(
        controller: controller,
        validator: validator,
        decoration: InputDecoration(labelText: label, helperText: ''),
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String text;

  SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      margin: const EdgeInsets.only(top: 20.0, left: 20.0),
      child: Text(
        text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

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

  var crashFormKey = GlobalKey<FormState>();
  final crashNameController = TextEditingController();
  final crashfingerPrintController = TextEditingController();
  final crashUserAttributeKeyController = TextEditingController();

  final crashUserAttributeValueController = TextEditingController();

  NonFatalExceptionLevel crashType = NonFatalExceptionLevel.error;

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
            title: Text('On Dismiss'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          padding: const EdgeInsets.only(top: 20.0, bottom: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(
                    left: 20.0, right: 20.0, bottom: 20.0),
                child: const Text(
                  'Hello Instabug\'s awesome user! The purpose of this application is to show you the different options for customizing the SDK and how easy it is to integrate it to your existing app',
                  textAlign: TextAlign.center,
                ),
              ),
              InstabugButton(
                onPressed: restartInstabug,
                text: 'Restart Instabug',
              ),
              SectionTitle('Primary Color'),
              InstabugTextField(
                controller: primaryColorController,
                label: 'Enter primary color',
              ),
              InstabugButton(
                text: 'Change Primary Color',
                onPressed: changePrimaryColor,
              ),
              SectionTitle('Change Invocation Event'),
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
                    onPressed: () =>
                        setInvocationEvent(InvocationEvent.screenshot),
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
              SectionTitle('Repro Steps'),
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
              SectionTitle('Change Report Types'),
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
              SectionTitle('Color Theme'),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => setColorTheme(ColorTheme.light),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      foregroundColor:
                          MaterialStateProperty.all(Colors.lightBlue),
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
              SectionTitle('Sessions Replay'),
              InstabugButton(
                onPressed: getCurrentSessionReplaylink,
                text: 'Get current session replay link',
              ),
              SectionTitle('Crash section'),
              Form(
                key: crashFormKey,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: InstabugTextField(
                          label: "Crash title",
                          controller: crashNameController,
                          validator: (value) {
                            if (value?.trim().isNotEmpty == true) return null;

                            return 'this field is required';
                          },
                        )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: InstabugTextField(
                          label: "User Attribute  key",
                          controller: crashUserAttributeKeyController,
                          validator: (value) {
                            if (crashUserAttributeValueController
                                .text.isNotEmpty) {
                              if (value?.trim().isNotEmpty == true) return null;

                              return 'this field is required';
                            }
                            return null;
                          },
                        )),
                        Expanded(
                            child: InstabugTextField(
                          label: "User Attribute  Value",
                          controller: crashUserAttributeValueController,
                          validator: (value) {
                            if (crashUserAttributeKeyController
                                .text.isNotEmpty) {
                              if (value?.trim().isNotEmpty == true) return null;

                              return 'this field is required';
                            }
                            return null;
                          },
                        )),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: InstabugTextField(
                          label: "Fingerprint",
                          controller: crashfingerPrintController,
                        )),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              flex: 5,
                              child: DropdownButtonHideUnderline(
                                child: DropdownButtonFormField<
                                    NonFatalExceptionLevel>(
                                  value: crashType,
                                  decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      isDense: true),
                                  padding: EdgeInsets.zero,
                                  items: NonFatalExceptionLevel.values
                                      .map((e) => DropdownMenuItem(
                                            value: e,
                                            child: Text(e.toString()),
                                          ))
                                      .toList(),
                                  onChanged: (NonFatalExceptionLevel? value) {
                                    crashType = value!;
                                  },
                                ),
                              )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InstabugButton(
                      text: 'Send Non Fatal Crash',
                      onPressed: sendNonFatalCrash,
                    )
                  ],
                ),
              ),
            ],
          )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void sendNonFatalCrash() {
    if (crashFormKey.currentState?.validate() == true) {
      Map<String, String>? userAttributes = null;
      if (crashUserAttributeKeyController.text.isNotEmpty) {
        userAttributes = {
          crashUserAttributeKeyController.text:
              crashUserAttributeValueController.text
        };
      }
      CrashReporting.reportHandledCrash(
          new Exception(crashNameController.text), null,
          userAttributes: userAttributes,
          fingerprint: crashfingerPrintController.text,
          level: crashType);
      ScaffoldMessenger.of(_scaffoldKey.currentContext!)
          .showSnackBar(SnackBar(content: Text("Crash sent")));
      crashNameController.text = '';
      crashfingerPrintController.text = '';
      crashUserAttributeValueController.text = '';
      crashUserAttributeKeyController.text = '';
    }
  }
}
