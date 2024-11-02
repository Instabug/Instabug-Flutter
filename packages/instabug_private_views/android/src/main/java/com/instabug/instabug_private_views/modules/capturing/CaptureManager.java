package com.instabug.instabug_private_views.modules.capturing;

import android.app.Activity;

public interface CaptureManager {
    void capture(Activity activity, ScreenshotResultCallback screenshotResultCallback);
}
