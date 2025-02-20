package com.instabug.instabug_private_views.modules;

import com.instabug.flutter.modules.InstabugApi;
import com.instabug.flutter.util.privateViews.ScreenshotCaptor;
import com.instabug.instabug_private_views.generated.InstabugPrivateViewPigeon;
import com.instabug.library.internal.crossplatform.InternalCore;

import io.flutter.plugin.common.BinaryMessenger;

public class InstabugPrivateView implements InstabugPrivateViewPigeon.InstabugPrivateViewHostApi {
    PrivateViewManager privateViewManager;

    public static void init(BinaryMessenger messenger, PrivateViewManager privateViewManager) {
        final InstabugPrivateView api = new InstabugPrivateView(messenger,privateViewManager);
        InstabugPrivateViewPigeon.InstabugPrivateViewHostApi.setup(messenger, api);
    }

    public InstabugPrivateView(BinaryMessenger messenger, PrivateViewManager privateViewManager) {
        this.privateViewManager = privateViewManager;
        InstabugPrivateViewPigeon.InstabugPrivateViewHostApi.setup(messenger, this);

    }

    @Override
    public void init() {
        InstabugApi.setScreenshotCaptor(new ScreenshotCaptor() {
            @Override
            public void capture(CapturingCallback listener) {
                privateViewManager.mask(listener);

            }
        },InternalCore.INSTANCE);
    }
}
