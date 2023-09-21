package com.instabug.flutter;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;

import com.instabug.flutter.generated.SessionReplayPigeon;
import com.instabug.flutter.modules.SessionReplayApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.library.sessionreplay.SessionReplay;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import io.flutter.plugin.common.BinaryMessenger;


public class SessionReplayApiTest {
    private final SessionReplayApi api = new SessionReplayApi();
    private MockedStatic<SessionReplay> mSessionReplay;
    private MockedStatic<SessionReplayPigeon.SessionReplayHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mSessionReplay = mockStatic(SessionReplay.class);
        mHostApi = mockStatic(SessionReplayPigeon.SessionReplayHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mSessionReplay.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        SessionReplayApi.init(messenger);

        mHostApi.verify(() -> SessionReplayPigeon.SessionReplayHostApi.setup(eq(messenger), any(SessionReplayApi.class)));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setEnabled(true));
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setEnabled(false));
    }

    @Test
    public void testSetNetworkLogsEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setNetworkLogsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setNetworkLogsEnabled(true));
    }

    @Test
    public void testSetNetworkLogsEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setNetworkLogsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setNetworkLogsEnabled(false));
    }

    @Test
    public void testSetInstabugLogsEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setInstabugLogsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setIBGLogsEnabled(true));
    }

    @Test
    public void testSetInstabugLogsEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setInstabugLogsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setIBGLogsEnabled(false));
    }

    @Test
    public void testSetUserStepsEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setUserStepsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setUserStepsEnabled(true));
    }

    @Test
    public void testSetUserStepsEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setUserStepsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setUserStepsEnabled(false));
    }

}

