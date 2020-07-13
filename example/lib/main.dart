import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/material.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'package:instabug_flutter/BugReporting.dart';
import 'package:instabug_flutter/Surveys.dart';
import 'package:instabug_flutter/FeatureRequests.dart';
import 'package:instabug_flutter/CrashReporting.dart';

void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (dynamic error, StackTrace stackTrace) {
    CrashReporting.reportCrash(error, stackTrace);
  });
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    if (Platform.isIOS) {
      Instabug.start('efa41f402620b5654f2af2b86e387029',
          <InvocationEvent>[InvocationEvent.floatingButton]);
    }
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

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
    return MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
            padding: EdgeInsets.only(top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(
                      left: 20.0, right: 20.0, bottom: 20.0),
                  child: Text(
                    'Hello Instabug\'s awesome user! The purpose of this application is to show you the different options for customizing the SDK and how easy it is to integrate it to your existing app',
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: show,
                      textColor: Colors.white,
                      child: Text('Invoke'),
                      color: Colors.lightBlue),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: sendBugReport,
                      textColor: Colors.white,
                      child: Text('Send Bug Report'),
                      color: Colors.lightBlue),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: sendFeedback,
                      textColor: Colors.white,
                      child: Text('Send Feedback'),
                      color: Colors.lightBlue),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: askQuestion,
                      textColor: Colors.white,
                      child: Text('Ask a Question'),
                      color: Colors.lightBlue),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: showNpsSurvey,
                      textColor: Colors.white,
                      child: Text('Show NPS Survey'),
                      color: Colors.lightBlue),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: showMultipleQuestionSurvey,
                      textColor: Colors.white,
                      child: Text('Show Multiple Questions Survey'),
                      color: Colors.lightBlue),
                ),
                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                  // height: double.infinity,
                  child: RaisedButton(
                      onPressed: showFeatureRequests,
                      textColor: Colors.white,
                      child: Text('Show Feature Requests'),
                      color: Colors.lightBlue),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                  child: Text(
                    'Change Invocation Event',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () =>
                            setInvocationEvent(InvocationEvent.none),
                        textColor: Colors.white,
                        child: Text('none'),
                        color: Colors.lightBlue),
                    RaisedButton(
                        onPressed: () =>
                            setInvocationEvent(InvocationEvent.shake),
                        textColor: Colors.white,
                        child: Text('Shake'),
                        color: Colors.lightBlue),
                    RaisedButton(
                        onPressed: () =>
                            setInvocationEvent(InvocationEvent.screenshot),
                        textColor: Colors.white,
                        child: Text('Screenshot'),
                        color: Colors.lightBlue),
                  ],
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  alignment: MainAxisAlignment.start,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () =>
                            setInvocationEvent(InvocationEvent.floatingButton),
                        textColor: Colors.white,
                        child: Text('Floating Button'),
                        color: Colors.lightBlue),
                    RaisedButton(
                        onPressed: () => setInvocationEvent(
                            InvocationEvent.twoFingersSwipeLeft),
                        textColor: Colors.white,
                        child: Text('Two Fingers Swipe Left'),
                        color: Colors.lightBlue),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Set Primary Color',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 30.0,
                      child: RaisedButton(
                          onPressed: () => setPrimaryColor(Colors.red),
                          textColor: Colors.white,
                          color: Colors.red),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 30.0,
                      child: RaisedButton(
                          onPressed: () => setPrimaryColor(Colors.green),
                          textColor: Colors.white,
                          color: Colors.green),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 30.0,
                      child: RaisedButton(
                          onPressed: () => setPrimaryColor(Colors.blue),
                          textColor: Colors.white,
                          color: Colors.blue),
                    ),
                    ButtonTheme(
                      minWidth: 50.0,
                      height: 30.0,
                      child: RaisedButton(
                          onPressed: () => setPrimaryColor(Colors.yellow),
                          textColor: Colors.white,
                          color: Colors.yellow),
                    ),
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  margin: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    'Color Theme',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                ButtonBar(
                  mainAxisSize: MainAxisSize.max,
                  alignment: MainAxisAlignment.center,
                  children: <Widget>[
                    RaisedButton(
                        onPressed: () => setColorTheme(ColorTheme.light),
                        textColor: Colors.lightBlue,
                        child: Text('Light'),
                        color: Colors.white),
                    RaisedButton(
                        onPressed: () => setColorTheme(ColorTheme.dark),
                        textColor: Colors.white,
                        child: Text('Dark'),
                        color: Colors.black),
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
