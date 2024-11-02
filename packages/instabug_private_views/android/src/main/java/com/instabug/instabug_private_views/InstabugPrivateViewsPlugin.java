package com.instabug.instabug_private_views;

import android.annotation.SuppressLint;
import android.app.Activity;

import androidx.annotation.NonNull;

import com.instabug.instabug_private_views.generated.InstabugPrivateViewPigeon;
import com.instabug.instabug_private_views.modules.capturing.BoundryCaptureManager;
import com.instabug.instabug_private_views.modules.InstabugPrivateView;
import com.instabug.instabug_private_views.modules.capturing.PixelCopyCaptureManager;
import com.instabug.instabug_private_views.modules.PrivateViewManager;
import com.instabug.library.internal.crossplatform.InternalCore;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.embedding.engine.renderer.FlutterRenderer;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;

/**
 * InstabugPrivateViewsPlugin
 */
public class InstabugPrivateViewsPlugin implements FlutterPlugin, ActivityAware {
    private static final String TAG = InstabugPrivateViewsPlugin.class.getName();

    @SuppressLint("StaticFieldLeak")
    private static Activity activity;

    PrivateViewManager privateViewManager;

    /**
     * Embedding v1
     */
    @SuppressWarnings("deprecation")
    public void registerWith(PluginRegistry.Registrar registrar) {
        activity = registrar.activity();
        register( registrar.messenger(), (FlutterRenderer) registrar.textures());
    }


    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getBinaryMessenger(), (FlutterRenderer) binding.getTextureRegistry());
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

    private void register(BinaryMessenger messenger, FlutterRenderer renderer) {
        privateViewManager = new PrivateViewManager(new InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi(messenger), new PixelCopyCaptureManager(), new BoundryCaptureManager(renderer));
        InstabugPrivateView instabugPrivateView=new InstabugPrivateView(messenger,privateViewManager, InternalCore.INSTANCE);

    }
}
