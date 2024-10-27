package com.instabug.flutter.util.privateViews;

import android.app.Activity;

public interface ScreenshotCaptor {
    void takeScreenshot(Activity activity,ScreenshotResultCallback screenshotResultCallback);
}
