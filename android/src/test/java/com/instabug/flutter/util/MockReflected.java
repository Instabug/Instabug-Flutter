package com.instabug.flutter.util;

import android.graphics.Bitmap;

import androidx.annotation.Nullable;

import org.json.JSONObject;

/**
 * Includes fake implementations of methods called by reflection.
 * Used to verify whether or not a private methods was called.
 */
public class MockReflected {
    /**
     * Instabug.reportScreenChange
     */
    public static void reportScreenChange(Bitmap screenshot, String name) {}

    /**
     * Instabug.setCustomBrandingImage
     */
    public static void setCustomBrandingImage(Bitmap light, Bitmap dark) {}

    /**
     * Instabug.setCurrentPlatform
     */
    public static void setCurrentPlatform(int platform) {}

    /**
     * APMNetworkLogger.log
     */
    public static void apmNetworkLog(long requestStartTime, long requestDuration, String requestHeaders, String requestBody, long requestBodySize, String requestMethod, String requestUrl, String responseHeaders, String responseBody, String responseBodySize, long statusCode, int responseContentType, String errorMessage, String var18, @Nullable String gqlQueryName, @Nullable String serverErrorMessage) {}

    /**
     * CrashReporting.reportException
     */
    public static void crashReportException(JSONObject exception, boolean isHandled) {}
}
