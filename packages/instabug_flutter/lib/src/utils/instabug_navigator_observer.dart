import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/models/instabug_route.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/repro_steps_constants.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';

class InstabugNavigatorObserver extends NavigatorObserver {
  final List<InstabugRoute> _steps = [];

  void screenChanged(Route newRoute) {
    try {
      final rawScreenName = newRoute.settings.name.toString().trim();
      final screenName = rawScreenName.isEmpty
          ? ReproStepsConstants.emptyScreenFallback
          : rawScreenName;
      final maskedScreenName = ScreenNameMasker.I.mask(screenName);

      final route = InstabugRoute(
        route: newRoute,
        name: maskedScreenName,
      );
      //ignore: invalid_null_aware_operator
      WidgetsBinding.instance?.addPostFrameCallback((_) async {
        // Starts a the new UI trace which is exclusive to screen loading
        ScreenLoadingManager.I.startUiTrace(maskedScreenName, screenName);
        // If there is a step that hasn't been pushed yet
        if (_steps.isNotEmpty) {
          await reportScreenChange(_steps.last.name);
          // Report the last step and remove it from the list
          _steps.removeLast();
        }

        // Add the new step to the list
        _steps.add(route);

        // If this route is in the array, report it and remove it from the list
        if (_steps.contains(route)) {
          await reportScreenChange(route.name);
          _steps.remove(route);
        }
      });
    } catch (e) {
      InstabugLogger.I.e('Reporting screen change failed:', tag: Instabug.tag);
      InstabugLogger.I.e(e.toString(), tag: Instabug.tag);
    }
  }

  Future<void> reportScreenChange(String name) async {
    // Wait for the animation to complete
    await Future.delayed(const Duration(milliseconds: 100));

    Instabug.reportScreenChange(name);
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
