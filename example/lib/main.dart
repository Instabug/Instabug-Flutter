import 'dart:async';
import 'dart:io' show Platform;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/Instabug.dart';
import 'package:instabug_flutter/BugReporting.dart';
import 'package:instabug_flutter/InstabugLog.dart';
import 'package:instabug_flutter/Surveys.dart';
import 'package:instabug_flutter/FeatureRequests.dart';
import 'package:instabug_flutter/Chats.dart';
import 'package:instabug_flutter/Replies.dart';

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
        Instabug.start('068ba9a8c3615035e163dc5f829c73be', <InvocationEvent>[InvocationEvent.shake]);
      }
      //Instabug.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
      //Instabug.setWelcomeMessageMode(WelcomeMessageMode.beta);
      Instabug.identifyUser('aezz@instabug.com', 'Aly Ezz');
      InstabugLog.logInfo('Test Log Info Message from Flutter!');
      InstabugLog.logDebug('Test Debug Message from Flutter!');
      InstabugLog.logVerbose('Test Verbose Message from Flutter!');
      InstabugLog.clearAllLogs();
      InstabugLog.logError('Test Error Message from Flutter!');
      InstabugLog.logWarn('Test Warn Message from Flutter!');
      Instabug.logOut();
      //Instabug.setLocale(Locale.German);
      Instabug.setColorTheme(ColorTheme.dark);
      Instabug.appendTags(<String>['tag1', 'tag2']);
      Instabug.setUserAttribute('19', 'Age');
      Instabug.setUserAttribute('female', 'gender');
      Instabug.removeUserAttribute('gender');
      final String value = await Instabug.getUserAttributeForKey('Age');
      print('User Attribute ' + value);
      final Map<String, String> userAttributes = await Instabug.getUserAttributes();
      print(userAttributes.toString()); 
      Instabug.logUserEvent('Aly Event');
      Instabug.setValueForStringWithKey('What\'s the problem', IBGCustomTextPlaceHolderKey.reportBug);
      Instabug.setValueForStringWithKey('Send some ideas', IBGCustomTextPlaceHolderKey.reportFeedback);
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
      BugReporting.setInvocationEvents(<InvocationEvent>[InvocationEvent.floatingButton]);
      Surveys.setEnabled(true);
      Surveys.setAutoShowingEnabled(false);
      Surveys.setOnShowCallback(surveyShown);
      Surveys.setOnDismissCallback(surveyDismiss);
      //Replies.setInAppNotificationsEnabled(false);
      Replies.setEnabled(true);
      Replies.show();
      Replies.setOnNewReplyReceivedCallback(replies);
      //BugReporting.setEnabledAttachmentTypes(false, false, false, false);
      //BugReporting.setReportTypes(<ReportType>[ReportType.FEEDBACK,ReportType.BUG]);
      //BugReporting.setExtendedBugReportMode(ExtendedBugReportMode.ENABLED_WITH_REQUIRED_FIELDS);
      //BugReporting.setInvocationOptions(<InvocationOption>[InvocationOption.EMAIL_FIELD_HIDDEN]);
      
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

  void getSurveys(List<String> surveys) {
    int x = surveys.length;
    debugPrint(x.toString());
  }

  void sdkInvoked() {
    debugPrint("I am called before invocation");
  }

  void surveyShown() {
    debugPrint("The user will se a survey nwoww");
  }

  void surveyDismiss() {
    debugPrint("The survey is Dismissed");
  }

  void sdkDismissed(DismissType dismissType, ReportType reportType) {
    debugPrint('SDK Dismissed DismissType: ' + dismissType.toString());
     debugPrint('SDK Dismissed ReportType: ' + reportType.toString());
  }

   void hasResponded(bool hasResponded) {
    debugPrint(hasResponded.toString());
  }

  void replies() {
    debugPrint("new Replyyy");
  }
  void show() {
    //Instabug.show();
    // Surveys.getAvailableSurveys(getSurveys);
    // Surveys.showSurveyIfAvailable();
    // Surveys.setShouldShowWelcomeScreen(true);
    //Surveys.showSurvey("BHJI1iaKYhr4CYHHcUAaTg");
    //BugReporting.showWithOptions(ReportType.bug, <InvocationOption>[InvocationOption.emailFieldHidden]);
    // FeatureRequests.setEmailFieldRequired(false, [ActionType.allActions]);
    // FeatureRequests.show();
    // Replies.setEnabled(true);
    // Replies.show();
    //Replies.setInAppNotificationsEnabled(false);
    //Replies.getUnreadRepliesCount(replies);
  }

  void invokeWithMode() {
    Surveys.hasRespondedToSurvey("BHJI1iaKYhr4CYHHcUAaTg", hasResponded);
   // BugReporting.invokeWithMode(InvocationMode.bug, [InvocationOption.emailFieldHidden]);
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
