package com.instabug.flutter.util.privateViews;

import android.graphics.Bitmap;

public interface ScreenshotManager {
    void onSuccess(Bitmap bitmap);
    void onError();
}
