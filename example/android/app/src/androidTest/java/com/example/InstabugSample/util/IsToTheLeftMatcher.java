package com.example.InstabugSample.util;

import android.view.View;

import org.hamcrest.Description;
import org.hamcrest.TypeSafeMatcher;

public final class IsToTheLeftMatcher extends TypeSafeMatcher<View> {
    @Override
    protected boolean matchesSafely(View view) {
        return view.getRight() > view.getLeft();
    }

    @Override
    public void describeTo(Description description) {
        description.appendText("is to the left");
    }
}