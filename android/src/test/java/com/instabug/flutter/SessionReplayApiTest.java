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
    public void testSetEnabled() {
        boolean isEnabled = true;

        api.setEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setEnabled(true));
    }

    @Test
    public void testSetNetworkLogsEnabled() {
        boolean isEnabled = true;

        api.setNetworkLogsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setNetworkLogsEnabled(true));
    }

    @Test
    public void testSetInstabugLogsEnabled() {
        boolean isEnabled = true;

        api.setInstabugLogsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setIBGLogsEnabled(true));
    }

    @Test
    public void testSetUserStepsEnabled() {
        boolean isEnabled = true;

        api.setUserStepsEnabled(isEnabled);

        mSessionReplay.verify(() -> SessionReplay.setUserStepsEnabled(true));
    }

}

