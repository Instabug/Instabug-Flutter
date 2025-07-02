package com.instabug.flutter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Build;
import android.util.Log;
import android.view.Display;
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
import com.instabug.flutter.modules.SessionReplayApi;
import com.instabug.flutter.modules.SurveysApi;

import java.util.concurrent.Callable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.BinaryMessenger;

public class InstabugFlutterPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = InstabugFlutterPlugin.class.getName();

    @SuppressLint("StaticFieldLeak")
    private static Activity activity;


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
                return takeScreenshot(renderer);
            }
        };

        Callable<Float> refreshRateProvider = new Callable<Float>() {
            @Override
            public Float call(){
                return getRefreshRate();
            }
        };

        ApmApi.init(messenger, refreshRateProvider);
        BugReportingApi.init(messenger);
        CrashReportingApi.init(messenger);
        FeatureRequestsApi.init(messenger);
        InstabugApi.init(messenger, context, screenshotProvider);
        InstabugLogApi.init(messenger);
        RepliesApi.init(messenger);
        SessionReplayApi.init(messenger);
        SurveysApi.init(messenger);
    }

    @Nullable
    private static Bitmap takeScreenshot(FlutterRenderer renderer) {
        try {
            final View view = activity.getWindow().getDecorView().getRootView();

            view.setDrawingCacheEnabled(true);
            final Bitmap bitmap = renderer.getBitmap();
            view.setDrawingCacheEnabled(false);

            return bitmap;
        } catch (Exception e) {
            Log.e(TAG, "Failed to take screenshot using " + renderer.toString() + ". Cause: " + e);
            return null;
        }
    }

    private static float getRefreshRate() {
        float refreshRate = 60f;

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            final Display display = activity.getDisplay();
            if (display != null) {
                refreshRate = display.getRefreshRate();
            }
        } else {
            refreshRate = activity.getWindowManager().getDefaultDisplay().getRefreshRate();
        }

        return refreshRate;
    }

}
