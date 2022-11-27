package com.instabug.flutter.util;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mockStatic;

import android.util.Log;

import org.mockito.MockedStatic;
import org.mockito.invocation.InvocationOnMock;

public class GlobalMocks {
    public static MockedStatic<ThreadManager> threadManager;
    public static MockedStatic<Log> log;

    public static void setUp() {
        log = mockStatic(Log.class);
        threadManager = mockStatic(ThreadManager.class);
        threadManager
                .when(() -> ThreadManager.runOnBackground(any(Runnable.class)))
                .thenAnswer((InvocationOnMock invocation) -> {
                    Runnable runnable = invocation.getArgument(0);
                    runnable.run();
                    return null;
                });
    }

    public static void close() {
        threadManager.close();
        log.close();
    }
}
