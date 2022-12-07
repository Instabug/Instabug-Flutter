import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZonedGuarded(() => runApp(MyApp()), CrashReporting.reportCrash);

  Instabug.start(
      'ed6f659591566da19b67857e1b9d40ab', [InvocationEvent.floatingButton]);
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
  String text;
  void Function()? onPressed;

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

class SectionTitle extends StatelessWidget {
  String text;

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

  void show() {
    Instabug.show();
  }

  void sendBugReport() {
    BugReporting.show(ReportType.bug, [InvocationOption.emailFieldOptional]);
  }

  void sendFeedback() {
    BugReporting.show(
        ReportType.feedback, [InvocationOption.emailFieldOptional]);
  }

  void askQuestion() {
    BugReporting.show(
        ReportType.question, [InvocationOption.emailFieldOptional]);
  }

  void showNpsSurvey() {
    Surveys.showSurvey('pcV_mE2ttqHxT1iqvBxL0w');
  }

  void showMultipleQuestionSurvey() {
    Surveys.showSurvey('ZAKSlVz98QdPyOx1wIt8BA');
  }

  void showFeatureRequests() {
    FeatureRequests.show();
  }

  void setInvocationEvent(InvocationEvent invocationEvent) {
    BugReporting.setInvocationEvents([invocationEvent]);
  }

  void setPrimaryColor(Color c) {
    Instabug.setPrimaryColor(c);
  }

  void setColorTheme(ColorTheme colorTheme) {
    Instabug.setColorTheme(colorTheme);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 20.0),
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
                onPressed: sendBugReport,
                text: 'Send Bug Report',
              ),
              InstabugButton(
                onPressed: sendFeedback,
                text: 'Send Feedback',
              ),
              InstabugButton(
                onPressed: askQuestion,
                text: 'Ask a Question',
              ),
              InstabugButton(
                onPressed: showNpsSurvey,
                text: 'Show NPS Survey',
              ),
              InstabugButton(
                onPressed: showMultipleQuestionSurvey,
                text: 'Show Multiple Questions Survey',
              ),
              InstabugButton(
                onPressed: showFeatureRequests,
                text: 'Show Feature Requests',
              ),
              SectionTitle('Change Invocation Event'),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.start,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => setInvocationEvent(InvocationEvent.none),
                    style: buttonStyle,
                    child: const Text('none'),
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
              SectionTitle('Set Primary Color'),
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                alignment: MainAxisAlignment.center,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 50.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () => setPrimaryColor(Colors.red),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: null,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 50.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () => setPrimaryColor(Colors.green),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.green),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: null,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 50.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () => setPrimaryColor(Colors.blue),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.blue),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: null,
                    ),
                  ),
                  ButtonTheme(
                    minWidth: 50.0,
                    height: 30.0,
                    child: ElevatedButton(
                      onPressed: () => setPrimaryColor(Colors.yellow),
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                        foregroundColor:
                            MaterialStateProperty.all(Colors.white),
                      ),
                      child: null,
                    ),
                  ),
                ],
              ),
              SectionTitle('Color Theme'),
              ButtonBar(
                mainAxisSize: MainAxisSize.max,
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
            ],
          )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
