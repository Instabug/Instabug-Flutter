package com.instabug.flutter.modules;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import com.instabug.apm.APM;
import com.instabug.apm.InternalAPM;
import com.instabug.apm.configuration.cp.APMFeature;
import com.instabug.apm.configuration.cp.FeatureAvailabilityCallback;
import com.instabug.apm.model.ExecutionTrace;
import com.instabug.apm.networking.ApmNetworkLoggerHelper;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.util.ThreadManager;

import java.util.HashMap;
import java.util.Map;

import io.flutter.plugin.common.BinaryMessenger;

public class ApmApi implements ApmPigeon.ApmHostApi {
    private final String TAG = ApmApi.class.getName();
    private final HashMap<String, ExecutionTrace> traces = new HashMap<>();

    public static void init(BinaryMessenger messenger) {
        final ApmApi api = new ApmApi();
        ApmPigeon.ApmHostApi.setup(messenger, api);
    }

    /**
     * The function sets the enabled status of APM.
     *
     * @param isEnabled The `setEnabled` method in the code snippet is used to enable or disable a
     *                  feature, and it takes a `Boolean` parameter named `isEnabled`. When this method is called with
     *                  `true`, it enables the feature, and when called with `false`, it disables the feature. The method
     *                  internally calls
     */
    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Sets the cold app launch enabled status using the APM library.
     *
     * @param isEnabled The `isEnabled` parameter is a Boolean value that indicates whether cold app launch
     *                  is enabled or not. When `isEnabled` is set to `true`, cold app launch is enabled, and when it is set
     *                  to `false`, cold app launch is disabled.
     */
    @Override
    public void setColdAppLaunchEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setColdAppLaunchEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * The function sets the auto UI trace enabled status in an APM system, handling any exceptions that
     * may occur.
     *
     * @param isEnabled The `isEnabled` parameter is a Boolean value that indicates whether the Auto UI
     *                  trace feature should be enabled or disabled. When `isEnabled` is set to `true`, the Auto UI trace
     *                  feature is enabled, and when it is set to `false`, the feature is disabled.
     */
    @Override
    public void setAutoUITraceEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setAutoUITraceEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Starts an execution trace and handles the result
     * using callbacks.
     *
     * @param id     The `id` parameter is a non-null String that represents the identifier of the execution
     *               trace.
     * @param name   The `name` parameter in the `startExecutionTrace` method represents the name of the
     *               execution trace that will be started. It is used as a reference to identify the trace during
     *               execution monitoring.
     * @param result The `result` parameter in the `startExecutionTrace` method is an instance of
     *               `ApmPigeon.Result<String>`. This parameter is used to provide the result of the execution trace
     *               operation back to the caller. The `success` method of the `result` object is called with the
     * @deprecated see {@link #startFlow}
     */
    @Override
    public void startExecutionTrace(@NonNull String id, @NonNull String name, ApmPigeon.Result<String> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        try {
                            ExecutionTrace trace = APM.startExecutionTrace(name);
                            if (trace != null) {
                                traces.put(id, trace);

                                ThreadManager.runOnMainThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.success(id);
                                    }
                                });
                            } else {
                                ThreadManager.runOnMainThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        result.success(null);
                                    }
                                });
                            }
                        } catch (Exception e) {
                            e.printStackTrace();

                            ThreadManager.runOnMainThread(new Runnable() {
                                @Override
                                public void run() {
                                    result.success(null);
                                }
                            });
                        }
                    }
                }
        );
    }

    /**
     * Starts an AppFlow with the specified name.
     * <br/>
     * On starting two flows with the same name the older flow will end with force abandon end reason.
     * AppFlow name cannot exceed 150 characters otherwise it's truncated,
     * leading and trailing whitespaces are also ignored.
     *
     * @param name AppFlow name. It can not be empty string or null.
     *             Starts a new AppFlow, if APM is enabled, feature is enabled
     *             and Instabug SDK is initialized.
     */
    @Override
    public void startFlow(@NonNull String name) {
        try {
            APM.startFlow(name);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Sets custom attributes for AppFlow with a given name.
     * <br/>
     * Setting an attribute value to null will remove its corresponding key if it already exists.
     * <br/>
     * Attribute key name cannot exceed 30 characters.
     * Leading and trailing whitespaces are also ignored.
     * Does not accept empty strings or null.
     * <br/>
     * Attribute value name cannot exceed 60 characters,
     * leading and trailing whitespaces are also ignored.
     * Does not accept empty strings.
     * <br/>
     * If a trace is ended, attributes will not be added and existing ones will not be updated.
     * <br/>
     *
     * @param name  AppFlow name. It can not be empty string or null
     * @param key   AppFlow attribute key. It can not be empty string or null
     * @param value AppFlow attribute value. It can not be empty string. Null to remove attribute
     */
    @Override
    public void setFlowAttribute(@NonNull String name, @NonNull String key, @Nullable String value) {
        try {
            APM.setFlowAttribute(name, key, value);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Ends AppFlow with a given name.
     *
     * @param name AppFlow name to be ended. It can not be empty string or null
     */
    @Override
    public void endFlow(@NonNull String name) {
        try {
            APM.endFlow(name);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Adds a new attribute to trace
     *
     * @param id    String id of the trace.
     * @param key   attribute key
     * @param value attribute value. Null to remove attribute
     * @deprecated see {@link #setFlowAttribute}
     */
    @Override
    public void setExecutionTraceAttribute(@NonNull String id, @NonNull String key, @NonNull String value) {
        try {
            traces.get(id).setAttribute(key, value);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Ends a trace
     *
     * @param id string id of the trace.
     * @deprecated see {@link #endFlow}
     */
    @Override
    public void endExecutionTrace(@NonNull String id) {
        try {
            traces.get(id).end();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Starts a UI trace.
     *
     * @param name string name of the UI trace.
     */
    @Override
    public void startUITrace(@NonNull String name) {
        try {
            APM.startUITrace(name);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * This method is used to terminate the currently active UI trace.
     */
    @Override
    public void endUITrace() {
        try {
            APM.endUITrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * This method is used to signal the end of the app launch process.
     */
    @Override
    public void endAppLaunch() {
        try {
            APM.endAppLaunch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * logs network-related information
     *
     * @param data Map of network data object.
     */
    @Override
    public void networkLogAndroid(@NonNull Map<String, Object> data) {
        try {
            ApmNetworkLoggerHelper.log(data);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * This method is responsible for initiating a custom performance UI trace
     * in the APM module. It takes three parameters:
     *
     * @param screenName:     A string representing the name of the screen or UI element being traced.
     * @param microTimeStamp: A number representing the timestamp in microseconds when the trace is started.
     * @param traceId:        A number representing the unique identifier for the trace.
     */
    @Override
    public void startCpUiTrace(@NonNull String screenName, @NonNull Long microTimeStamp, @NonNull Long traceId) {
        try {
            InternalAPM._startUiTraceCP(screenName, microTimeStamp, traceId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * This method is responsible for reporting the screen
     * loading data from Dart side to Android side. It takes three parameters:
     *
     * @param startTimeStampMicro: A number representing the start timestamp in microseconds of the screen
     *                             loading custom performance data.
     * @param durationMicro:       A number representing the duration in microseconds of the screen loading custom
     *                             performance data.
     * @param uiTraceId:           A number representing the unique identifier for the UI trace associated with the
     *                             screen loading.
     */
    @Override
    public void reportScreenLoadingCP(@NonNull Long startTimeStampMicro, @NonNull Long durationMicro, @NonNull Long uiTraceId) {
        try {
            InternalAPM._reportScreenLoadingCP(startTimeStampMicro, durationMicro, uiTraceId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * This method is responsible for extend the end time if the screen loading custom
     * trace. It takes two parameters:
     *
     * @param timeStampMicro: A number representing the timestamp in microseconds when the screen loading
     *                        custom trace is ending.
     * @param uiTraceId:      A number representing the unique identifier for the UI trace associated with the
     *                        screen loading.
     */
    @Override
    public void endScreenLoadingCP(@NonNull Long timeStampMicro, @NonNull Long uiTraceId) {
        try {
            InternalAPM._endScreenLoadingCP(timeStampMicro, uiTraceId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    /**
     * This method is used to check whether the end screen loading feature is enabled or not.
     */
    @Override
    public void isEndScreenLoadingEnabled(@NonNull ApmPigeon.Result<Boolean> result) {
        isScreenLoadingEnabled(result);
    }

    @Override
    public void isEnabled(@NonNull ApmPigeon.Result<Boolean> result) {
        try {
            // TODO: replace true with an actual implementation of APM.isEnabled once implemented
            // in the Android SDK.
            result.success(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * checks whether the screen loading feature is enabled.
     */
    @Override
    public void isScreenLoadingEnabled(@NonNull ApmPigeon.Result<Boolean> result) {
        try {
            InternalAPM._isFeatureEnabledCP(APMFeature.SCREEN_LOADING, "InstabugCaptureScreenLoading", new FeatureAvailabilityCallback() {
                @Override
                public void invoke(boolean isFeatureAvailable) {
                    result.success(isFeatureAvailable);
                }
            });
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * This method is setting the enabled state of the screen loading feature.
     */
    @Override
    public void setScreenLoadingEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setScreenLoadingEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    @Override
    public void isScreenRenderEnabled(@NonNull ApmPigeon.Result<Boolean> result) {
        try {
            result.success(true);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void deviceRefreshRate(@NonNull ApmPigeon.Result<Double> result) {
        result.success(60.0);
    }

}
