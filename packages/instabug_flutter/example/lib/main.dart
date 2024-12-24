import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter_example/src/app_routes.dart';
import 'package:instabug_flutter_example/src/native/instabug_flutter_example_method_channel.dart';
import 'package:instabug_flutter_example/src/screens/private_view_page.dart';
import 'package:instabug_flutter_example/src/widget/instabug_button.dart';
import 'package:instabug_flutter_example/src/widget/instabug_clipboard_input.dart';
import 'package:instabug_flutter_example/src/widget/instabug_text_field.dart';
import 'package:instabug_flutter_example/src/widget/nested_view.dart';
import 'package:instabug_flutter_example/src/widget/section_title.dart';
import 'package:instabug_http_client/instabug_http_client.dart';
import 'package:instabug_private_views/instabug_private_view.dart';

part 'src/components/fatal_crashes_content.dart';
part 'src/components/flows_content.dart';
part 'src/components/network_content.dart';
part 'src/components/non_fatal_crashes_content.dart';
part 'src/components/page.dart';
part 'src/components/traces_content.dart';
part 'src/screens/apm_page.dart';
part 'src/screens/complex_page.dart';
part 'src/screens/crashes_page.dart';
part 'src/screens/my_home_page.dart';
part 'src/screens/screen_capture_premature_extension_page.dart';
part 'src/screens/screen_loading_page.dart';
part 'src/screens/user_steps_page.dart';

void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      Instabug.init(
        token: 'ed6f659591566da19b67857e1b9d40ab',
        invocationEvents: [InvocationEvent.floatingButton],
        debugLogsLevel: LogLevel.none,
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      enableInstabugMaskingPrivateViews();

      Instabug.enableUserSteps(false);
      runApp(const InstabugUserSteps(child: MyApp())); // runApp(const MyApp());
    },
    CrashReporting.reportCrash,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorObservers: [
        InstabugNavigatorObserver(),
      ],
      routes: APM.wrapRoutes(appRoutes, exclude: [CrashesPage.screenName]),
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}
