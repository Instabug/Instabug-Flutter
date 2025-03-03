package com.instabug.flutter;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.util.Log;
import android.view.View;
import android.graphics.Matrix;

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

    /**
     * Embedding v1
     * This method is required for compatibility with apps that don't use the v2 embedding.
     */
//    Uncomment this method if for backward compatibility
//    @SuppressWarnings("deprecation")
//    public static void registerWith(Object registrar) {
//        try {
//            // Use reflection to access the Registrar class and its methods
//            Class<?> registrarClass = Class.forName("io.flutter.plugin.common.PluginRegistry.Registrar");
//            Activity activity = (Activity) registrarClass.getMethod("activity").invoke(registrar);
//            Context context = (Context) registrarClass.getMethod("context").invoke(registrar);
//            BinaryMessenger messenger = (BinaryMessenger) registrarClass.getMethod("messenger").invoke(registrar);
//            FlutterRenderer renderer = (FlutterRenderer) registrarClass.getMethod("textures").invoke(registrar);
//
//            // Set the activity and register with the context
//            InstabugFlutterPlugin.activity = activity;
//            registerWithContext(context.getApplicationContext(), messenger, renderer);
//            System.out.println("old app");
//        } catch (Exception e) {
//            Log.e(TAG, "Failed to register with v1 embedding. Cause: " + e);
//        }
//    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        registerWithContext(
                binding.getApplicationContext(),
                binding.getBinaryMessenger(),
                (FlutterRenderer) binding.getTextureRegistry()
        );
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

    /**
     * Shared logic for both v1 and v2 embeddings.
     */
    private static void registerWithContext(Context context, BinaryMessenger messenger, FlutterRenderer renderer) {
        final Callable<Bitmap> screenshotProvider = new Callable<Bitmap>() {
            @Override
            public Bitmap call() {
                return takeScreenshot(renderer);
            }
        };

        // Initialize all APIs
        ApmApi.init(messenger);
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

            return flipBitmap(bitmap);
        } catch (Exception e) {
            Log.e(TAG, "Failed to take screenshot using " + renderer.toString() + ". Cause: " + e);
            return null;
        }
    }
    private static Bitmap flipBitmap(Bitmap bitmap) {
        // Use Matrix to flip the bitmap vertically (scale Y-axis by -1)
        Matrix matrix = new Matrix();
        matrix.preScale(1, -1); // Flip vertically
        Bitmap flippedBitmap = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
        return flippedBitmap;
    }
}