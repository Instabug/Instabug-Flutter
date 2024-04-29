import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';

class InstabugNavigatorObserver extends NavigatorObserver {
  final List<Route> _steps = <Route>[];

  void screenChanged(Route newRoute) {
    try {
      final screenName = newRoute.settings.name.toString();
      // Starts a the new UI trace which is exclusive to screen loading
      ScreenLoadingManager.I.startUiTrace(screenName);
      // If there is a step that hasn't been pushed yet
      if (_steps.isNotEmpty) {
        // Report the last step and remove it from the list
        Instabug.reportScreenChange(
          _steps[_steps.length - 1].settings.name.toString(),
        );
        _steps.remove(_steps[_steps.length - 1]);
      }
      // Add the new step to the list
      _steps.add(newRoute);
      Future<dynamic>.delayed(const Duration(milliseconds: 1000), () {
        // If this route is in the array, report it and remove it from the list
        if (_steps.contains(newRoute)) {
          Instabug.reportScreenChange(screenName);
          _steps.remove(newRoute);
        }
      });
    } catch (e) {
      debugPrint('[INSTABUG] - Reporting screen failed');
    }
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    if (previousRoute != null) {
      screenChanged(previousRoute);
    }
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    screenChanged(route);
  }
}
