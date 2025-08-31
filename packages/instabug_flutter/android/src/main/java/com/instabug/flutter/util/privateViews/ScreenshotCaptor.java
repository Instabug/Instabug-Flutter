package com.instabug.flutter.util.privateViews;

import android.graphics.Bitmap;

public interface ScreenshotCaptor {
    public  void capture(CapturingCallback listener);

    public interface CapturingCallback {
        public  void onCapturingFailure(Throwable throwable);

        public  void onCapturingSuccess(Bitmap bitmap);
    }
}