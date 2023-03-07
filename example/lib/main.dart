import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../providers/bug_reporting_state.dart';
import '../providers/core_state.dart';
import '../providers/settings_state.dart';
import '../providers/theme_state.dart';
import '../screens/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Instabug.init(
    token: '0174a800719ebdebf7b248fa6ae2ef17',
    invocationEvents: [InvocationEvent.floatingButton],
    debugLogsLevel: LogLevel.verbose,
  );

  Instabug.setWelcomeMessageMode(WelcomeMessageMode.disabled);

  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack!);
  };

  runZonedGuarded(() => runApp(const MyApp()), CrashReporting.reportCrash);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<BugReportingState>(
          create: (ctx) => BugReportingState(),
        ),
        ChangeNotifierProvider(
          create: (_) => CoreState(),
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsState(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeState(),
        ),
      ],
      child: Consumer<ThemeState>(
        builder: (context, themeState, child) {
          return MaterialApp(
            title: 'Instabug Flutter Example',
            theme: themeState.getThemeData(),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
