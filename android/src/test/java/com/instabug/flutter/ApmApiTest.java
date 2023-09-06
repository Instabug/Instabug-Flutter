package com.instabug.flutter;

import static com.instabug.flutter.util.GlobalMocks.reflected;
import static com.instabug.flutter.util.MockResult.makeResult;
import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockConstruction;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import com.instabug.apm.APM;
import com.instabug.apm.model.ExecutionTrace;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.flutter.util.MockReflected;
import com.instabug.library.LogLevel;

import org.json.JSONObject;
import org.junit.After;
import org.junit.Assert;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedConstruction;
import org.mockito.MockedStatic;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;


public class ApmApiTest {
    private final ApmApi api = new ApmApi();
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

        api.startExecutionTrace(id, name, makeResult());

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

        api.setEnabled(isEnabled);

        mAPM.verify(() -> APM.setEnabled(isEnabled));
    }

    @SuppressWarnings("deprecation")
    @Test
    public void testSetColdAppLaunchEnabled() {
        boolean isEnabled = false;

        api.setColdAppLaunchEnabled(isEnabled);

        mAPM.verify(() -> APM.setAppLaunchEnabled(isEnabled));
    }

    @Test
    public void testSetAutoUITraceEnabled() {
        boolean isEnabled = false;

        api.setAutoUITraceEnabled(isEnabled);

        mAPM.verify(() -> APM.setAutoUITraceEnabled(isEnabled));
    }

    @Test
    public void testStartExecutionTraceWhenTraceNotNull() {
        String expectedId = "trace-id";
        String name = "trace-name";
        ApmPigeon.Result<String> result = makeResult((String actualId) -> assertEquals(expectedId, actualId));

        mAPM.when(() -> APM.startExecutionTrace(name)).thenReturn(new ExecutionTrace(name));

        api.startExecutionTrace(expectedId, name, result);

        mAPM.verify(() -> APM.startExecutionTrace(name));
    }

    @Test
    public void testStartExecutionTraceWhenTraceIsNull() {
        String id = "trace-id";
        String name = "trace-name";
        ApmPigeon.Result<String> result = makeResult(Assert::assertNull);

        mAPM.when(() -> APM.startExecutionTrace(name)).thenReturn(null);

        api.startExecutionTrace(id, name, result);

        mAPM.verify(() -> APM.startExecutionTrace(name));
    }

    @Test
    public void testSetExecutionTraceAttribute() {
        String id = "trace-id";
        String key = "is_premium";
        String value = "true";
        ExecutionTrace mTrace = mockTrace(id);

        api.setExecutionTraceAttribute(id, key, value);

        verify(mTrace).setAttribute(key, value);
    }

    @Test
    public void testEndExecutionTrace() {
        String id = "trace-id";
        ExecutionTrace mTrace = mockTrace(id);

        api.endExecutionTrace(id);

        verify(mTrace).end();
    }

    @Test
    public void testStartUITrace() {
        String name = "login";

        api.startUITrace(name);

        mAPM.verify(() -> APM.startUITrace(name));
    }

    @Test
    public void testEndUITrace() {
        api.endUITrace();

        mAPM.verify(APM::endUITrace);
    }

    @Test
    public void testEndAppLaunch() {
        api.endAppLaunch();

        mAPM.verify(APM::endAppLaunch);
    }

    @Test
    public void testNetworkLogAndroid() {
        Map<String, Object> data = new HashMap<>();
        String requestUrl = "https://example.com";
        String requestBody = "hi";
        String responseBody = "{\"hello\":\"world\"}";
        String requestMethod = "POST";
        String requestContentType = "text/plain";
        String responseContentType = "application/json";
        long requestBodySize = 20;
        long responseBodySize = 50;
        int responseCode = 401;
        long requestDuration = 23000;
        long requestStartTime = System.currentTimeMillis() / 1000;
        HashMap<String, String> requestHeaders = new HashMap<>();
        HashMap<String, String> responseHeaders = new HashMap<>();
        String errorDomain = "ERROR_DOMAIN";
        String serverErrorMessage = "SERVER_ERROR_MESSAGE";
        data.put("url", requestUrl);
        data.put("requestBody", requestBody);
        data.put("responseBody", responseBody);
        data.put("method", requestMethod);
        data.put("requestContentType", requestContentType);
        data.put("responseContentType", responseContentType);
        data.put("requestBodySize", requestBodySize);
        data.put("responseBodySize", responseBodySize);
        data.put("errorDomain", errorDomain);
        data.put("responseCode", responseCode);
        data.put("requestDuration", requestDuration);
        data.put("startTime", requestStartTime);
        data.put("requestHeaders", requestHeaders);
        data.put("responseHeaders", responseHeaders);
        data.put("duration", requestDuration);
        data.put("serverErrorMessage", serverErrorMessage);

        MockedConstruction<JSONObject> mJSONObject = mockConstruction(JSONObject.class, (mock, context) -> when(mock.toString(anyInt())).thenReturn("{}"));

        api.networkLogAndroid(data);

        reflected.verify(() -> MockReflected.apmNetworkLog(
                requestStartTime * 1000,
                requestDuration / 1000,
                "{}",
                requestBody,
                requestBodySize,
                requestMethod,
                requestUrl,
                requestContentType,
                "{}",
                responseBody,
                responseBodySize,
                responseCode,
                responseContentType,
                errorDomain,
                null,
                serverErrorMessage
        ));

        mJSONObject.close();
    }
}
