package com.instabug.flutter.util.privateViews;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;
import android.os.Handler;
import android.os.Looper;
import android.util.DisplayMetrics;
import android.view.PixelCopy;
import android.view.SurfaceView;
import android.view.View;

import androidx.annotation.NonNull;
import androidx.annotation.RequiresApi;
import androidx.annotation.VisibleForTesting;

import com.instabug.flutter.generated.InstabugPrivateViewPigeon;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.screenshot.ScreenshotCaptor;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.renderer.FlutterRenderer;

public class PrivateViewManager {
    private static final String THREAD_NAME = "IBG-Flutter-Screenshot";

    private final ExecutorService screenshotExecutor = Executors.newSingleThreadExecutor(runnable -> {
        Thread thread = new Thread(runnable);
        thread.setName(THREAD_NAME);
        return thread;
    });

    private final InstabugPrivateViewPigeon.InstabugPrivateViewApi instabugPrivateViewApi;
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
        if (activity == null)
            return null;
        View rootView = activity.getWindow().getDecorView().getRootView();
        rootView.setDrawingCacheEnabled(true);
        Bitmap bitmap = renderer.getBitmap();
        rootView.setDrawingCacheEnabled(false);
        DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
        return new ScreenshotResult(displayMetrics.density, bitmap);
    }

    @RequiresApi(api = Build.VERSION_CODES.O)
    void takeScreenshotWithPixelCopy(PixelCopyManager pixelCopyManager) {
        FlutterView flutterView = activity.findViewById(FlutterActivity.FLUTTER_VIEW_ID);
        if (flutterView == null || flutterView.getChildCount() == 0 || !(flutterView.getChildAt(0) instanceof SurfaceView)) {
            pixelCopyManager.onError();
            return;
        }

        SurfaceView surfaceView = (SurfaceView) flutterView.getChildAt(0);

        Bitmap bitmap = Bitmap.createBitmap(surfaceView.getWidth(), surfaceView.getHeight(), Bitmap.Config.ARGB_8888);

        PixelCopy.request(surfaceView, bitmap, copyResult -> {
            if (copyResult == PixelCopy.SUCCESS) {
                DisplayMetrics displayMetrics = activity.getResources().getDisplayMetrics();
                pixelCopyManager.onBitmap(new ScreenshotResult(displayMetrics.density, bitmap));
            } else {
                pixelCopyManager.onError();
            }
        }, new Handler(Looper.getMainLooper()));
    }


    public void mask(ScreenshotCaptor.CapturingCallback capturingCallback) {
        if (activity != null) {
            CountDownLatch latch = new CountDownLatch(1);
            AtomicReference<List<Double>> privateViews = new AtomicReference<>();

            try {
                ThreadManager.runOnMainThread(new Runnable() {
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
                            processScreenshot(result, privateViews, latch, capturingCallback);
                        }

                        @Override
                        public void onError() {
                            captureAndProcessScreenshot(privateViews, latch, capturingCallback);
                        }
                    });
                } else {
                    ThreadManager.runOnMainThread(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                captureAndProcessScreenshot(privateViews, latch, capturingCallback);

                            } catch (Exception e) {
                                capturingCallback.onCapturingFailure(e);
                            }

                        }
                    });
                }

            } catch (Exception e) {
                capturingCallback.onCapturingFailure(e);
            }
        } else {
            capturingCallback.onCapturingFailure(new Throwable("IBG-Flutter-private_views"));
        }

    }

    void captureAndProcessScreenshot(AtomicReference<List<Double>> privateViews, CountDownLatch latch, ScreenshotCaptor.CapturingCallback capturingCallback) {
        final ScreenshotResult result = takeScreenshot();
        processScreenshot(result, privateViews, latch, capturingCallback);
    }

    private void processScreenshot(ScreenshotResult result, AtomicReference<List<Double>> privateViews, CountDownLatch latch, ScreenshotCaptor.CapturingCallback capturingCallback) {
        screenshotExecutor.execute(() -> {
            try {
                latch.await();  // Wait
                Bitmap bitmap = result.getScreenshot();
                maskPrivateViews(result, privateViews.get());
                capturingCallback.onCapturingSuccess(bitmap);
            } catch (InterruptedException e) {
                capturingCallback.onCapturingFailure(e);
            }
        });
    }

    void maskPrivateViews(ScreenshotResult result, List<Double> privateViews) {
        if (privateViews == null || privateViews.isEmpty()) return;

        Bitmap bitmap = result.getScreenshot();
        float pixelRatio = result.getPixelRatio();
        Canvas canvas = new Canvas(bitmap);
        Paint paint = new Paint();  // Default color is black

        for (int i = 0; i < privateViews.size(); i += 4) {
            float left = privateViews.get(i).floatValue() * pixelRatio;
            float top = privateViews.get(i + 1).floatValue() * pixelRatio;
            float right = privateViews.get(i + 2).floatValue() * pixelRatio;
            float bottom = privateViews.get(i + 3).floatValue() * pixelRatio;
            canvas.drawRect(left, top, right, bottom, paint);  // Mask private view
        }
    }
}