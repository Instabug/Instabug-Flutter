package com.example.InstabugSample;

import androidx.test.espresso.action.ViewActions;
import androidx.test.espresso.flutter.action.FlutterActions;
import androidx.test.espresso.flutter.assertion.FlutterAssertions;
import androidx.test.espresso.flutter.matcher.FlutterMatchers;
import androidx.test.espresso.matcher.ViewMatchers;
import androidx.test.rule.ActivityTestRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiObjectNotFoundException;
import androidx.test.uiautomator.UiSelector;

import org.junit.Before;
import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.assertion.ViewAssertions.doesNotExist;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;
import static androidx.test.platform.app.InstrumentationRegistry.getInstrumentation;

import static com.example.InstabugSample.util.InstabugAssertions.assertViewWillBeVisible;
import static com.example.InstabugSample.util.InstabugViewMatchers.isToTheLeft;

import static org.junit.Assert.assertTrue;

import android.app.Instrumentation;
import android.graphics.Point;

import com.example.InstabugSample.util.Keyboard;

@RunWith(AndroidJUnit4.class)
public class BugReportingUITest {
    Instrumentation instrumentation = getInstrumentation();
    UiDevice device = UiDevice.getInstance(instrumentation);

    @Rule
    public ActivityTestRule<MainActivity> mActivityRule =
            new ActivityTestRule<>(MainActivity.class);

    @Before
    public void setUp() {
        onFlutterWidget(FlutterMatchers.withText("Restart Instabug"))
                .perform(FlutterActions.click());
    }

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
    public void multipleScreenshotsInReproSteps() throws InterruptedException, UiObjectNotFoundException {
        String screen = "My Screen";

        onFlutterWidget(FlutterMatchers.withText("Enter screen name"))
                .perform(FlutterActions.scrollTo(), FlutterActions.typeText(screen));
        Thread.sleep(1000);
        Keyboard.closeKeyboard();
        onFlutterWidget(FlutterMatchers.withText("Report Screen Change"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click(), FlutterActions.click());
        onFlutterWidget(FlutterMatchers.withText("Send Bug Report"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        UiObject reproStepsDisclaimer = assertViewWillBeVisible("instabug_text_view_repro_steps_disclaimer", 2000);
        reproStepsDisclaimer.click();

        String screenshotsListId = "instabug_vus_list";
        assertViewWillBeVisible(screenshotsListId, 5000);
        onView(ViewMatchers.withResourceName(screenshotsListId))
                .check(matches(ViewMatchers.hasChildCount(2)));
    }

    @Test
    public void onDismissCallbackIsCalled() throws InterruptedException {
        onFlutterWidget(FlutterMatchers.withText("Set On Dismiss Callback"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());

        onFlutterWidget(FlutterMatchers.withText("Invoke"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        Thread.sleep(1000);
        device.pressBack();

        Thread.sleep(1000);

        onFlutterWidget(FlutterMatchers.withText("onDismiss callback called with DismissType.cancel and ReportType.other"))
                .check(FlutterAssertions.matches(FlutterMatchers.isExisting()));
    }

    @Test
    public void changeReportTypes() throws UiObjectNotFoundException {
        onFlutterWidget(FlutterMatchers.withText("Bug"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onFlutterWidget(FlutterMatchers.withText("Invoke"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());

        // Shows bug reporting screen
        assertViewWillBeVisible("instabug_edit_text_message", 2000);

        // Close bug reporting screen
        device.pressBack();
        device.findObject(new UiSelector().text("DISCARD")).click();

        // Enable feedback reports
        onFlutterWidget(FlutterMatchers.withText("Feedback"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onFlutterWidget(FlutterMatchers.withText("Invoke"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());

        // Shows both bug reporting and feature requests in prompt options
        assertOptionsPromptIsVisible();
        onView(ViewMatchers.withText("Report a bug"))
                .check(matches(ViewMatchers.isDisplayed()));
        onView(ViewMatchers.withText("Suggest an improvement"))
                .check(matches(ViewMatchers.isDisplayed()));
        onView(ViewMatchers.withText("Ask a question"))
                .check(doesNotExist());
    }

    @Test
    public void changeFloatingButtonEdge() {
        onFlutterWidget(FlutterMatchers.withText("Floating Button"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onFlutterWidget(FlutterMatchers.withText("Move Floating Button to Left"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onView(ViewMatchers.withResourceName("instabug_floating_button"))
                .check(matches(isToTheLeft()));
    }

    private void assertOptionsPromptIsVisible() {
        assertViewWillBeVisible("instabug_main_prompt_container", 2000);
    }
}

