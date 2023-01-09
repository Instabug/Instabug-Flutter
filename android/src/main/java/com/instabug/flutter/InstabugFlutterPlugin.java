package com.instabug.flutter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.modules.BugReportingApi;
import com.instabug.flutter.modules.CrashReportingApi;
import com.instabug.flutter.modules.FeatureRequestsApi;
import com.instabug.flutter.modules.InstabugApi;
import com.instabug.flutter.modules.InstabugLogApi;
import com.instabug.flutter.modules.RepliesApi;
import com.instabug.flutter.modules.SurveysApi;

import java.util.concurrent.Callable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class InstabugFlutterPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = "InstabugFlutterPlugin";

    @SuppressLint("StaticFieldLeak")
    private static Activity activity;

    /**
     * Embedding v1
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        activity = registrar.activity();
        Log.d(TAG, "Embedding v1: " + registrar.textures());
        register(registrar.context().getApplicationContext(), registrar.messenger(), (FlutterRenderer) registrar.textures());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        Log.d(TAG, "Embedding v2: " + binding.getTextureRegistry());
        register(binding.getApplicationContext(), binding.getBinaryMessenger(), (FlutterRenderer) binding.getTextureRegistry());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        activity = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {
        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    private static void register(Context context, BinaryMessenger messenger, FlutterRenderer renderer) {
        final Callable<Bitmap> screenshotProvider = new Callable<Bitmap>() {
            @Override
            public Bitmap call() {
                Log.d(TAG, "Screenshot Provider called with renderer: " + renderer.toString());
                return takeScreenshot(renderer);
            }
        };

        ApmApi.init(messenger);
        BugReportingApi.init(messenger);
        CrashReportingApi.init(messenger);
        FeatureRequestsApi.init(messenger);
        InstabugApi.init(messenger, context, screenshotProvider);
        InstabugLogApi.init(messenger);
        RepliesApi.init(messenger);
        SurveysApi.init(messenger);
    }

    @Nullable
    private static Bitmap takeScreenshot(FlutterRenderer renderer) {
        try {
            final View view = activity.getWindow().getDecorView().getRootView();
            Log.d(TAG, "view: " + view.toString());

            view.setDrawingCacheEnabled(true);
            final Bitmap bitmap = renderer.getBitmap();
            Log.d(TAG, "bitmap: " + bitmap.toString());
            view.setDrawingCacheEnabled(false);

            return bitmap;
        } catch (Exception e) {
            Log.e(TAG, "Failed to take screenshot using " + renderer.toString() + ". Cause: " + e);
            return null;
        }
    }
}
