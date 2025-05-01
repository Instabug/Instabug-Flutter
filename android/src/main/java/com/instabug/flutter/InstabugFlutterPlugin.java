package com.instabug.flutter;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.util.Log;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.instabug.flutter.generated.InstabugFlutterPigeon;
import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.modules.BugReportingApi;
import com.instabug.flutter.modules.CrashReportingApi;
import com.instabug.flutter.modules.FeatureRequestsApi;
import com.instabug.flutter.modules.InstabugApi;
import com.instabug.flutter.modules.InstabugLogApi;
import com.instabug.flutter.modules.RepliesApi;
import com.instabug.flutter.modules.SessionReplayApi;
import com.instabug.flutter.modules.SurveysApi;
import com.instabug.flutter.util.ThreadManager;

import java.util.concurrent.Callable;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.BinaryMessenger;

public class InstabugFlutterPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = InstabugFlutterPlugin.class.getName();

    private Activity flutterActivity;

    public InstabugFlutterPigeon.InstabugFlutterApi instabugFlutterApi;

    private boolean isLastScreenInstabug = false;
    Application.ActivityLifecycleCallbacks callbacks = new Application.ActivityLifecycleCallbacks() {
        @Override
        public void onActivityCreated(@NonNull Activity activity, @Nullable Bundle savedInstanceState) {

        }

        @Override
        public void onActivityStarted(@NonNull Activity activity) {
            if (isLastScreenInstabug) {
                isLastScreenInstabug = false;
                return;
            }

            isLastScreenInstabug = activity.getComponentName().getClassName().contains("com.instabug.");
            if (activity == flutterActivity) {
                Log.v(TAG, "onActivityStarted");
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            if (instabugApi != null) {
                                instabugApi.reportLastScreenChange();
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });

            }

        }

        @Override
        public void onActivityResumed(@NonNull Activity activity) {

        }


        @Override
        public void onActivityPaused(@NonNull Activity activity) {

        }

        @Override
        public void onActivityStopped(@NonNull Activity activity) {


        }

        @Override
        public void onActivitySaveInstanceState(@NonNull Activity activity, @NonNull Bundle outState) {

        }

        @Override
        public void onActivityDestroyed(@NonNull Activity activity) {

        }
    };

    private InstabugApi instabugApi;

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getApplicationContext(), binding.getBinaryMessenger(), (FlutterRenderer) binding.getTextureRegistry());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        flutterActivity = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        flutterActivity = binding.getActivity();
        initOnActivityResultListener();
    }

    private void initOnActivityResultListener() {
        Application app = flutterActivity.getApplication();
        app.unregisterActivityLifecycleCallbacks(callbacks);
        app.registerActivityLifecycleCallbacks(callbacks);
    }


    @Override
    public void onDetachedFromActivityForConfigChanges() {
        flutterActivity = null;

    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        flutterActivity = binding.getActivity();
        initOnActivityResultListener();
    }

    @Override
    public void onDetachedFromActivity() {
        flutterActivity = null;
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
        instabugApi = InstabugApi.init(messenger, context, screenshotProvider);
        InstabugLogApi.init(messenger);
        RepliesApi.init(messenger);
        SessionReplayApi.init(messenger);
        SurveysApi.init(messenger);
        instabugFlutterApi = new InstabugFlutterPigeon.InstabugFlutterApi(messenger);

    }

    @Nullable
    private Bitmap takeScreenshot(FlutterRenderer renderer) {
        try {
            final View view = flutterActivity.getWindow().getDecorView().getRootView();

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
