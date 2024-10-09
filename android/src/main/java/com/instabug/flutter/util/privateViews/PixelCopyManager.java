package com.instabug.flutter.util.privateViews;

import android.graphics.Bitmap;

public interface PixelCopyManager {
    void onBitmap(com.instabug.flutter.util.privateViews.ScreenshotResult screenshotResult);
    void onError();
}
