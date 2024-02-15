package com.instabug.flutter.example.util;

import static androidx.test.platform.app.InstrumentationRegistry.getInstrumentation;
import static org.junit.Assert.assertTrue;

import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiSelector;

public class InstabugAssertions {
    private static final UiDevice device = UiDevice.getInstance(getInstrumentation());

    public static UiObject assertViewWillBeVisible(String resourceId, long timeout) {
        UiObject view = device.findObject(new UiSelector().resourceIdMatches(".*:id/" + resourceId));
        boolean isDisplayed = view.waitForExists(timeout);
        assertTrue("View with ID " + resourceId + "didn't show up", isDisplayed);
        return view;
    }
}
