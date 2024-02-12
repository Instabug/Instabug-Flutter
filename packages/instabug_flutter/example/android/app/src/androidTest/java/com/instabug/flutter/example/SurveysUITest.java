package com.instabug.flutter.example;

import static androidx.test.espresso.flutter.EspressoFlutter.onFlutterWidget;

import static com.instabug.flutter.example.util.InstabugAssertions.assertViewWillBeVisible;

import androidx.test.espresso.flutter.action.FlutterActions;
import androidx.test.espresso.flutter.matcher.FlutterMatchers;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.rule.ActivityTestRule;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;


@RunWith(AndroidJUnit4.class)
public class SurveysUITest {
    @Rule
    public ActivityTestRule<MainActivity> mActivityRule =
            new ActivityTestRule<>(MainActivity.class);

    @Test
    public void showManualSurvey() {
        onFlutterWidget(FlutterMatchers.withText("Show Manual Survey"))
                .perform(FlutterActions.scrollTo(), FlutterActions.click());

        assertViewWillBeVisible("instabug_survey_dialog_container", 2000);
    }
}
