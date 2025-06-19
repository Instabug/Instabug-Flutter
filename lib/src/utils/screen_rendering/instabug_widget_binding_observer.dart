import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
import 'package:meta/meta.dart';

//todo: remove logs
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

  void _handleResumedState() {
    log('Performing resume actions...');
    final lastUiTrace = ScreenLoadingManager.I.currentUiTrace;
    if (lastUiTrace != null) {
      final maskedScreenName = ScreenNameMasker.I.mask(lastUiTrace.screenName);
      ScreenLoadingManager.I
          .startUiTrace(maskedScreenName, lastUiTrace.screenName)
          .then((uiTraceId) {
        if (uiTraceId != null &&
            InstabugScreenRenderManager.I.screenRenderEnabled) {
          InstabugScreenRenderManager.I
              .startScreenRenderCollectorForTraceId(uiTraceId);
        }
      });
    }
  }

  void _handlePausedState() {
    log('Performing pause actions...');
    InstabugScreenRenderManager.I.stopScreenRenderCollector();
  }

  void _handleDetachedState() {
    log('Performing detached actions...');
    InstabugScreenRenderManager.I.stopScreenRenderCollector();
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

@internal
void checkForWidgetBinding() {
  try {
    WidgetsBinding.instance;
  } catch (_) {
    WidgetsFlutterBinding.ensureInitialized();
  }
}
