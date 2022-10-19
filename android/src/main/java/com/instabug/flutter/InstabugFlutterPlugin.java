package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.*;
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

    private static void register(Context applicationContext, BinaryMessenger messenger){
        InstabugPigeon.InstabugHostApi.setup(messenger, new InstabugApi(applicationContext));
        InstabugLogPigeon.InstabugLogHostApi.setup(messenger, new InstabugLogApi());
        ApmPigeon.ApmHostApi.setup(messenger, new ApmApi());
        BugReportingPigeon.BugReportingHostApi.setup(messenger, new BugReportingApi(messenger));
        CrashReportingPigeon.CrashReportingHostApi.setup(messenger, new CrashReportingApi());
        FeatureRequestsPigeon.FeatureRequestsHostApi.setup(messenger, new FeatureRequestsApi());
        RepliesPigeon.RepliesHostApi.setup(messenger, new RepliesApi(messenger));
        SurveysPigeon.SurveysHostApi.setup(messenger, new SurveysApi(messenger));
    }
}
