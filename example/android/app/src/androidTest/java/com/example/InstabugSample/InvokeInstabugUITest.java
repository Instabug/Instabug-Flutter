package com.example.InstabugSample;

import androidx.test.rule.ActivityTestRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.uiautomator.UiDevice;
import androidx.test.uiautomator.UiObject;
import androidx.test.uiautomator.UiSelector;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.action.ViewActions.replaceText;
import static androidx.test.espresso.matcher.ViewMatchers.withParent;
import static androidx.test.espresso.matcher.ViewMatchers.withResourceName;
import static androidx.test.espresso.matcher.ViewMatchers.withText;
import static androidx.test.platform.app.InstrumentationRegistry.getInstrumentation;
import static org.hamcrest.Matchers.allOf;

@RunWith(AndroidJUnit4.class)
public class InvokeInstabugUITest {
    UiDevice device = UiDevice.getInstance(getInstrumentation());

    @Rule
    public ActivityTestRule<MainActivity> mActivityRule =
            new ActivityTestRule<>(MainActivity.class);

    @Test
    public void ensureInstabugInvocation() throws InterruptedException {
        Thread.sleep(1000);
        onView(withResourceName("instabug_floating_button")).perform(click());
        Thread.sleep(1000);

        // Dismiss media projection prompt.
        // This is a temporary solution as we are dropping media projection in a future release.
        device.pressBack();
        Thread.sleep(1000);

        onView(withText("Report a bug")).perform(click());
        Thread.sleep(1000);

        onView(
                allOf(
                        withResourceName("ib_edit_text"),
                        withParent(withResourceName("instabug_edit_text_email"))
                )
        ).perform(replaceText("inst@bug.com"));

        onView(withResourceName("instabug_bugreporting_send")).perform(click());

        UiObject successDialog = device.findObject(new UiSelector().resourceIdMatches(".*/id:instabug_success_dialog_container"));
        successDialog.waitForExists(3000);
    }
}

