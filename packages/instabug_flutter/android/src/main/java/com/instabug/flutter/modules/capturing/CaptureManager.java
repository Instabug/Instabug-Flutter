package com.instabug.flutter.modules.capturing;

import android.app.Activity;

public interface CaptureManager {
    void capture(Activity activity, ScreenshotResultCallback screenshotResultCallback);
}
