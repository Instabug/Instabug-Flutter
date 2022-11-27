package com.instabug.flutter;

import static com.instabug.flutter.util.MockResult.makeResult;
import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;

import com.instabug.apm.APM;
import com.instabug.apm.model.ExecutionTrace;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.library.LogLevel;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import io.flutter.plugin.common.BinaryMessenger;


public class ApmApiTest {
    private final ApmApi mApi = new ApmApi();
    private MockedStatic<APM> mAPM;
    private MockedStatic<ApmPigeon.ApmHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mAPM = mockStatic(APM.class);
        mHostApi = mockStatic(ApmPigeon.ApmHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mAPM.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    private ExecutionTrace mockTrace(String id) {
        String name = "trace-name";
        ExecutionTrace mTrace = mock(ExecutionTrace.class);

        mAPM.when(() -> APM.startExecutionTrace(name)).thenReturn(mTrace);

        mApi.startExecutionTrace(id, name, makeResult());

        return mTrace;
    }

    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        ApmApi.init(messenger);

        mHostApi.verify(() -> ApmPigeon.ApmHostApi.setup(eq(messenger), any(ApmApi.class)));
    }

    @Test
    public void testSetEnabled() {
        boolean isEnabled = false;

        mApi.setEnabled(isEnabled);

        mAPM.verify(() -> APM.setEnabled(isEnabled));
    }

    @Test
    public void testSetColdAppLaunchEnabled() {
        boolean isEnabled = false;

        mApi.setColdAppLaunchEnabled(isEnabled);

        mAPM.verify(() -> APM.setAppLaunchEnabled(isEnabled));
    }

    @Test
    public void testSetAutoUITraceEnabled() {
        boolean isEnabled = false;

        mApi.setAutoUITraceEnabled(isEnabled);

        mAPM.verify(() -> APM.setAutoUITraceEnabled(isEnabled));
    }

    @Test
    public void testSetLogLevel() {
        String logLevel = "logLevelNone";

        mApi.setLogLevel(logLevel);
        mApi.setLogLevel("NonExistingLogLevel");

        mAPM.verify(() -> APM.setLogLevel(LogLevel.NONE));
        mAPM.verify(() -> APM.setLogLevel(anyInt()), times(1));
    }

    @Test
    public void testStartExecutionTraceWhenTraceNotNull() {
        String expectedId = "trace-id";
        String name = "trace-name";
        ApmPigeon.Result<String> result = makeResult((String receivedId) -> {
            assertEquals(receivedId, expectedId);
        });

        mAPM.when(() -> APM.startExecutionTrace(name)).thenReturn(new ExecutionTrace(name));

        mApi.startExecutionTrace(expectedId, name, result);

        mAPM.verify(() -> APM.startExecutionTrace(name));
    }

    @Test
    public void testStartExecutionTraceWhenTraceIsNull() {
        String id = "trace-id";
        String name = "trace-name";
        ApmPigeon.Result<String> result = makeResult((String receivedId) -> assertNull(receivedId));

        mAPM.when(() -> APM.startExecutionTrace(name)).thenReturn(null);

        mApi.startExecutionTrace(id, name, result);

        mAPM.verify(() -> APM.startExecutionTrace(name));
    }

    @Test
    public void testSetExecutionTraceAttribute() {
        String id = "trace-id";
        String key = "is_premium";
        String value = "true";
        ExecutionTrace mTrace = mockTrace(id);

        mApi.setExecutionTraceAttribute(id, key, value);

        verify(mTrace).setAttribute(key, value);
    }

    @Test
    public void testEndExecutionTrace() {
        String id = "trace-id";
        ExecutionTrace mTrace = mockTrace(id);

        mApi.endExecutionTrace(id);

        verify(mTrace).end();
    }

    @Test
    public void testStartUITrace() {
        String name = "login";

        mApi.startUITrace(name);

        mAPM.verify(() -> APM.startUITrace(name));
    }

    @Test
    public void testEndUITrace() {
        mApi.endUITrace();

        mAPM.verify(APM::endUITrace);
    }

    @Test
    public void testEndAppLaunch() {
        mApi.endAppLaunch();

        mAPM.verify(APM::endAppLaunch);
    }

    // TODO: Test networkLogAndroid
}
