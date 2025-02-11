package com.instabug.instabug_private_views.modules;

import android.app.Activity;
import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Paint;
import android.os.Build;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.instabug.flutter.util.ThreadManager;
import com.instabug.flutter.util.privateViews.ScreenshotCaptor;
import com.instabug.instabug_private_views.generated.InstabugPrivateViewPigeon;
import com.instabug.instabug_private_views.model.ScreenshotResult;
import com.instabug.instabug_private_views.modules.capturing.CaptureManager;
import com.instabug.instabug_private_views.modules.capturing.ScreenshotResultCallback;

import java.util.List;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import java.util.concurrent.atomic.AtomicReference;

public class PrivateViewManager {
    private static final String THREAD_NAME = "IBG-Flutter-Screenshot";
    public static final String EXCEPTION_MESSAGE = "IBG-Flutter-Screenshot: error capturing screenshot";

    private final ExecutorService screenshotExecutor = Executors.newSingleThreadExecutor(runnable -> {
        Thread thread = new Thread(runnable);
        thread.setName(THREAD_NAME);
        Log.v("IBG-FLT","screenshot executer on thread started");

        return thread;
    });

    private final InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi instabugPrivateViewApi;
    private Activity activity;
    final CaptureManager pixelCopyScreenshotCaptor;
    final CaptureManager boundryScreenshotCaptor;

    public PrivateViewManager(@NonNull InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi instabugPrivateViewApi, CaptureManager pixelCopyCaptureManager, CaptureManager boundryCaptureManager) {
        this.instabugPrivateViewApi = instabugPrivateViewApi;
        this.pixelCopyScreenshotCaptor = pixelCopyCaptureManager;
        this.boundryScreenshotCaptor = boundryCaptureManager;
        Log.v("IBG-FLT","instabugPrivateViewApi " + instabugPrivateViewApi);
        Log.v("IBG-FLT","pixelCopyCaptureManager " + pixelCopyCaptureManager);
        Log.v("IBG-FLT","boundryCaptureManager " + boundryCaptureManager);
    }

    public void setActivity(Activity activity) {
        this.activity = activity;
        Log.v("IBG-FLT","activity is set " + activity);

    }


    public void mask(ScreenshotCaptor.CapturingCallback capturingCallback) {
        if (activity != null) {
        Log.v("IBG-FLT","activity is not null while masking ");

            CountDownLatch latch = new CountDownLatch(1);
            AtomicReference<List<Double>> privateViews = new AtomicReference<>();
            final ScreenshotResultCallback boundryScreenshotResult = new ScreenshotResultCallback() {

                @Override
                public void onScreenshotResult(ScreenshotResult screenshotResult) {
                    processScreenshot(screenshotResult, privateViews, latch, capturingCallback);
                    Log.v("IBG-FLT","boundryScreenshotResult is" + screenshotResult);

                }

                @Override
                public void onError() {
                    capturingCallback.onCapturingFailure(new Exception(EXCEPTION_MESSAGE));
                    Log.v("IBG-FLT","Error occured in boundryScreenshotResult " + EXCEPTION_MESSAGE);
                }
            };

            try {
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        Log.v("IBG-FLT","getting private view");
                        instabugPrivateViewApi.getPrivateViews(result -> {
                            privateViews.set(result);
                            Log.v("IBG-FLT","private view is set to " + result);

                            latch.countDown();
                        });
                    }
                });


                // if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    // pixelCopyScreenshotCaptor.capture(activity, new ScreenshotResultCallback() {

                    //     @Override
                    //     public void onScreenshotResult(ScreenshotResult result) {
                    //        Log.v("IBG-FLT","screen capturing using pixelCopyScreenshotCaptor onScreenshotResult is " + result);

                    //         processScreenshot(result, privateViews, latch, capturingCallback);
                    //     }

                    //     @Override
                    //     public void onError() {
                    //         Log.v("IBG-FLT"," error occured while screen capturing using pixelCopyScreenshotCaptor");

                    //         boundryScreenshotCaptor.capture(activity, boundryScreenshotResult);

                    //     }
                    // });
                // } else {
                    Log.v("IBG-FLT","screen capturing using boundryScreenshotCaptor onScreenshotResult is " + boundryScreenshotResult);

                    boundryScreenshotCaptor.capture(activity, boundryScreenshotResult);
                // }

            } catch (Exception e) {
                Log.v("IBG-FLT"," error occured while running private views on the main thread: " + e);

                capturingCallback.onCapturingFailure(e);
            }
        } else {
            Log.v("IBG-FLT","Error occured activity is null while masking " + EXCEPTION_MESSAGE);
            capturingCallback.onCapturingFailure(new Exception(EXCEPTION_MESSAGE));
        }
    }


    private void processScreenshot(ScreenshotResult result, AtomicReference<List<Double>> privateViews, CountDownLatch latch, ScreenshotCaptor.CapturingCallback capturingCallback) {
        screenshotExecutor.execute(() -> {
            try {
                Log.v("IBG-FLT","processScreenshot has started...");
                latch.await();  // Wait
                Bitmap bitmap = result.getScreenshot();
                maskPrivateViews(result, privateViews.get());
                capturingCallback.onCapturingSuccess(bitmap);
            } catch (InterruptedException e) {
                Log.v("IBG-FLT","processScreenshot has failed..." + e);
                capturingCallback.onCapturingFailure(e);
            }
        });
    }

    @VisibleForTesting
    public void maskPrivateViews(ScreenshotResult result, List<Double> privateViews) {
        if (privateViews == null || privateViews.isEmpty()) {
            Log.v("IBG-FLT","private-Views is empty");

            return;
        }

        Bitmap bitmap = result.getScreenshot();
        float pixelRatio = result.getPixelRatio();
        Canvas canvas = new Canvas(bitmap);
        Paint paint = new Paint();  // Default color is black
        Log.v("IBG-FLT","maskPrivateViews result is " + result);

        for (int i = 0; i < privateViews.size(); i += 4) {
            float left = privateViews.get(i).floatValue() * pixelRatio;
            float top = privateViews.get(i + 1).floatValue() * pixelRatio;
            float right = privateViews.get(i + 2).floatValue() * pixelRatio;
            float bottom = privateViews.get(i + 3).floatValue() * pixelRatio;
            canvas.drawRect(left, top, right, bottom, paint);  // Mask private view
        }
    }
}
