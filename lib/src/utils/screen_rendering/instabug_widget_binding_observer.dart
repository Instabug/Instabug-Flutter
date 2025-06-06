import 'dart:async';
import 'dart:developer';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/models/InstabugScreenRenderData.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';

class InstabugWidgetsBindingObserver extends WidgetsBindingObserver {
  void _handleResumedState() {
    log('Performing resume actions...');
    final lastUiTrace = ScreenLoadingManager.I.currentUiTrace;
    if (lastUiTrace != null) {
      final maskedScreenName = ScreenNameMasker.I.mask(lastUiTrace.screenName);
      ScreenLoadingManager.I
          .startUiTrace(maskedScreenName, lastUiTrace.screenName);
    }
    // ... complex logic for resumed state
  }

  void _handlePausedState() {
    // ... complex logic for paused state
    log('Performing pause actions...');
    InstabugScreenRenderManager.I.stopScreenRenderCollector();
  }

  void _handleDetachedState() {
    log('Performing detached actions...');
    InstabugScreenRenderManager.I.stopScreenRenderCollector();
    // ... complex logic for paused state
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _handleResumedState();
        break;
      case AppLifecycleState.paused:
        _handlePausedState();
        break;
      case AppLifecycleState.detached:
        _handleDetachedState();
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.hidden:
        // TODO: Handle this case.
        break;
    }
  }
}
