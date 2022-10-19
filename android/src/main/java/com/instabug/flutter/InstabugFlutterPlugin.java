package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.flutter.modules.*;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class InstabugFlutterPlugin implements FlutterPlugin {
    /**
     * Embedding v1
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        register(registrar.context().getApplicationContext(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    private static void register(Context context, BinaryMessenger messenger) {
        new ApmApi(messenger);
        new BugReportingApi(messenger);
        new CrashReportingApi(messenger);
        new FeatureRequestsApi(messenger);
        new InstabugApi(messenger, context);
        new InstabugLogApi(messenger);
        new RepliesApi(messenger);
        new SurveysApi(messenger);
    }
}
