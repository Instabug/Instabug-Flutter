import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

import 'src/native/instabug_flutter_example_method_channel.dart';
import 'src/widget/instabug_button.dart';
import 'src/widget/instabug_clipboard_input.dart';
import 'src/widget/instabug_text_field.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      Instabug.init(
        token: 'ed6f659591566da19b67857e1b9d40ab',
        invocationEvents: [InvocationEvent.floatingButton],
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
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

  List<ReportType> reportTypes = [];

  final primaryColorController = TextEditingController();
  final screenNameController = TextEditingController();

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
      appBar: AppBar(title: Text(widget.title)),
      body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
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
              SectionTitle("Crashes"),
              const CrashReportingContent(),
              SectionTitle("APM"),
              const ApmBody(),
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

class CrashReportingContent extends StatelessWidget {
  const CrashReportingContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle('Non-Fatal Crashes'),
        const NonFatalCrashesContent(),
        SectionTitle('Fatal Crashes'),
        const Text('Fatal Crashes can only be tested in release mode'),
        const Text('Most of these buttons will crash the application'),
        const FatalCrashesContent(),
      ],
    );
  }
}

class NonFatalCrashesContent extends StatelessWidget {
  const NonFatalCrashesContent({Key? key}) : super(key: key);


  void throwHandledException(dynamic error) {
    try {
      if (error is! Error) {
        // Convert non-Error types to Error
        const String appName = 'Flutter Test App';
        final errorMessage = error?.toString() ?? 'Unknown Error';
        error = Exception('Handled Error: $errorMessage from $appName');
      }
      throw error;
    } catch (err) {
      if (err is Error) {
        // Simulate crash reporting by printing the error to the console
        log('throwHandledException: Crash report for ${err.runtimeType} is Sent!', name: 'NonFatalCrashesWidget');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstabugButton(
          text: 'Throw Exception',
          onPressed: () =>
              throwHandledException(Exception('This is a generic exception.')),
        ),
        InstabugButton(
          text: 'Throw StateError',
          onPressed: () =>
              throwHandledException(StateError('This is a StateError.')),
        ),
        InstabugButton(
          text: 'Throw ArgumentError',
          onPressed: () =>
              throwHandledException(ArgumentError('This is an ArgumentError.')),
        ),
        InstabugButton(
          text: 'Throw RangeError',
          onPressed: () =>
              throwHandledException(
                  RangeError.range(5, 0, 3, 'Index out of range')),
        ),
        InstabugButton(
          text: 'Throw FormatException',
          onPressed: () =>
              throwHandledException(UnsupportedError('Invalid format.')),
        ),
        InstabugButton(
          text: 'Throw NoSuchMethodError',
          onPressed: () {
            // This intentionally triggers a NoSuchMethodError
            dynamic obj;
            throwHandledException(obj.methodThatDoesNotExist());
          },
        ),
        InstabugButton(
          text: 'Throw Handled Native Exception',
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeNonFatalCrash,
        ),
      ],
    );
  }
}

class FatalCrashesContent extends StatelessWidget {

  const FatalCrashesContent({Key? key}) : super(key: key);


  void throwUnhandledException(dynamic error) {
    if (error is! Error) {
      // Convert non-Error types to Error
      const String appName = 'Flutter Test App';
      final errorMessage = error?.toString() ?? 'Unknown Error';
      error = Exception('Unhandled Error: $errorMessage from $appName');
    }
    throw error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InstabugButton(
          text: 'Throw Exception',
          onPressed: () =>
              throwUnhandledException(
                  Exception('This is a generic exception.')),
        ),
        InstabugButton(
          text: 'Throw StateError',
          onPressed: () =>
              throwUnhandledException(StateError('This is a StateError.')),
        ),
        InstabugButton(
          text: 'Throw ArgumentError',
          onPressed: () =>
              throwUnhandledException(
                  ArgumentError('This is an ArgumentError.')),
        ),
        InstabugButton(
          text: 'Throw RangeError',
          onPressed: () =>
              throwUnhandledException(
                  RangeError.range(5, 0, 3, 'Index out of range')),
        ),
        InstabugButton(
          text: 'Throw FormatException',
          onPressed: () =>
              throwUnhandledException(UnsupportedError('Invalid format.')),
        ),
        InstabugButton(
          text: 'Throw NoSuchMethodError',
          onPressed: () {
            // This intentionally triggers a NoSuchMethodError
            dynamic obj;
            throwUnhandledException(obj.methodThatDoesNotExist());
          },
        ),
        const InstabugButton(
          text: 'Throw Native Fatal Crash',
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeFatalCrash,
        ),
        const InstabugButton(
          text: 'Send Native Fatal Hang',
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeFatalHang,
        ),
        Platform.isAndroid
            ? const InstabugButton(
          text: 'Send Native ANR',
          onPressed: InstabugFlutterExampleMethodChannel.sendAnr,
        )
            : const SizedBox.shrink(),
        const InstabugButton(
          text: 'Throw Unhandled Native OOM Exception',
          onPressed: InstabugFlutterExampleMethodChannel.sendOom,
        ),
      ],
    );
  }
}

class ApmBody extends StatelessWidget {

  const ApmBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SectionTitle('Network'),
        const NetworkContent(),
      ],
    );
  }
}

class NetworkContent extends StatefulWidget {

  const NetworkContent({Key? key}) : super(key: key);
  final String defaultRequestUrl = 'https://jsonplaceholder.typicode.com/posts/1';

  @override
  State<NetworkContent> createState() => _NetworkContentState();
}

class _NetworkContentState extends State<NetworkContent> {

  final endpointUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstabugClipboardInput(
          label: 'Endpoint Url',
          controller: endpointUrlController,
        ),
        InstabugButton(
          text: 'Send Request To Url',
          onPressed: () => _sendRequestToUrl(endpointUrlController.text),
        ),
      ],
    );
  }

  void _sendRequestToUrl(String text) async {
    try {
      String url = text.trim().isEmpty ? widget.defaultRequestUrl : text;
      final response = await http.get(Uri.parse(url));

      // Handle the response here
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        log(jsonEncode(jsonData));
      } else {
        log('Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      log('Error sending request: $e');
    }
  }
}


