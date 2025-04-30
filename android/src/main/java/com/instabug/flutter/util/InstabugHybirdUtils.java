package com.instabug.flutter.util;

import android.app.Activity;
import android.content.Intent;

import com.instabug.flutter.InstabugFlutterPlugin;
import com.instabug.flutter.generated.InstabugFlutterPigeon;

public class InstabugHybirdUtils {

    public static void startFlutterScreen(Activity activity, Intent intent) {
        activity.startActivityForResult(intent, 1000);
        InstabugFlutterPlugin.instabugFlutterApi.reportLastScreenChange(new InstabugFlutterPigeon.InstabugFlutterApi.Reply<Void>() {
            @Override
            public void reply(Void reply) {

            }
        });

    }
}
