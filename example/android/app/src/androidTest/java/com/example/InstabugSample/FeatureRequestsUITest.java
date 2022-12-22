package com.example.InstabugSample;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.assertion.ViewAssertions.matches;
import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;

import androidx.test.espresso.flutter.action.FlutterActions;
import androidx.test.espresso.flutter.matcher.FlutterMatchers;
import androidx.test.espresso.matcher.ViewMatchers;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.rule.ActivityTestRule;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(AndroidJUnit4.class)
public class FeatureRequestsUITest {
    @Rule
    public ActivityTestRule<MainActivity> mActivityRule =
            new ActivityTestRule<>(MainActivity.class);

    @Test
    public void showFeatureRequestsScreen() {
        onFlutterWidget(FlutterMatchers.withText("Show Feature Requests"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());

        onView(ViewMatchers.withText("Feature Requests"))
                .check(matches(ViewMatchers.isDisplayed()));
    }
}
