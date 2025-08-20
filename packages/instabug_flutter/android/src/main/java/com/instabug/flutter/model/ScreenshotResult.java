package com.instabug.flutter.model;

import android.graphics.Bitmap;

public class ScreenshotResult {
    private final float pixelRatio;
    private final Bitmap screenshot;

    public ScreenshotResult(float pixelRatio, Bitmap screenshot) {
        this.pixelRatio = pixelRatio;
        this.screenshot = screenshot;
    }

    public Bitmap getScreenshot() {
        return screenshot;
    }

    public float getPixelRatio() {
        return pixelRatio;
    }
}
