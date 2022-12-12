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

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.assertion.ViewAssertions.doesNotExist;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;
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
        onFlutterWidget(FlutterMatchers.withText("Floating Button")).perform(FlutterActions.click());
        onView(ViewMatchers.withResourceName("instabug_floating_button")).perform(ViewActions.click());

        assertOptionsPromptIsVisible();
    }

    @Test
    public void twoFingersSwipeLeftInvocationEvent() throws InterruptedException {
        onFlutterWidget(FlutterMatchers.withText("Two Fingers Swipe Left"))
                .perform(FlutterActions.click());

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
        onFlutterWidget(FlutterMatchers.withText("None")).perform(FlutterActions.click());

        onView(ViewMatchers.withResourceName("instabug_floating_button")).check(doesNotExist());
    }

    @Test
    public void manualInvocation() {
        onFlutterWidget(FlutterMatchers.withText("Invoke")).perform(FlutterActions.click());

        assertOptionsPromptIsVisible();
    }

    @Test
    public void multipleScreenshotsInReproSteps() throws InterruptedException {
        String screen = "Orders";

        onFlutterWidget(FlutterMatchers.withText("Enter screen name"))
                .perform(FlutterActions.typeText(screen));
        onFlutterWidget(FlutterMatchers.withText("Report Screen Change"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onFlutterWidget(FlutterMatchers.withText("Send Bug Report"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onView(ViewMatchers.withResourceName("instabug_text_view_repro_steps_disclaimer"))
                .perform(ViewActions.click());

        Thread.sleep(2000);

        onView(ViewMatchers.withResourceName("instabug_vus_list"))
                .check(matches(ViewMatchers.hasMinimumChildCount(2)));
        onView(ViewMatchers.withText(screen)).check(matches(ViewMatchers.isDisplayed()));
    }

    private void assertOptionsPromptIsVisible() {
        onView(ViewMatchers.withResourceName("instabug_main_prompt_container"))
                .check(matches(ViewMatchers.isDisplayed()));
    }
}

