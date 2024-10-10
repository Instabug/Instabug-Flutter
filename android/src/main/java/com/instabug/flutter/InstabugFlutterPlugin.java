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
import com.instabug.flutter.util.privateViews.PrivateViewManager;
import com.instabug.library.internal.crossplatform.InternalCore;

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

    PrivateViewManager privateViewManager;


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
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        if (privateViewManager != null) {
            privateViewManager.setActivity(activity);
        }
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    private void register(Context context, BinaryMessenger messenger, FlutterRenderer renderer) {
        final Callable<Bitmap> screenshotProvider = new Callable<Bitmap>() {
            @Override
            public Bitmap call() {
                return takeScreenshot(renderer);
            }
        };

        ApmApi.init(messenger);
        BugReportingApi.init(messenger);
        CrashReportingApi.init(messenger);
        FeatureRequestsApi.init(messenger);
        privateViewManager = new PrivateViewManager(new InstabugPrivateViewPigeon.InstabugPrivateViewApi(messenger), renderer);
        InstabugApi.init(messenger, context, privateViewManager, InternalCore.INSTANCE);
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
}
