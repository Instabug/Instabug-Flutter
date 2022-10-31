package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.modules.BugReportingApi;
import com.instabug.flutter.modules.CrashReportingApi;
import com.instabug.flutter.modules.FeatureRequestsApi;
import com.instabug.flutter.modules.InstabugApi;
import com.instabug.flutter.modules.InstabugLogApi;
import com.instabug.flutter.modules.RepliesApi;
import com.instabug.flutter.modules.SurveysApi;

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

    private static void register(Context context, BinaryMessenger messenger) {
        ApmApi.init(messenger);
        BugReportingApi.init(messenger);
        CrashReportingApi.init(messenger);
        FeatureRequestsApi.init(messenger);
        InstabugApi.init(messenger, context);
        InstabugLogApi.init(messenger);
        RepliesApi.init(messenger);
        SurveysApi.init(messenger);
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }
}
