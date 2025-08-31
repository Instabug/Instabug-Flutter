package com.instabug.flutter.util.private_views;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.argThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.robolectric.Shadows.shadowOf;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Looper;

import com.instabug.flutter.model.ScreenshotResult;
import com.instabug.flutter.modules.capturing.BoundryCaptureManager;
import com.instabug.flutter.modules.capturing.CaptureManager;
import com.instabug.flutter.modules.capturing.ScreenshotResultCallback;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentMatcher;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import io.flutter.embedding.engine.renderer.FlutterRenderer;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {28}, manifest = Config.NONE)
public class BoundryScreenshotCaptorTest {
    private Activity activityMock;
    private Bitmap bitmap;
    private CaptureManager captureManager;

    @Before
    public void setUp() {
        FlutterRenderer rendererMock = mock(FlutterRenderer.class);
        activityMock = spy(Robolectric.buildActivity(Activity.class).setup().create().start().resume().get());
        bitmap = Bitmap.createBitmap(200, 200, Bitmap.Config.ARGB_8888);
        when(rendererMock.getBitmap()).thenReturn(bitmap);
        captureManager = new BoundryCaptureManager(rendererMock);
    }

    @Test
    public void testCaptureGivenEmptyActivity() {
        ScreenshotResultCallback mockCallback = mock(ScreenshotResultCallback.class);

        captureManager.capture(null, mockCallback);
        shadowOf(Looper.getMainLooper()).idle();

        verify(mockCallback).onError();
        verify(mockCallback, never()).onScreenshotResult(any(ScreenshotResult.class));

    }

    @Test
    public void testCapture() {
        ScreenshotResultCallback mockCallback = mock(ScreenshotResultCallback.class);
        captureManager.capture(activityMock, mockCallback);
        shadowOf(Looper.getMainLooper()).idle();

        verify(mockCallback, never()).onError();
        verify(mockCallback).onScreenshotResult(argThat(new ArgumentMatcher<ScreenshotResult>() {
            @Override
            public boolean matches(ScreenshotResult argument) {
                return (Math.abs(activityMock.getResources().getDisplayMetrics().density - argument.getPixelRatio()) < 0.01)&&
                bitmap == argument.getScreenshot();

            }
        }));
    }


}
