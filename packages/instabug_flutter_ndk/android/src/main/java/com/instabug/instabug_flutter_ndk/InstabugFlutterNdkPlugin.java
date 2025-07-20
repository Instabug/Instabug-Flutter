package com.instabug.instabug_flutter_ndk;

import androidx.annotation.NonNull;
import io.flutter.embedding.engine.plugins.FlutterPlugin;

/** InstabugFlutterNdkPlugin - Pure dependency plugin for NDK crash monitoring */
public class InstabugFlutterNdkPlugin implements FlutterPlugin {
  @Override
  public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
    // No method channel needed - this is a pure dependency plugin
  }

  @Override
  public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    // Cleanup if needed
  }
}
