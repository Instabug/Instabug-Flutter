package com.instabug.flutter.util.privateViews;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.PixelCopy;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.annotation.VisibleForTesting;

import com.instabug.flutter.generated.InstabugPrivateViewPigeon;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.renderer.FlutterRenderer;

public class PrivateViewManager {
    private final ExecutorService screenshotExecutor = Executors.newSingleThreadExecutor(runnable -> {
        Thread thread = new Thread(runnable);
        thread.setName("IBG-Flutter-Screenshot");
        return thread;
    });

    private InstabugPrivateViewPigeon.InstabugPrivateViewApi instabugPrivateViewApi;
    private Activity activity;
    private final FlutterRenderer renderer;

    public PrivateViewManager(@NonNull InstabugPrivateViewPigeon.InstabugPrivateViewApi instabugPrivateViewApi, FlutterRenderer renderer) {
        this.instabugPrivateViewApi = instabugPrivateViewApi;
        this.renderer = renderer;
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }

    @VisibleForTesting
    protected ScreenshotResult takeScreenshot() {

        View rootView = activity.getWindow().getDecorView().getRootView();
        rootView.setDrawingCacheEnabled(true);
        Bitmap bitmap = renderer.getBitmap();
        rootView.setDrawingCacheEnabled(false);
        DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
        return new ScreenshotResult(displayMetrics.density, bitmap);
    }

    @RequiresApi(api = Build.VERSION_CODES.N)
    private void takeScreenshotWithPixelCopy(PixelCopyManager pixelCopyManager) {
        FlutterView flutterView = activity.findViewById(FlutterActivity.FLUTTER_VIEW_ID);
        if (flutterView == null || flutterView.getChildCount() == 0 || !(flutterView.getChildAt(0) instanceof SurfaceView)) {
            pixelCopyManager.onError();
            return;
        }

        View rootView = activity.getWindow().getDecorView();
        Bitmap bitmap = Bitmap.createBitmap(rootView.getWidth(), rootView.getHeight(), Bitmap.Config.ARGB_8888);

        PixelCopy.request(
                (SurfaceView) flutterView.getChildAt(0),
                bitmap,
                copyResult -> {
                    if (copyResult == PixelCopy.SUCCESS) {
                        DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
                        pixelCopyManager.onBitmap(new ScreenshotResult(displayMetrics.density, bitmap));
                    } else {
                        pixelCopyManager.onError();
                    }
                },
                new Handler(Looper.getMainLooper())
        );
    }

    public void mask(ScreenshotManager screenshotManager) {
        if (activity != null) {
            long startTime = System.currentTimeMillis();
            CountDownLatch latch = new CountDownLatch(1);
            AtomicReference<List<Double>> privateViews = new AtomicReference<>();

            try {
                activity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        instabugPrivateViewApi.getPrivateViews(result -> {
                            privateViews.set(result);
                            latch.countDown();
                        });
                    }
                });


                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    takeScreenshotWithPixelCopy(new PixelCopyManager() {
                        @Override
                        public void onBitmap(ScreenshotResult result) {
                            processScreenshot(result, privateViews, latch, screenshotManager, startTime);
                        }

                        @Override
                        public void onError() {
                            screenshotManager.onError();
                        }
                    });
                } else {
                    ScreenshotResult result = takeScreenshot();
                    processScreenshot(result, privateViews, latch, screenshotManager, startTime);
                }

            } catch (Exception e) {
                Log.e("IBG-PV-Perf", "Screenshot capturing failed, took " + (System.currentTimeMillis() - startTime) + "ms", e);
                screenshotManager.onError();
            }
        } else {
            screenshotManager.onError();
        }

    }

    private void processScreenshot(ScreenshotResult result, AtomicReference<List<Double>> privateViews, CountDownLatch latch, ScreenshotManager screenshotManager, long startTime) {
        screenshotExecutor.execute(() -> {
            try {
                latch.await();  // Wait for private views
                maskPrivateViews(result, privateViews.get());
                Log.d("IBG-PV-Perf", "Screenshot processed in " + (System.currentTimeMillis() - startTime) + "ms");
                screenshotManager.onSuccess(result.getScreenshot());
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
                Log.e("IBG-PV-Perf", "Screenshot processing interrupted", e);
                screenshotManager.onError();
            }
        });
    }

    private void maskPrivateViews(ScreenshotResult result, List<Double> privateViews) {
        if (privateViews == null || privateViews.isEmpty()) return;

        Bitmap bitmap = result.getScreenshot();
        float pixelRatio = result.getPixelRatio();
        Canvas canvas = new Canvas(bitmap);
        Paint paint = new Paint();  // Default color is black

        for (int i = 0; i < privateViews.size(); i += 4) {
            float left = (float) (privateViews.get(i) * pixelRatio);
            float top = (float) (privateViews.get(i + 1) * pixelRatio);
            float right = (float) (privateViews.get(i + 2) * pixelRatio);
            float bottom = (float) (privateViews.get(i + 3) * pixelRatio);
            canvas.drawRect(left, top, right, bottom, paint);  // Mask private view
        }
    }
}