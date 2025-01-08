package com.instabug.instabug_private_views.modules.capturing;

import com.instabug.instabug_private_views.model.ScreenshotResult;

public interface ScreenshotResultCallback {
    void onScreenshotResult(ScreenshotResult screenshotResult);
    void onError();
}
