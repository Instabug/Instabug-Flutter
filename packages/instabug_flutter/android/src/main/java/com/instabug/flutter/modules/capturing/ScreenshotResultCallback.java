package com.instabug.flutter.modules.capturing;


import com.instabug.flutter.model.ScreenshotResult;

public interface ScreenshotResultCallback {
    void onScreenshotResult(ScreenshotResult screenshotResult);
    void onError();
}
