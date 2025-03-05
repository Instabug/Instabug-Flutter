package com.instabug.flutter.modules.capturing;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.PixelCopy;
import android.view.SurfaceView;

import androidx.annotation.RequiresApi;

import com.instabug.flutter.model.ScreenshotResult;
import com.instabug.library.util.memory.MemoryUtils;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterFragment;
import io.flutter.embedding.android.FlutterView;

public class PixelCopyCaptureManager implements CaptureManager {

    @RequiresApi(api = Build.VERSION_CODES.N)
    @Override
    public void capture(Activity activity, ScreenshotResultCallback screenshotResultCallback) {
        FlutterView flutterView = getFlutterView(activity);
        if (flutterView == null || !isValidFlutterView(flutterView)) {
            screenshotResultCallback.onError();
            return;
        }

        SurfaceView surfaceView = (SurfaceView) flutterView.getChildAt(0);
        Bitmap bitmap = createBitmapFromSurface(surfaceView);

        if (bitmap == null) {
            screenshotResultCallback.onError();
            return;
        }

        PixelCopy.request(surfaceView, bitmap, copyResult -> {
            if (copyResult == PixelCopy.SUCCESS) {
                DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
                screenshotResultCallback.onScreenshotResult(new ScreenshotResult(displayMetrics.density, bitmap));
            } else {
                screenshotResultCallback.onError();
            }
        }, new Handler(Looper.getMainLooper()));
    }

    private FlutterView getFlutterView(Activity activity) {
        FlutterView flutterViewInActivity = activity.findViewById(FlutterActivity.FLUTTER_VIEW_ID);
        FlutterView flutterViewInFragment = activity.findViewById(FlutterFragment.FLUTTER_VIEW_ID);
        return flutterViewInActivity != null ? flutterViewInActivity : flutterViewInFragment;
    }

    private boolean isValidFlutterView(FlutterView flutterView) {
        boolean hasChildren = flutterView.getChildCount() > 0;
        boolean isSurfaceView = flutterView.getChildAt(0) instanceof SurfaceView;
        return hasChildren && isSurfaceView;
    }

    private Bitmap createBitmapFromSurface(SurfaceView surfaceView) {
        int width = surfaceView.getWidth();
        int height = surfaceView.getHeight();

        if (width <= 0 || height <= 0) {
            return null;
        }
        Bitmap bitmap;
        try {
            if (((long) width * height * 4) < MemoryUtils.getFreeMemory(surfaceView.getContext())) {
                // ARGB_8888 store each pixel in 4 bytes
                bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
            } else {
                // RGB_565 store each pixel in 2 bytes
                bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
            }

        } catch (IllegalArgumentException | OutOfMemoryError e) {
            bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
        }


        return bitmap;
    }
}
