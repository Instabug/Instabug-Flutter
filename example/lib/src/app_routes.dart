import 'package:flutter/widgets.dart' show BuildContext;
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_example/main.dart';

final appRoutes = {
  /// ["/"] route name should only be used with [onGenerateRoute:] when no
  /// Home Widget specified in MaterialApp() other wise the the Flutter engine
  /// will throw a Runtime exception deo to Flutter restrictions

  "/": (BuildContext context) =>
      const MyHomePage(title: 'Flutter Demo Home Pag'),
  CrashesPage.screenName: (BuildContext context) => const CrashesPage(),
  BugReportingPage.screenName: (BuildContext context) =>
      const BugReportingPage(),
  ComplexPage.screenName: (BuildContext context) => const ComplexPage(),
  SessionReplayPage.screenName: (BuildContext context) =>
      const SessionReplayPage(),
  TopTabBarScreen.route: (BuildContext context) => const TopTabBarScreen(),

  ApmPage.screenName: (BuildContext context) => const ApmPage(),
  ScreenLoadingPage.screenName: (BuildContext context) =>
      const ScreenLoadingPage(),
  ScreenCapturePrematureExtensionPage.screenName: (BuildContext context) =>
      const ScreenCapturePrematureExtensionPage(),
};
