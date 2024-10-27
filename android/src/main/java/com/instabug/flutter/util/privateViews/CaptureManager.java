package com.instabug.flutter.util.privateViews;

import android.app.Activity;

public interface CaptureManager {
    void capture(Activity activity, ScreenshotResultCallback screenshotResultCallback);
}
