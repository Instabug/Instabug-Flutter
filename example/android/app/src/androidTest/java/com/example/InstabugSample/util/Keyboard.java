package com.example.InstabugSample.util;

import static androidx.test.platform.app.InstrumentationRegistry.getInstrumentation;

import android.app.Instrumentation;
import android.view.accessibility.AccessibilityWindowInfo;

import androidx.test.uiautomator.UiDevice;

public class Keyboard {
    private static final Instrumentation instrumentation = getInstrumentation();
    private static final UiDevice device = UiDevice.getInstance(instrumentation);

    public static void closeKeyboard() {
        if (isKeyboardOpened()) {
            device.pressBack();
        }
    }

    private static boolean isKeyboardOpened() {
        for (AccessibilityWindowInfo window : instrumentation.getUiAutomation().getWindows()) {
            if (window.getType() == AccessibilityWindowInfo.TYPE_INPUT_METHOD) {
                return true;
            }
        }
        return false;
    }
}
