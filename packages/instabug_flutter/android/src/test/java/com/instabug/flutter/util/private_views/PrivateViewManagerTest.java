package com.instabug.flutter.util.private_views;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doAnswer;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.never;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.timeout;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;
import static org.robolectric.Shadows.shadowOf;

import android.app.Activity;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Looper;
import android.view.SurfaceView;

import com.instabug.flutter.generated.InstabugPrivateViewPigeon;
import com.instabug.flutter.model.ScreenshotResult;
import com.instabug.flutter.modules.PrivateViewManager;
import com.instabug.flutter.modules.capturing.BoundryCaptureManager;
import com.instabug.flutter.modules.capturing.CaptureManager;
import com.instabug.flutter.modules.capturing.PixelCopyCaptureManager;
import com.instabug.flutter.util.privateViews.ScreenshotCaptor;

import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.mockito.ArgumentCaptor;
import org.robolectric.Robolectric;
import org.robolectric.RobolectricTestRunner;
import org.robolectric.annotation.Config;

import java.util.Arrays;
import java.util.List;

import io.flutter.embedding.android.FlutterActivity;
import io.flutter.embedding.android.FlutterView;
import io.flutter.embedding.engine.renderer.FlutterRenderer;

@RunWith(RobolectricTestRunner.class)
@Config(sdk = {28}, manifest = Config.NONE)
public class PrivateViewManagerTest {

    private PrivateViewManager privateViewManager;
    private InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi InstabugPrivateViewFlutterApiMock;
    private Activity activityMock;
    private Bitmap bitmap;
    private CaptureManager pixelCopyScreenCaptor, boundryScreenCaptor;

    @Before
    public void setUp() {
        InstabugPrivateViewFlutterApiMock = mock(InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi.class);
        FlutterRenderer rendererMock = mock(FlutterRenderer.class);
        activityMock = spy(Robolectric.buildActivity(Activity.class).setup().create().start().resume().get());
        bitmap = Bitmap.createBitmap(200, 200, Bitmap.Config.ARGB_8888);
        when(rendererMock.getBitmap()).thenReturn(bitmap);
        pixelCopyScreenCaptor = spy(new PixelCopyCaptureManager());
        boundryScreenCaptor = spy(new BoundryCaptureManager(rendererMock));
        privateViewManager = spy(new PrivateViewManager(InstabugPrivateViewFlutterApiMock, pixelCopyScreenCaptor, boundryScreenCaptor));
        privateViewManager.setActivity(activityMock);

    }


    @Test
    public void testMaskGivenEmptyActivity() {
        com.instabug.flutter.util.privateViews.ScreenshotCaptor.CapturingCallback capturingCallbackMock = mock(ScreenshotCaptor.CapturingCallback.class);
        privateViewManager.setActivity(null);
        privateViewManager.mask(capturingCallbackMock);
        ArgumentCaptor<Throwable> argumentCaptor = ArgumentCaptor.forClass(Throwable.class);
        verify(capturingCallbackMock).onCapturingFailure(argumentCaptor.capture());
        assertEquals( PrivateViewManager.EXCEPTION_MESSAGE, argumentCaptor.getValue().getMessage());
    }

    @Test
    public void testMask() throws InterruptedException {
        com.instabug.flutter.util.privateViews.ScreenshotCaptor.CapturingCallback capturingCallbackMock = mock(com.instabug.flutter.util.privateViews.ScreenshotCaptor.CapturingCallback.class);
        doAnswer(invocation -> {
            InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi.Reply<List<Double>> callback = invocation.getArgument(0);  // Get the callback
            callback.reply(Arrays.asList(10.0, 20.0, 100.0, 200.0));  // Trigger the success callback
            return null;
        }).when(InstabugPrivateViewFlutterApiMock).getPrivateViews(any(InstabugPrivateViewPigeon.InstabugPrivateViewFlutterApi.Reply.class));  // Mock the method call


        // Trigger the mask operation
        privateViewManager.mask(capturingCallbackMock);
        // Mock that latch.await() has been called
        shadowOf(Looper.getMainLooper()).idle();

        // Simulate a successful bitmap capture
        verify(capturingCallbackMock, timeout(1000)).onCapturingSuccess(bitmap);
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


    @Test
    public void testMaskPrivateViews() {
        ScreenshotResult mockResult = mock(ScreenshotResult.class);
        when(mockResult.getScreenshot()).thenReturn(Bitmap.createBitmap(200, 200, Bitmap.Config.ARGB_8888));
        when(mockResult.getPixelRatio()).thenReturn(2.0f);

        List<Double> privateViews = Arrays.asList(10.0, 20.0, 100.0, 200.0);

        privateViewManager.maskPrivateViews(mockResult, privateViews);

        assertNotNull(mockResult.getScreenshot());
    }

    @Test
    @Config(sdk = {Build.VERSION_CODES.M})
    public void testMaskShouldGetScreenshotWhenAPIVersionLessThan28() {
        ScreenshotCaptor.CapturingCallback capturingCallbackMock = mock(ScreenshotCaptor.CapturingCallback.class);
        privateViewManager.mask(capturingCallbackMock);
        shadowOf(Looper.getMainLooper()).idle();

        verify(boundryScreenCaptor).capture(any(), any());

    }

    @Test
    public void testMaskShouldCallPixelCopyWhenAPIVersionMoreThan28() {
        com.instabug.flutter.util.privateViews.ScreenshotCaptor.CapturingCallback capturingCallbackMock = mock(com.instabug.flutter.util.privateViews.ScreenshotCaptor.CapturingCallback.class);
        mockFlutterViewInPixelCopy();
        privateViewManager.mask(capturingCallbackMock);
        shadowOf(Looper.getMainLooper()).idle();
        verify(boundryScreenCaptor, never()).capture(any(), any());
        verify(pixelCopyScreenCaptor).capture(any(), any());


    }
}