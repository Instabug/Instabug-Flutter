import 'package:flutter/material.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'dart:async';
// import 'dart:io' show Platform;
import 'package:instabug_flutter/BugReporting.dart';
import 'package:instabug_flutter/Surveys.dart';
import 'package:instabug_flutter/FeatureRequests.dart';
import 'package:instabug_flutter/CrashReporting.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };

  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (dynamic error, StackTrace stackTrace) {
    CrashReporting.reportCrash(error, stackTrace);
  });

  Instabug.start(
      'efa41f402620b5654f2af2b86e387029', [InvocationEvent.floatingButton]);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
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
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
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
          padding: EdgeInsets.only(top: 20.0),
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
                      onPressed: () => setInvocationEvent(InvocationEvent.none),
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
          )), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
