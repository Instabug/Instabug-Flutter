package com.example.InstabugSample;

import androidx.test.espresso.action.ViewActions;
import androidx.test.espresso.flutter.action.FlutterActions;
import androidx.test.espresso.flutter.matcher.FlutterMatchers;
import androidx.test.espresso.matcher.ViewMatchers;
import androidx.test.rule.ActivityTestRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiSelector;

import org.jetbrains.annotations.TestOnly;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.assertion.ViewAssertions.doesNotExist;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;
import static androidx.test.espresso.flutter.matcher.FlutterMatchers.withText;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.withResourceName;
import static androidx.test.platform.app.InstrumentationRegistry.getInstrumentation;

import android.app.Instrumentation;
import android.graphics.Point;

@RunWith(AndroidJUnit4.class)
public class BugReportingUITest {
    Instrumentation instrumentation = getInstrumentation();
    UiDevice device = UiDevice.getInstance(instrumentation);

    @Rule
    public ActivityTestRule<MainActivity> mActivityRule =
            new ActivityTestRule<>(MainActivity.class);

    @Test
    public void floatingButtonInvocationEvent() {
        onFlutterWidget(withText("Floating Button")).perform(FlutterActions.click());
        onView(withResourceName("instabug_floating_button")).perform(ViewActions.click());

        assertOptionsPromptIsVisible();
    }

    @Test
    public void twoFingersSwipeLeftInvocationEvent() throws InterruptedException {
        onFlutterWidget(withText("Two Fingers Swipe Left")).perform(FlutterActions.click());

        // Two-fingers swipe left
        UiObject text = device.findObject(new UiSelector().textContains("Hello"));
        int width = device.getDisplayWidth();
        text.performTwoPointerGesture(
                new Point(width - 50, 100),
                new Point(width - 50, 130),
                new Point(50, 100),
                new Point(50, 130),
                // Small steps number for fast swiping
                20
        );

        Thread.sleep(1000);

        assertOptionsPromptIsVisible();
    }

    @Test
    public void noneInvocationEvent() {
        onFlutterWidget(withText("None")).perform(FlutterActions.click());

        onView(withResourceName("instabug_floating_button")).check(doesNotExist());
    }

    @Test
    public void manualInvocation() {
        onFlutterWidget(withText("Invoke")).perform(FlutterActions.click());

        assertOptionsPromptIsVisible();
    }

    private void assertOptionsPromptIsVisible() {
        onView(withResourceName("instabug_main_prompt_container"))
                .check(matches(isDisplayed()));
    }
}

