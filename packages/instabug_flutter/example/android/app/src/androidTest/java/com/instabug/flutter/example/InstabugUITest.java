package com.instabug.flutter.example;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;

import static com.instabug.flutter.example.util.InstabugViewMatchers.hasBackgroundColor;

import android.graphics.Color;

import androidx.test.espresso.flutter.action.FlutterActions;
import androidx.test.espresso.flutter.matcher.FlutterMatchers;
import androidx.test.espresso.matcher.ViewMatchers;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.rule.ActivityTestRule;

import com.instabug.flutter.example.util.Keyboard;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(AndroidJUnit4.class)
public class InstabugUITest {
    @Rule
    public ActivityTestRule<MainActivity> mActivityRule =
            new ActivityTestRule<>(MainActivity.class);

    @Test
    public void changePrimaryColor() {
        String color = "#FF0000";
        Color expected = Color.valueOf(0xFFFF0000);

        onFlutterWidget(FlutterMatchers.withText("Enter primary color"))
                .perform(FlutterActions.typeText(color));
        Keyboard.closeKeyboard();
        onFlutterWidget(FlutterMatchers.withText("Change Primary Color"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());
        onFlutterWidget(FlutterMatchers.withText("Floating Button"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());

        onView(ViewMatchers.withResourceName("instabug_floating_button"))
                .check(matches(hasBackgroundColor(expected)));
    }
}
