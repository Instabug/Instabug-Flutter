import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_modular_demo_app/modules.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_modular/instabug_flutter_modular.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      Instabug.init(
        token: '6b41bc30dd42aac50794ef3ec8f74a74',
        invocationEvents: [InvocationEvent.floatingButton],
        debugLogsLevel: LogLevel.verbose,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };
      runApp(
        ModularApp(
          module: InstabugModule(AppModule()),
          child: const MyApp(),
        ),
      );
    },
    CrashReporting.reportCrash,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routeInformationParser: Modular.routeInformationParser,
      routerDelegate: Modular.routerDelegate
        ..setObservers([InstabugNavigatorObserver()]),
      title: 'Flutter Modular Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
