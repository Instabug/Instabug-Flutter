import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_example/src/app_routes.dart';
import 'package:instabug_flutter_example/src/widget/nested_view.dart';

import 'src/native/instabug_flutter_example_method_channel.dart';
import 'src/widget/instabug_button.dart';
import 'src/widget/instabug_clipboard_input.dart';
import 'src/widget/instabug_text_field.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';

import 'src/widget/section_title.dart';

part 'src/screens/crashes_page.dart';

part 'src/screens/complex_page.dart';

part 'src/screens/apm_page.dart';

part 'src/screens/screen_capture_premature_extension_page.dart';

part 'src/screens/screen_loading_page.dart';

part 'src/screens/my_home_page.dart';

part 'src/components/fatal_crashes_content.dart';

part 'src/components/non_fatal_crashes_content.dart';

part 'src/components/network_content.dart';

part 'src/components/page.dart';

part 'src/components/traces_content.dart';

part 'src/components/flows_content.dart';

void main() {
  runZonedGuarded(
    () async{
      WidgetsFlutterBinding.ensureInitialized();

      APM.startCpUiTrace("TestScreen1", 1000, 1000);

      await Instabug.init(
        token: 'e19c3abd7c2af1560038c339ea31ac9e',
        invocationEvents: [InvocationEvent.floatingButton],
        debugLogsLevel: LogLevel.verbose,
      );

      APM.startCpUiTrace("TestScreen2", 1000, 2000);

      // Future.delayed(const Duration(seconds: 5)).then((_) {
      // });

      // Future.delayed(const Duration(seconds: 1)).then((value) {
      //   APM.startCpUiTrace("TestScreen_$i", 1000, i*1000);
      //   // for(int i =0 ; i<1000 ; i++){
      //   //
      //   //  // log("startCpUiTrace: Screen$i");
      //   // }
      // });

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      runApp(const MyApp());
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
