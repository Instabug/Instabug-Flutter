import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_private_views/instabug_private_view.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      Instabug.init(
        token: 'ed6f659591566da19b67857e1b9d40ab',
        invocationEvents: [InvocationEvent.floatingButton],
        debugLogsLevel: LogLevel.verbose,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      enableInstabugMaskingPrivateViews();
      runApp(const MyApp());
    },
    CrashReporting.reportCrash,
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter View'),
    );
  }

  const MyApp({Key? key}) : super(key: key);
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            InstabugPrivateView(
              child: const Text(
                'Private text',
              ),
            ),
          ],
        ),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
