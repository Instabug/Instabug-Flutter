package com.instabug.flutter;

import static com.instabug.flutter.util.GlobalMocks.reflected;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import com.instabug.crash.CrashReporting;
import com.instabug.flutter.generated.CrashReportingPigeon;
import com.instabug.flutter.modules.CrashReportingApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.flutter.util.MockReflected;
import com.instabug.library.Feature;

import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import io.flutter.plugin.common.BinaryMessenger;


public class CrashReportingApiTest {
    private final CrashReportingApi mApi = new CrashReportingApi();
    private MockedStatic<CrashReporting> mCrashReporting;
    private MockedStatic<CrashReportingPigeon.CrashReportingHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mCrashReporting = mockStatic(CrashReporting.class);
        mHostApi = mockStatic(CrashReportingPigeon.CrashReportingHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mCrashReporting.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        CrashReportingApi.init(messenger);

        mHostApi.verify(() -> CrashReportingPigeon.CrashReportingHostApi.setup(eq(messenger), any(CrashReportingApi.class)));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        mApi.setEnabled(isEnabled);

        mCrashReporting.verify(() -> CrashReporting.setState(Feature.State.ENABLED));
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        mApi.setEnabled(isEnabled);

        mCrashReporting.verify(() -> CrashReporting.setState(Feature.State.DISABLED));
    }

    @Test
    public void testSend() {
        String jsonCrash = "{}";
        boolean isHandled = false;

        mApi.send(jsonCrash, isHandled);

        reflected.verify(() -> MockReflected.crashReportException(any(JSONObject.class), eq(isHandled)));
    }
}
