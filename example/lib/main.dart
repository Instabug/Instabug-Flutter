import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io' show Platform;
import 'package:flutter/services.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

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
        InstabugFlutter.start('9582e6cfe34e2b8897f48cfa3b617adb', [InvocationEvent.floatingButton, InvocationEvent.shake]);
      }
      InstabugFlutter.showWelcomeMessageWithMode(WelcomeMessageMode.beta);
      InstabugFlutter.identifyUserWithEmail("aezz@instabug.com", "Aly Ezz");
      InstabugFlutter.logInfo("Test Log Info Message");
      InstabugFlutter.logOut();
      InstabugFlutter.setLocale(Locale.German);

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
