import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/models/instabug_route.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/instabug_navigator.dart';
import 'package:instabug_flutter/src/utils/repro_steps_constants.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';

class InstabugNavigatorObserver extends NavigatorObserver {
  InstabugNavigator instabugNavigator = new InstabugNavigator();

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      instabugNavigator.screenChanged(previousRoute.settings.name?.trim());
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    instabugNavigator.screenChanged(route.settings.name?.trim());
  }
}
