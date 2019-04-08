import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'package:instabug_flutter/BugReporting.dart';
import 'package:instabug_flutter/InstabugLog.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      if (Platform.isIOS) {
        Instabug.start('9582e6cfe34e2b8897f48cfa3b617adb', <InvocationEvent>[InvocationEvent.floatingButton, InvocationEvent.shake]);
      }
      Instabug.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
      Instabug.setWelcomeMessageMode(WelcomeMessageMode.beta);
      Instabug.identifyUserWithEmail('aezz@instabug.com', 'Aly Ezz');
      InstabugLog.logInfo('Test Log Info Message from Flutter!');
      InstabugLog.logDebug('Test Debug Message from Flutter!');
      InstabugLog.logVerbose('Test Verbose Message from Flutter!');
      InstabugLog.clearAllLogs();
      InstabugLog.logError('Test Error Message from Flutter!');
      InstabugLog.logWarn('Test Warn Message from Flutter!');
      Instabug.logOut();
      Instabug.setLocale(Locale.German);
      Instabug.setColorTheme(ColorTheme.dark);
      Instabug.appendTags(<String>['tag1', 'tag2']);
      Instabug.setUserAttributeWithKey('19', 'Age');
      Instabug.setUserAttributeWithKey('female', 'gender');
      Instabug.removeUserAttributeForKey('gender');
      final String value = await Instabug.getUserAttributeForKey('Age');
      print('User Attribute ' + value);
      final Map<String, String> userAttributes = await Instabug.getUserAttributes();
      print(userAttributes.toString()); 
      Instabug.logUserEventWithName('Aly Event');
      Instabug.setValueForStringWithKey('What\'s the problem', IBGCustomTextPlaceHolderKey.REPORT_BUG);
      Instabug.setValueForStringWithKey('Send some ideas', IBGCustomTextPlaceHolderKey.REPORT_FEEDBACK);
      Instabug.setSessionProfilerEnabled(false);
      Color c = const Color.fromRGBO(255, 0, 255, 1.0);
      Instabug.setPrimaryColor(c);
      Instabug.setUserData("This is some useful data");
      var list = Uint8List(10);
      Instabug.addFileAttachmentWithData(list, "My File");
      Instabug.clearFileAttachments();
      //Instabug.clearFileAttachments();
      //BugReporting.setEnabled(false);
      BugReporting.setOnInvokeCallback(sdkInvoked);
      BugReporting.setOnDismissCallback(sdkDismissed);
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  void resetTags() {
    Instabug.resetTags();
  }

  void sdkInvoked() {
    debugPrint("I am called before invocation");
  }

  void sdkDismissed(DissmissType dismissType, ReportType reportType) {
    debugPrint('SDK Dismissed DismissType: ' + dismissType.toString());
     debugPrint('SDK Dismissed ReportType: ' + reportType.toString());
  }

  void show() {
    Instabug.show();
  }

  void invokeWithMode() {
    BugReporting.invokeWithMode(InvocationMode.BUG, [InvocationOption.EMAIL_FIELD_HIDDEN]);
  }

  void getTags() async {
    final List<String> tags = await Instabug.getTags();
    print(tags.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Running on: $_platformVersion\n'),
            RaisedButton(
                onPressed: show,
                child: Text('show'),
                color: Colors.lightBlue),
            RaisedButton(
                onPressed: invokeWithMode,
                child: Text('invokeWithMode'),
                color: Colors.lightBlue),
            RaisedButton(
                onPressed: resetTags,
                child: Text('reset tags'),
                color: Colors.lightBlue),
            RaisedButton(
                onPressed: getTags,
                child: Text('get tags'),
                color: Colors.lightBlue)
          ],
        )),
      ),
    );
  }
}
