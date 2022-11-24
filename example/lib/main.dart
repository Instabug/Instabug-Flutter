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
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        InstabugNavigatorObserver(),
      ],
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
    final buttonStyle = ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.lightBlue),
      foregroundColor: MaterialStateProperty.all(Colors.white),
    );

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
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
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: show,
                  style: buttonStyle,
                  child: const Text('Invoke'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: sendBugReport,
                  style: buttonStyle,
                  child: const Text('Send Bug Report'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: sendFeedback,
                  style: buttonStyle,
                  child: const Text('Send Feedback'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: askQuestion,
                  style: buttonStyle,
                  child: const Text('Ask a Question'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: showNpsSurvey,
                  style: buttonStyle,
                  child: const Text('Show NPS Survey'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: showMultipleQuestionSurvey,
                  style: buttonStyle,
                  child: const Text('Show Multiple Questions Survey'),
                ),
              ),
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                // height: double.infinity,
                child: ElevatedButton(
                  onPressed: showFeatureRequests,
                  style: buttonStyle,
                  child: const Text('Show Feature Requests'),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 20.0, left: 20.0),
                child: const Text(
                  'Change Invocation Event',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
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
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20.0),
                child: const Text(
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
              Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(left: 20.0),
                child: const Text(
                  'Color Theme',
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
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
