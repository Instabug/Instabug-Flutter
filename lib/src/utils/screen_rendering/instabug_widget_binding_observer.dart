import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/utils/screen_loading/screen_loading_manager.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:instabug_flutter/src/utils/screen_rendering/instabug_screen_render_manager.dart';
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

  static void dispose() {
    if (InstabugScreenRenderManager.I.screenRenderEnabled) {
      InstabugScreenRenderManager.I.dispose();
    }
    WidgetsBinding.instance.removeObserver(_instance);
  }

  void _handleResumedState() {
    final lastUiTrace = ScreenLoadingManager.I.currentUiTrace;
    if (lastUiTrace == null) {
      return;
    }
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

  void _handlePausedState() {
    if (InstabugScreenRenderManager.I.screenRenderEnabled) {
      InstabugScreenRenderManager.I.stopScreenRenderCollector();
    }
  }

  void _handleDetachedState() {
    if (InstabugScreenRenderManager.I.screenRenderEnabled) {
      InstabugScreenRenderManager.I.stopScreenRenderCollector();
    }
    dispose();
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
