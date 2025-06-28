import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/models/instabug_route.dart';
import 'package:instabug_flutter/src/modules/instabug.dart';
import 'package:instabug_flutter/src/utils/instabug_logger.dart';
import 'package:instabug_flutter/src/utils/repro_steps_constants.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:instabug_flutter/src/utils/ui_trace/flags_config.dart';

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

      ScreenLoadingManager.I
          .startUiTrace(maskedScreenName, screenName)
          .then(_startScreenRenderCollector);

      // If there is a step that hasn't been pushed yet
      if (_steps.isNotEmpty) {
        // Report the last step and remove it from the list
        Instabug.reportScreenChange(_steps.last.name);
        _steps.removeLast();
      }

      // Add the new step to the list
      _steps.add(route);
      Future<dynamic>.delayed(const Duration(milliseconds: 1000), () {
        // If this route is in the array, report it and remove it from the list
        if (_steps.contains(route)) {
          Instabug.reportScreenChange(route.name);
          _steps.remove(route);
        }
      });
    } catch (e) {
      InstabugLogger.I.e('Reporting screen change failed:', tag: Instabug.tag);
      InstabugLogger.I.e(e.toString(), tag: Instabug.tag);
    }
  }

  FutureOr<void> _startScreenRenderCollector(int? uiTraceId) async {
    final isScreenRender = await FlagsConfig.screenRendering.isEnabled();
    log("isScreenRender: $isScreenRender", name: 'Andrew');
    if (uiTraceId != null && isScreenRender) {
      InstabugScreenRenderManager.I
          .startScreenRenderCollectorForTraceId(uiTraceId);
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
