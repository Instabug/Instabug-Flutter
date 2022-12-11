package com.example.InstabugSample.util;

import android.graphics.Bitmap;
import android.graphics.Canvas;
import android.graphics.Color;
import android.view.View;

import org.hamcrest.Description;
import org.hamcrest.TypeSafeMatcher;

public final class HasBackgroundColorMatcher extends TypeSafeMatcher<View> {

    private final Color color;

    public HasBackgroundColorMatcher(Color color) {
        this.color = color;
    }

    @Override
    protected boolean matchesSafely(View view) {
        int width = view.getWidth();
        int height = view.getHeight();
        Bitmap bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        view.getBackground().draw(canvas);
        return bitmap.getColor(width / 2, height / 2).equals(color);
    }

    @Override
    public void describeTo(Description description) {
        description.appendText("has background with color: " + color);
    }
}