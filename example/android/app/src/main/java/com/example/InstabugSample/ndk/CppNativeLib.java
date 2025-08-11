package com.example.InstabugSample.ndk;

import android.util.Log;

/**
 * C++ Native library bridge.
 */
public class CppNativeLib {

    static {
        System.loadLibrary("native-lib");
    }

    /**
     * Crashes the app with various signals from the C/C++ layer.
     */
    public static native void crashNDK();
    public static native void causeSIGSEGVCrash();
    public static native void causeSIGABRTCrash();
    public static native void causeSIGFPECrash();
    public static native void causeSIGILLCrash();
    public static native void causeSIGBUSCrash();
    public static native void causeSIGTRAPCrash();
}
