package com.instabug.flutter.util.privateViews;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.InstabugPrivateViewPigeon;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.screenshot.ScreenshotCaptor;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicReference;

import io.flutter.embedding.engine.renderer.FlutterRenderer;

public class PrivateViewManager {
    private static final String THREAD_NAME = "IBG-Flutter-Screenshot";
    public static final String EXCEPTION_MESSAGE = "IBG-Flutter-Screenshot: error capturing screenshot";

    private final ExecutorService screenshotExecutor = Executors.newSingleThreadExecutor(runnable -> {
        Thread thread = new Thread(runnable);
        thread.setName(THREAD_NAME);
        return thread;
    });

    private final InstabugPrivateViewPigeon.InstabugPrivateViewApi instabugPrivateViewApi;
    private Activity activity;
    final com.instabug.flutter.util.privateViews.ScreenshotCaptor pixelCopyScreenshotCaptor;
    final com.instabug.flutter.util.privateViews.ScreenshotCaptor boundryScreenshotCaptor;

    public PrivateViewManager(@NonNull InstabugPrivateViewPigeon.InstabugPrivateViewApi instabugPrivateViewApi, com.instabug.flutter.util.privateViews.ScreenshotCaptor pixelCopyScreenshotCaptor, com.instabug.flutter.util.privateViews.ScreenshotCaptor boundryScreenshotCaptor) {
        this.instabugPrivateViewApi = instabugPrivateViewApi;
        this.pixelCopyScreenshotCaptor = pixelCopyScreenshotCaptor;
        this.boundryScreenshotCaptor = boundryScreenshotCaptor;


    }

    public void setActivity(Activity activity) {
        this.activity = activity;
    }


    public void mask(ScreenshotCaptor.CapturingCallback capturingCallback) {
        if (activity != null) {
            CountDownLatch latch = new CountDownLatch(1);
            AtomicReference<List<Double>> privateViews = new AtomicReference<>();
            final ScreenshotResultCallback boundryScreenshotResult = new ScreenshotResultCallback() {

                @Override
                public void onScreenshotResult(ScreenshotResult screenshotResult) {
                    processScreenshot(screenshotResult, privateViews, latch, capturingCallback);

                }

                @Override
                public void onError() {
                    capturingCallback.onCapturingFailure(new Exception(EXCEPTION_MESSAGE));
                }
            };

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
                    pixelCopyScreenshotCaptor.takeScreenshot(activity, new ScreenshotResultCallback() {
                        @Override
                        public void onScreenshotResult(ScreenshotResult result) {
                            processScreenshot(result, privateViews, latch, capturingCallback);
                        }

                        @Override
                        public void onError() {
                            boundryScreenshotCaptor.takeScreenshot(activity, boundryScreenshotResult);

                        }
                    });
                } else {
                    boundryScreenshotCaptor.takeScreenshot(activity, boundryScreenshotResult);
                }

            } catch (Exception e) {
                capturingCallback.onCapturingFailure(e);
            }
        } else {
            capturingCallback.onCapturingFailure(new Exception(EXCEPTION_MESSAGE));
        }
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