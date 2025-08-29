package com.instabug.flutter.util.private_views;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.timeout;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.robolectric.Shadows.shadowOf;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Looper;
import android.view.SurfaceView;

import com.instabug.flutter.model.ScreenshotResult;
import com.instabug.flutter.modules.capturing.CaptureManager;
import com.instabug.flutter.modules.capturing.PixelCopyCaptureManager;
import com.instabug.flutter.modules.capturing.ScreenshotResultCallback;
import com.instabug.library.util.memory.MemoryUtils;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.MockedStatic;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.renderer.FlutterRenderer;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {28}, manifest = Config.NONE)
public class PixelCopyScreenshotCaptorTest {
    private Activity activityMock;
    private Bitmap bitmap;
    private CaptureManager captureManager;

    @Before
    public void setUp() {
        FlutterRenderer rendererMock = mock(FlutterRenderer.class);
        activityMock = spy(Robolectric.buildActivity(Activity.class).setup().create().start().resume().get());
        bitmap = Bitmap.createBitmap(200, 200, Bitmap.Config.ARGB_8888);
        when(rendererMock.getBitmap()).thenReturn(bitmap);
        captureManager = new PixelCopyCaptureManager();
    }

    @Test
    public void testCaptureWithPixelCopyGivenEmptyView() {

        ScreenshotResultCallback mockScreenshotResultCallback = mock(ScreenshotResultCallback.class);
        when(activityMock.findViewById(FlutterActivity.FLUTTER_VIEW_ID)).thenReturn(null);
        captureManager.capture(activityMock,mockScreenshotResultCallback);

        verify(mockScreenshotResultCallback).onError();
    }

    @Test
    public void testCaptureWithPixelCopy() {
        try (MockedStatic<MemoryUtils> mockedStatic = mockStatic(MemoryUtils.class)) {
            mockedStatic.when(() -> MemoryUtils.getFreeMemory(any())).thenReturn(Long.MAX_VALUE);

            mockFlutterViewInPixelCopy();

            ScreenshotResultCallback mockScreenshotResultCallback = mock(ScreenshotResultCallback.class);


            captureManager.capture(activityMock, mockScreenshotResultCallback);
            shadowOf(Looper.getMainLooper()).idle();

            verify(mockScreenshotResultCallback, timeout(1000)).onScreenshotResult(any(ScreenshotResult.class));  // PixelCopy success

        }
    }


    private void mockFlutterViewInPixelCopy() {

            SurfaceView mockSurfaceView = mock(SurfaceView.class);
            FlutterView flutterView = mock(FlutterView.class);
            when(flutterView.getChildAt(0)).thenReturn(mockSurfaceView);
            when(flutterView.getChildCount()).thenReturn(1);

            when(activityMock.findViewById(FlutterActivity.FLUTTER_VIEW_ID)).thenReturn(flutterView);
            when(mockSurfaceView.getWidth()).thenReturn(100);
            when(mockSurfaceView.getHeight()).thenReturn(100);
        }
}
