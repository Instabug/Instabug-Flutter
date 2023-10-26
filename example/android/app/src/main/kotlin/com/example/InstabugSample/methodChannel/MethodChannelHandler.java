package com.example.InstabugSample.methodChannel;

import androidx.annotation.NonNull;

import com.example.InstabugSample.nativeLibs.CppNativeLib;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;

public class MethodChannelHandler implements MethodChannel.MethodCallHandler {
    public void handle(MethodCall call, MethodChannel.Result result) {
        switch (call.method) {
            case SEND_NDK_CRASH_METHOD:
                CppNativeLib.crashNDK();
                break;
            default:
                result.notImplemented();
        }
    }

    static private final String SEND_NDK_CRASH_METHOD = "sendNDKCrash";

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        handle(call, result);
    }
}
