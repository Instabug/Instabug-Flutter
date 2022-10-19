package com.instabug.flutter.modules;


import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.instabug.crash.CrashReporting;
import com.instabug.flutter.generated.CrashReportingPigeon;
import com.instabug.flutter.util.Reflection;
import com.instabug.library.Feature;

import org.json.JSONObject;

import java.lang.reflect.Method;

import io.flutter.plugin.common.BinaryMessenger;

public class CrashReportingApi implements CrashReportingPigeon.CrashReportingHostApi {
    private final String TAG = CrashReportingApi.class.getName();

    public CrashReportingApi(BinaryMessenger messenger) {
        CrashReportingPigeon.CrashReportingHostApi.setup(messenger, this);
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                if (isEnabled) {
                    CrashReporting.setState(Feature.State.ENABLED);
                } else {
                    CrashReporting.setState(Feature.State.DISABLED);
                }
            }
        });
    }

    @Override
    public void send(@NonNull String jsonCrash, @NonNull Boolean isHandled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    final JSONObject exceptionObject = new JSONObject(jsonCrash);
                    Method method = Reflection.getMethod(Class.forName("com.instabug.crash.CrashReporting"), "reportException",
                            JSONObject.class, boolean.class);
                    if (method != null) {
                        method.invoke(null, exceptionObject, isHandled);
                        Log.e(TAG, exceptionObject.toString());
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
}
