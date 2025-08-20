import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:instabug_flutter/src/utils/ui_trace/flags_config.dart';
import 'package:meta/meta.dart';

class InstabugWidgetsBindingObserver extends WidgetsBindingObserver {
  InstabugWidgetsBindingObserver._();

  static final InstabugWidgetsBindingObserver _instance =
      InstabugWidgetsBindingObserver._();

  /// Returns the singleton instance of [InstabugWidgetsBindingObserver].
  static InstabugWidgetsBindingObserver get instance => _instance;

  /// Shorthand for [instance]
  static InstabugWidgetsBindingObserver get I => instance;

  /// Logging tag for debugging purposes.
  static const tag = "InstabugWidgetsBindingObserver";

  /// Disposes all screen render resources.
  static void dispose() {
    //Save the screen rendering data for the active traces Auto|Custom.
    InstabugScreenRenderManager.I.stopScreenRenderCollector();

    // The dispose method is safe to call multiple times due to state tracking
    InstabugScreenRenderManager.I.dispose();
  }

  void _handleResumedState() {
    final lastUiTrace = ScreenLoadingManager.I.currentUiTrace;

    if (lastUiTrace == null) return;

    final maskedScreenName = ScreenNameMasker.I.mask(lastUiTrace.screenName);

    ScreenLoadingManager.I
        .startUiTrace(maskedScreenName, lastUiTrace.screenName)
        .then((uiTraceId) async {
      if (uiTraceId == null) return;

      final isScreenRenderEnabled =
          await FlagsConfig.screenRendering.isEnabled();

      if (!isScreenRenderEnabled) return;

      await InstabugScreenRenderManager.I
          .checkForScreenRenderInitialization(isScreenRenderEnabled);

      //End any active ScreenRenderCollector before starting a new one (Safe garde condition).
      InstabugScreenRenderManager.I.endScreenRenderCollector();

      //Start new ScreenRenderCollector.
      InstabugScreenRenderManager.I
          .startScreenRenderCollectorForTraceId(uiTraceId);
    });
  }

  void _handlePausedState() {
    // Only handles iOS platform because in android we use pigeon @FlutterApi().
    // To overcome the onActivityDestroy() before sending the data to the android side.
    if (InstabugScreenRenderManager.I.screenRenderEnabled &&
        IBGBuildInfo.I.isIOS) {
      log("_handlePausedState" , name: "andrew");
      InstabugScreenRenderManager.I.stopScreenRenderCollector();
    }
  }

  Future<void> _handleDetachedState() async {
    // Only handles iOS platform because in android we use pigeon @FlutterApi().
    // To overcome the onActivityDestroy() before sending the data to the android side.
    if (InstabugScreenRenderManager.I.screenRenderEnabled &&
        IBGBuildInfo.I.isIOS) {
      log("_handleDetachedState" , name: "andrew");

      dispose();
    }
  }

  void _handleDefaultState() {
    // Added for lint warnings
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
      default:
        _handleDefaultState();
    }
  }
}

@internal
void checkForWidgetBinding() {
  try {
    WidgetsBinding.instance;
  } catch (_) {
    WidgetsFlutterBinding.ensureInitialized();
  }
}
