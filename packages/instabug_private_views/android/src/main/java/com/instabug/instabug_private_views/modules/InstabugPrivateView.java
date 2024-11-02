package com.instabug.instabug_private_views.modules;

import androidx.annotation.NonNull;

import com.instabug.instabug_private_views.generated.InstabugPrivateViewPigeon;
import com.instabug.library.internal.crossplatform.InternalCore;
import com.instabug.library.screenshot.ScreenshotCaptor;
import com.instabug.library.screenshot.instacapture.ScreenshotRequest;

import io.flutter.plugin.common.BinaryMessenger;

public class InstabugPrivateView implements InstabugPrivateViewPigeon.InstabugPrivateViewHostApi {
    PrivateViewManager privateViewManager;
    private final InternalCore internalCore;

    public InstabugPrivateView(BinaryMessenger messenger, PrivateViewManager privateViewManager, InternalCore internalCore) {
        this.privateViewManager = privateViewManager;
        this.internalCore = internalCore;
        InstabugPrivateViewPigeon.InstabugPrivateViewHostApi.setup(messenger, this);

    }

    @Override
    public void init() {
        internalCore._setScreenshotCaptor(new ScreenshotCaptor() {
            @Override
            public void capture(@NonNull ScreenshotRequest screenshotRequest) {
                privateViewManager.mask(screenshotRequest.getListener());
            }
        });
    }
}
