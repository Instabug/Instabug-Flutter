package com.instabug.flutter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.instabug.flutter.generated.InstabugPrivateViewPigeon;
import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.modules.BugReportingApi;
import com.instabug.flutter.modules.CrashReportingApi;
import com.instabug.flutter.modules.FeatureRequestsApi;
import com.instabug.flutter.modules.InstabugApi;
import com.instabug.flutter.modules.InstabugLogApi;
import com.instabug.flutter.modules.RepliesApi;
import com.instabug.flutter.modules.SessionReplayApi;
import com.instabug.flutter.modules.SurveysApi;
import com.instabug.flutter.util.privateViews.BoundryCaptureManager;
import com.instabug.flutter.util.privateViews.PixelCopyCaptureManager;
import com.instabug.flutter.util.privateViews.PrivateViewManager;
import com.instabug.library.internal.crossplatform.InternalCore;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;

public class InstabugFlutterPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = InstabugFlutterPlugin.class.getName();

    @SuppressLint("StaticFieldLeak")
    private static Activity activity;

    PrivateViewManager privateViewManager;

    /**
     * Embedding v1
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(PluginRegistry.Registrar registrar) {
        activity = registrar.activity();
        register(registrar.context().getApplicationContext(), registrar.messenger(), (FlutterRenderer) registrar.textures());
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getApplicationContext(), binding.getBinaryMessenger(), (FlutterRenderer) binding.getTextureRegistry());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activity = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        if (privateViewManager != null) {
            privateViewManager.setActivity(activity);
        }

    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
        privateViewManager.setActivity(null);

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        privateViewManager.setActivity(activity);

    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
        privateViewManager.setActivity(null);

    }

    private static void register(Context context, BinaryMessenger messenger, FlutterRenderer renderer) {
        ApmApi.init(messenger);
        BugReportingApi.init(messenger);
        CrashReportingApi.init(messenger);
        FeatureRequestsApi.init(messenger);
        privateViewManager = new PrivateViewManager(new InstabugPrivateViewPigeon.InstabugPrivateViewApi(messenger), new PixelCopyCaptureManager(), new BoundryCaptureManager(renderer));
        InstabugApi.init(messenger, context, privateViewManager, InternalCore.INSTANCE);
        InstabugLogApi.init(messenger);
        RepliesApi.init(messenger);
        SessionReplayApi.init(messenger);
        SurveysApi.init(messenger);
    }

}
