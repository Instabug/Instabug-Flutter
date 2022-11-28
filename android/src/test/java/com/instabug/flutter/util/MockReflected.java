package com.instabug.flutter.util;

import android.graphics.Bitmap;

/**
 * Includes fake implementations of methods called by reflection.
 * Used to verify whether or not a private methods was called.
 */
public class MockReflected {
    public static void reportScreenChange(Bitmap screenshot, String name) {}
    public static void setCustomBrandingImage(Bitmap light, Bitmap dark) {}
    public static void setCurrentPlatform(int platform) {}
}
