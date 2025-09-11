package com.instabug.flutter.modules;

import android.os.Handler;
import android.os.Looper;

import com.instabug.flutter.generated.InstabugPrivateViewPigeon;
import com.instabug.flutter.util.privateViews.ScreenshotCaptor;
import com.instabug.library.internal.crossplatform.InternalCore;

import io.flutter.plugin.common.BinaryMessenger;

public class InstabugPrivateView implements InstabugPrivateViewPigeon.InstabugPrivateViewHostApi {
    PrivateViewManager privateViewManager;

    public static void init(BinaryMessenger messenger, PrivateViewManager privateViewManager) {
        final InstabugPrivateView api = new InstabugPrivateView(messenger, privateViewManager);
        InstabugPrivateViewPigeon.InstabugPrivateViewHostApi.setup(messenger, api);
    }

    public InstabugPrivateView(BinaryMessenger messenger, PrivateViewManager privateViewManager) {
        this.privateViewManager = privateViewManager;
        InstabugPrivateViewPigeon.InstabugPrivateViewHostApi.setup(messenger, this);
    }

    static long time = System.currentTimeMillis();

    @Override
    public void init() {
        InstabugApi.setScreenshotCaptor(new ScreenshotCaptor() {
            @Override
            public void capture(CapturingCallback listener) {

                (new Handler(Looper.getMainLooper())).postDelayed(new Runnable() {
                    @Override
                    public void run() {
                        time = System.currentTimeMillis();
                        privateViewManager.mask(listener);

                    }
                }, 300);


            }
        }, InternalCore.INSTANCE);
    }
}
