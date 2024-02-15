package com.instabug.flutter.example.util;

import android.graphics.Color;
import android.view.View;

import org.hamcrest.Matcher;

public class InstabugViewMatchers {
    public static Matcher<View> hasBackgroundColor(Color color) {
        return new HasBackgroundColorMatcher(color);
    }

    public static Matcher<View> isToTheLeft() {
        return new IsToTheLeftMatcher();
    }
}
