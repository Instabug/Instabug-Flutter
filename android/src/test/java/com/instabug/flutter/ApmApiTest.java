package com.instabug.flutter;

import static com.instabug.flutter.util.GlobalMocks.reflected;
import static com.instabug.flutter.util.MockResult.makeResult;
import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import com.instabug.apm.APM;
import com.instabug.apm.InternalAPM;
import com.instabug.apm.configuration.cp.APMFeature;
import com.instabug.apm.configuration.cp.FeatureAvailabilityCallback;
import com.instabug.apm.configuration.cp.ToleranceValueCallback;
import com.instabug.apm.networking.APMNetworkLogger;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.modules.ApmApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.flutter.util.MockReflected;

import org.json.JSONObject;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedConstruction;
import org.mockito.MockedStatic;

import java.lang.reflect.Array;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.Callable;

import static org.mockito.Mockito.*;
import io.flutter.plugin.common.BinaryMessenger;


public class ApmApiTest {

    private final BinaryMessenger mMessenger = mock(BinaryMessenger.class);
    private final Callable<Float> refreshRateProvider = () -> mock(Float.class);
    private final ApmApi api = new ApmApi(refreshRateProvider);
    private MockedStatic<APM> mAPM;
    private MockedStatic<InternalAPM> mInternalApmStatic;
    private MockedStatic<ApmPigeon.ApmHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mAPM = mockStatic(APM.class);
        mInternalApmStatic = mockStatic(InternalAPM.class);
        mHostApi = mockStatic(ApmPigeon.ApmHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mInternalApmStatic.close();
        mAPM.close();
        mHostApi.close();
        GlobalMocks.close();
    }


    @Test
    public void testInit() {
        BinaryMessenger messenger = mock(BinaryMessenger.class);

        ApmApi.init(messenger, refreshRateProvider);

        mHostApi.verify(() -> ApmPigeon.ApmHostApi.setup(eq(messenger), any(ApmApi.class)));
    }

    @Test
    public void testSetEnabled() {
        boolean isEnabled = false;

        api.setEnabled(isEnabled);

        mAPM.verify(() -> APM.setEnabled(isEnabled));
    }

    @Test
    public void testSetColdAppLaunchEnabled() {
        boolean isEnabled = false;

        api.setColdAppLaunchEnabled(isEnabled);

        mAPM.verify(() -> APM.setColdAppLaunchEnabled(isEnabled));
    }

    @Test
    public void testSetAutoUITraceEnabled() {
        boolean isEnabled = false;

        api.setAutoUITraceEnabled(isEnabled);

        mAPM.verify(() -> APM.setAutoUITraceEnabled(isEnabled));
    }



    @Test
    public void testStartFlow() {
        String appFlowName = "appFlowName";

        api.startFlow(appFlowName);

        mAPM.verify(() -> APM.startFlow(appFlowName));
        mAPM.verifyNoMoreInteractions();
    }

    @Test
    public void testEndFlow() {
        String appFlowName = "appFlowName";

        api.startFlow(appFlowName);

        mAPM.verify(() -> APM.startFlow(appFlowName));
        mAPM.verifyNoMoreInteractions();
    }

    @Test
    public void testSetFlowAttribute() {
        String appFlowName = "appFlowName";
        String flowAttributeKey = "attributeKey";
        String flowAttributeValue = "attributeValue";


        api.setFlowAttribute(appFlowName, flowAttributeKey, flowAttributeValue);

        mAPM.verify(() -> APM.setFlowAttribute(appFlowName, flowAttributeKey, flowAttributeValue));
        mAPM.verifyNoMoreInteractions();
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

        MockedConstruction<APMNetworkLogger> mAPMNetworkLogger = mockConstruction(APMNetworkLogger.class);
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
                serverErrorMessage,
                null
        ));

        mAPMNetworkLogger.close();
        mJSONObject.close();
    }

    @Test
    public void testStartUiTraceCP() {
        String screenName = "screen-name";
        long microTimeStamp = System.currentTimeMillis() / 1000;
        long traceId = System.currentTimeMillis();


        api.startCpUiTrace(screenName, microTimeStamp, traceId);

        mInternalApmStatic.verify(() -> InternalAPM._startUiTraceCP(screenName, microTimeStamp, traceId));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testReportScreenLoadingCP() {
        long startTimeStampMicro = System.currentTimeMillis() / 1000;
        long durationMicro = System.currentTimeMillis() / 1000;
        long uiTraceId = System.currentTimeMillis();

        api.reportScreenLoadingCP(startTimeStampMicro, durationMicro, uiTraceId);

        mInternalApmStatic.verify(() -> InternalAPM._reportScreenLoadingCP(startTimeStampMicro, durationMicro, uiTraceId));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testEndScreenLoading() {
        long timeStampMicro = System.currentTimeMillis() / 1000;
        long uiTraceId = System.currentTimeMillis();

        api.endScreenLoadingCP(timeStampMicro, uiTraceId);

        mInternalApmStatic.verify(() -> InternalAPM._endScreenLoadingCP(timeStampMicro, uiTraceId));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testIsEnabled() {
        boolean expected = true;
        ApmPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));
        mInternalApmStatic.when(() -> InternalAPM._isFeatureEnabledCP(eq(APMFeature.SCREEN_LOADING), any(), any(FeatureAvailabilityCallback.class))).thenAnswer(invocation -> {
            FeatureAvailabilityCallback callback = invocation.getArgument(1);
            callback.invoke(expected);
            return null;
        });

        api.isEnabled(result);

        verify(result).success(expected);
    }

    @Test
    public void testIsScreenLoadingEnabled() {
        boolean expected = true;
        ApmPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mInternalApmStatic.when(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any())).thenAnswer(
                invocation -> {
                    FeatureAvailabilityCallback callback = (FeatureAvailabilityCallback) invocation.getArguments()[2];
                    callback.invoke(expected);
                    return null;
                });


        api.isScreenLoadingEnabled(result);

        mInternalApmStatic.verify(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any()));
        mInternalApmStatic.verifyNoMoreInteractions();

        verify(result).success(expected);
    }

    @Test
    public void testIsEndScreenLoadingEnabled() {
        boolean expected = true;
        ApmPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mInternalApmStatic.when(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any())).thenAnswer(
                invocation -> {
                    FeatureAvailabilityCallback callback = (FeatureAvailabilityCallback) invocation.getArguments()[2];
                    callback.invoke(expected);
                    return null;
                });


        api.isEndScreenLoadingEnabled(result);

        mInternalApmStatic.verify(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any()));
        mInternalApmStatic.verifyNoMoreInteractions();

        verify(result).success(expected);

    }


    @Test
    public void testSetScreenLoadingMonitoringEnabled() {
        boolean isEnabled = false;

        api.setScreenLoadingEnabled(isEnabled);

        mAPM.verify(() -> APM.setScreenLoadingEnabled(isEnabled));
    }

    @Test
    public void testIsAutoUiTraceEnabled() {

        boolean expected = true;
        ApmPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mInternalApmStatic.when(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any())).thenAnswer(
                invocation -> {
                    FeatureAvailabilityCallback callback = (FeatureAvailabilityCallback) invocation.getArguments()[2];
                    callback.invoke(expected);
                    return null;
                });


        api.isScreenRenderEnabled(result);

        mInternalApmStatic.verify(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any()));
        mInternalApmStatic.verifyNoMoreInteractions();

        verify(result).success(expected);
    }

    @Test
    public void testIsScreenRenderEnabled() {

        boolean expected = true;
        ApmPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mInternalApmStatic.when(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any())).thenAnswer(
                invocation -> {
                    FeatureAvailabilityCallback callback = (FeatureAvailabilityCallback) invocation.getArguments()[2];
                    callback.invoke(expected);
                    return null;
                });


        api.isScreenRenderEnabled(result);

        mInternalApmStatic.verify(() -> InternalAPM._isFeatureEnabledCP(any(), any(), any()));
        mInternalApmStatic.verifyNoMoreInteractions();

        verify(result).success(expected);
    }

    @Test
    public void testSetScreenRenderEnabled() {
        boolean isEnabled = false;

        api.setScreenRenderEnabled(isEnabled);

        mAPM.verify(() -> APM.setScreenRenderingEnabled(isEnabled));
    }


    @Test
    public void testDeviceRefreshRateWithException() throws Exception {
        ApmPigeon.Result<List<Double>> result = spy(makeResult((actual) -> {}));
        
        // Mock the refresh rate provider to throw an exception
        Callable<Float> mockRefreshRateProvider = () -> {
            throw new RuntimeException("Test exception");
        };
        ApmApi testApi = new ApmApi(mockRefreshRateProvider);

        testApi.getDeviceRefreshRateAndTolerance(result);

        // Verify that the method doesn't crash when an exception occurs
        // The exception is caught and printed, but the result is not called
        verify(result, never()).success(any());
    }

    @Test
    public void testGetDeviceRefreshRateAndTolerance() throws Exception {
        // Arrange
        double expectedRefreshRate = 60.0;
        long expectedTolerance = 5L;
        List<Double> expectedResult = Arrays.asList(expectedRefreshRate, (double) expectedTolerance);
        ApmPigeon.Result<List<Double>> result = spy(makeResult((actual) -> assertEquals(expectedResult, actual)));
        
        // Mock the refresh rate provider
        Callable<Float> mockRefreshRateProvider = () -> (float) expectedRefreshRate;
        ApmApi testApi = new ApmApi(mockRefreshRateProvider);
        
        // Mock the tolerance callback
        mInternalApmStatic.when(() -> InternalAPM._getToleranceValueForScreenRenderingCP(any(ToleranceValueCallback.class))).thenAnswer(invocation -> {
            ToleranceValueCallback callback = invocation.getArgument(0);
            callback.invoke(expectedTolerance);
            return null;
        });

        // Act
        testApi.getDeviceRefreshRateAndTolerance(result);

        // Assert
        verify(result).success(expectedResult);
        mInternalApmStatic.verify(() -> InternalAPM._getToleranceValueForScreenRenderingCP(any(ToleranceValueCallback.class)));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testEndScreenRenderForAutoUiTrace() {
        Map<String, Object> data = new HashMap<>();
        data.put("traceId", 123L);
        data.put("slowFramesTotalDuration", 1000L);
        data.put("frozenFramesTotalDuration", 2000L);
        data.put("endTime", 1234567890L);
        data.put("frameData", null);

        api.endScreenRenderForAutoUiTrace(data);

        mInternalApmStatic.verify(() -> InternalAPM._endAutoUiTraceWithScreenRendering(any(), eq(1234567890L)));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testEndScreenRenderForAutoUiTraceWithFrameData() {
        Map<String, Object> data = new HashMap<>();
        data.put("traceId", 123L);
        data.put("slowFramesTotalDuration", 1000L);
        data.put("frozenFramesTotalDuration", 2000L);
        data.put("endTime", 1234567890L);
        
        // Create frame data with ArrayList<ArrayList<Long>>
        java.util.ArrayList<java.util.ArrayList<Long>> frameData = new java.util.ArrayList<>();
        java.util.ArrayList<Long> frame1 = new java.util.ArrayList<>();
        frame1.add(100L);
        frame1.add(200L);
        frameData.add(frame1);
        
        java.util.ArrayList<Long> frame2 = new java.util.ArrayList<>();
        frame2.add(300L);
        frame2.add(400L);
        frameData.add(frame2);
        
        data.put("frameData", frameData);

        api.endScreenRenderForAutoUiTrace(data);

        mInternalApmStatic.verify(() -> InternalAPM._endAutoUiTraceWithScreenRendering(any(), eq(1234567890L)));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testEndScreenRenderForCustomUiTrace() {
        Map<String, Object> data = new HashMap<>();
        data.put("traceId", 123L);
        data.put("slowFramesTotalDuration", 1000L);
        data.put("frozenFramesTotalDuration", 2000L);
        data.put("endTime", 1234567890L);
        data.put("frameData", null);

        api.endScreenRenderForCustomUiTrace(data);

        mInternalApmStatic.verify(() -> InternalAPM._endCustomUiTraceWithScreenRenderingCP(any()));
        mInternalApmStatic.verifyNoMoreInteractions();
    }

    @Test
    public void testEndScreenRenderForCustomUiTraceWithFrameData() {
        Map<String, Object> data = new HashMap<>();
        data.put("traceId", 123L);
        data.put("slowFramesTotalDuration", 1000L);
        data.put("frozenFramesTotalDuration", 2000L);

        // Create frame data with ArrayList<ArrayList<Long>>
        java.util.ArrayList<java.util.ArrayList<Long>> frameData = new java.util.ArrayList<>();
        java.util.ArrayList<Long> frame1 = new java.util.ArrayList<>();
        frame1.add(100L);
        frame1.add(200L);
        frameData.add(frame1);

        java.util.ArrayList<Long> frame2 = new java.util.ArrayList<>();
        frame2.add(300L);
        frame2.add(400L);
        frameData.add(frame2);

        data.put("frameData", frameData);

        api.endScreenRenderForCustomUiTrace(data);

        mInternalApmStatic.verify(() -> InternalAPM._endCustomUiTraceWithScreenRenderingCP(any()));
        mInternalApmStatic.verifyNoMoreInteractions();
    }
}
