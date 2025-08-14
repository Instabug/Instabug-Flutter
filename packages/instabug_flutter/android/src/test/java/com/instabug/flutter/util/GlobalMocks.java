package com.instabug.flutter.util;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import android.graphics.Bitmap;
import android.net.Uri;
import android.util.Log;

import com.instabug.apm.networkinterception.cp.APMCPNetworkLog;
import com.instabug.crash.models.IBGNonFatalException;

import org.json.JSONObject;
import org.mockito.MockedStatic;
import org.mockito.invocation.InvocationOnMock;
import org.mockito.stubbing.Answer;

import java.lang.reflect.Method;
import java.util.Map;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

public class GlobalMocks {
    public static MockedStatic<ThreadManager> threadManager;
    public static MockedStatic<Log> log;
    public static MockedStatic<Uri> uri;
    private static MockedStatic<Reflection> reflection;
    public static MockedStatic<MockReflected> reflected;

    public static void setUp() throws NoSuchMethodException {
        log = mockStatic(Log.class);

        // ThreadManager mock
        threadManager = mockStatic(ThreadManager.class);
        Answer threadAnswer = (InvocationOnMock invocation) -> {
            Runnable runnable = invocation.getArgument(0);
            runnable.run();
            return null;
        };
        threadManager
                .when(() -> ThreadManager.runOnBackground(any(Runnable.class)))
                .thenAnswer(threadAnswer);
        threadManager
                .when(() -> ThreadManager.runOnMainThread(any(Runnable.class)))
                .thenAnswer(threadAnswer);

        // Reflection mock
        reflection = mockStatic(Reflection.class);
        reflected = mockStatic(MockReflected.class);
        Method mReportScreenChange = MockReflected.class.getDeclaredMethod("reportScreenChange", Bitmap.class, String.class);
        mReportScreenChange.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "reportScreenChange",
                        Bitmap.class, String.class))
                .thenReturn(mReportScreenChange);

        Method mReportCurrentViewChange= MockReflected.class.getDeclaredMethod("reportCurrentViewChange", String.class);
        mReportCurrentViewChange.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "reportCurrentViewChange",
                       String.class))
                .thenReturn(mReportCurrentViewChange);

        Method mSetCustomBrandingImage = MockReflected.class.getDeclaredMethod("setCustomBrandingImage", Bitmap.class, Bitmap.class);
        mSetCustomBrandingImage.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "setCustomBrandingImage",
                        Bitmap.class, Bitmap.class))
                .thenReturn(mSetCustomBrandingImage);

        Method mSetCurrentPlatform = MockReflected.class.getDeclaredMethod("setCurrentPlatform", int.class);
        mSetCurrentPlatform.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "setCurrentPlatform", int.class))
                .thenReturn(mSetCurrentPlatform);

        Method mAPMNetworkLog = MockReflected.class.getDeclaredMethod("apmNetworkLog", long.class, long.class, String.class, String.class, long.class, String.class, String.class, String.class, String.class, String.class, long.class, int.class, String.class, String.class, String.class, String.class, APMCPNetworkLog.W3CExternalTraceAttributes.class);
        mAPMNetworkLog.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.apm.networking.APMNetworkLogger"), "log", long.class, long.class, String.class, String.class, long.class, String.class, String.class, String.class, String.class, String.class, long.class, int.class, String.class, String.class, String.class, String.class, APMCPNetworkLog.W3CExternalTraceAttributes.class))
                .thenReturn(mAPMNetworkLog);

        Method mCrashReportException = MockReflected.class.getDeclaredMethod("crashReportException", JSONObject.class, boolean.class);
        mCrashReportException.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.crash.CrashReporting"), "reportException",
                        JSONObject.class, boolean.class))
                .thenReturn(mCrashReportException);

        Method mCrashReportNonFatalException = MockReflected.class.getDeclaredMethod("crashReportException", JSONObject.class, boolean.class,
                Map.class, JSONObject.class, IBGNonFatalException.Level.class);
        mCrashReportNonFatalException.setAccessible(true);
        reflection
                .when(() -> Reflection.getMethod(Class.forName("com.instabug.crash.CrashReporting"), "reportException",
                        JSONObject.class, boolean.class,
                        Map.class, JSONObject.class, IBGNonFatalException.Level.class))
                .thenReturn(mCrashReportNonFatalException);

        uri = mockStatic(Uri.class);
        uri.when(() -> Uri.fromFile(any())).thenReturn(mock(Uri.class));

        Method mStartUiTraceCP = MockReflected.class.getDeclaredMethod("startUiTraceCP", String.class, Long.class, Long.class);
        mStartUiTraceCP.setAccessible(true);
        reflection.when(() -> Reflection.getMethod(Class.forName("com.instabug.apm.APM"), "startUiTraceCP", String.class, Long.class, Long.class)).thenReturn(mStartUiTraceCP);

        Method mReportScreenLoadingCP = MockReflected.class.getDeclaredMethod("reportScreenLoadingCP", Long.class, Long.class, Long.class);
        mReportScreenLoadingCP.setAccessible(true);
        reflection.when(() -> Reflection.getMethod(Class.forName("com.instabug.apm.APM"), "reportScreenLoadingCP", Long.class, Long.class, Long.class)).thenReturn(mReportScreenLoadingCP);

        Method mEndScreenLoadingCP = MockReflected.class.getDeclaredMethod("endScreenLoadingCP", Long.class, Long.class);
        mEndScreenLoadingCP.setAccessible(true);
        reflection.when(() -> Reflection.getMethod(Class.forName("com.instabug.apm.APM"), "endScreenLoadingCP", Long.class, Long.class)).thenReturn(mEndScreenLoadingCP);


        Method mAddUserStepCp = MockReflected.class.getDeclaredMethod("addUserStep",
                long.class, String.class, String.class, String.class, String.class);
        mAddUserStepCp.setAccessible(true);
        reflection.when(() -> Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "addUserStep",
                long.class, String.class, String.class, String.class, String.class)).thenReturn(mAddUserStepCp);;

    }

    public static void close() {
        threadManager.close();
        log.close();
        uri.close();
        reflection.close();
        reflected.close();
    }
}
