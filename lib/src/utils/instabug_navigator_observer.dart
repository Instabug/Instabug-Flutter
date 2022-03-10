import 'package:flutter/material.dart';

import '../modules/instabug.dart';

class InstabugNavigatorObserver extends NavigatorObserver {
  final List<Route> _steps = <Route>[];

  void screenChanged(final Route newRoute) {
    try {
      // If there is a step that hasn't been pushed yet
      if (_steps.isNotEmpty) {
        // Report the last step and remove it from the list
        Instabug.reportScreenChange(
            _steps[_steps.length - 1].settings.name.toString());
        _steps.remove(_steps[_steps.length - 1]);
      }
      // Add the new step to the list
      _steps.add(newRoute);
      Future<dynamic>.delayed(const Duration(milliseconds: 1000), () {
        // If this route is in the array, report it and remove it from the list
        if (_steps.contains(newRoute)) {
          Instabug.reportScreenChange(newRoute.settings.name.toString());
          _steps.remove(newRoute);
        }
      });
    } catch (e) {
      print('[INSTABUG] - Reporting screen failed');
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
