package com.instabug.instabug_private_views.modules.capturing;

import android.app.Activity;
import android.graphics.Bitmap;
import android.util.DisplayMetrics;
import android.view.View;

import com.instabug.flutter.util.ThreadManager;
import com.instabug.instabug_private_views.model.ScreenshotResult;
import io.flutter.embedding.engine.renderer.FlutterRenderer;

public class BoundryCaptureManager implements CaptureManager {
    FlutterRenderer renderer;

    public BoundryCaptureManager(FlutterRenderer renderer) {
        this.renderer = renderer;
    }

    @Override
    public void capture(Activity activity, ScreenshotResultCallback screenshotResultCallback) {
        ThreadManager.runOnMainThread(new Runnable() {
            @Override
            public void run() {
                try {
                    if (activity == null) {
                        screenshotResultCallback.onError();
                        return;
                    }
                    View rootView = activity.getWindow().getDecorView().getRootView();
                    rootView.setDrawingCacheEnabled(true);
                    Bitmap bitmap = renderer.getBitmap();
                    rootView.setDrawingCacheEnabled(false);
                    DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
                    screenshotResultCallback.onScreenshotResult(new ScreenshotResult(displayMetrics.density, bitmap));

                } catch (Exception e) {
                    screenshotResultCallback.onError();
                }
            }
        });
    }
}
