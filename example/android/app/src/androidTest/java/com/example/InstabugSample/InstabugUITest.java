package com.example.InstabugSample;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;
import static androidx.test.espresso.flutter.action.FlutterActions.click;
import static androidx.test.espresso.flutter.action.FlutterActions.scrollTo;
import static androidx.test.espresso.flutter.matcher.FlutterMatchers.withText;
import static androidx.test.espresso.flutter.action.FlutterActions.typeText;
import static androidx.test.espresso.matcher.ViewMatchers.withResourceName;

import static com.example.InstabugSample.util.InstabugViewMatchers.hasBackgroundColor;

import android.graphics.Color;

import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.rule.ActivityTestRule;

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

        onFlutterWidget(withText("Enter primary color")).perform(typeText(color));
        onFlutterWidget(withText("Change Primary Color")).perform(scrollTo(), click());
        onFlutterWidget(withText("Floating Button")).perform(scrollTo(), click());

        onView(withResourceName("instabug_floating_button"))
                .check(matches(hasBackgroundColor(expected)));
    }
}
