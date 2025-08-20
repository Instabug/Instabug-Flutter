package com.instabug.flutter;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import com.instabug.library.logging.InstabugLog;
import com.instabug.flutter.generated.InstabugLogPigeon;
import com.instabug.flutter.modules.InstabugLogApi;
import com.instabug.flutter.util.GlobalMocks;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import io.flutter.plugin.common.BinaryMessenger;


public class InstabugLogApiTest {
    private final InstabugLogApi api = new InstabugLogApi();
    private MockedStatic<InstabugLog> mInstabugLog;
    private MockedStatic<InstabugLogPigeon.InstabugLogHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mInstabugLog = mockStatic(InstabugLog.class);
        mHostApi = mockStatic(InstabugLogPigeon.InstabugLogHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mInstabugLog.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        InstabugLogApi.init(messenger);

        mHostApi.verify(() -> InstabugLogPigeon.InstabugLogHostApi.setup(eq(messenger), any(InstabugLogApi.class)));
    }

    @Test
    public void testLogVerbose() {
        String message = "created an account";

        api.logVerbose(message);

        mInstabugLog.verify(() -> InstabugLog.v(message));
    }
    @Test
    public void testLogDebug() {
        String message = "created an account";

        api.logDebug(message);

        mInstabugLog.verify(() -> InstabugLog.d(message));
    }
    @Test
    public void testLogInfo() {
        String message = "created an account";

        api.logInfo(message);

        mInstabugLog.verify(() -> InstabugLog.i(message));
    }
    @Test
    public void testLogWarn() {
        String message = "created an account";

        api.logWarn(message);

        mInstabugLog.verify(() -> InstabugLog.w(message));
    }
    @Test
    public void testLogError() {
        String message = "something went wrong";

        api.logError(message);

        mInstabugLog.verify(() -> InstabugLog.e(message));
    }
    @Test
    public void testClearAllLogs() {
        api.clearAllLogs();

        mInstabugLog.verify(InstabugLog::clearLogs);
    }
}
