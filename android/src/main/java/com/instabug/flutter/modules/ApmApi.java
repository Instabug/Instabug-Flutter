package com.instabug.flutter.modules;

import android.util.Log;
import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import com.instabug.apm.APM;
import com.instabug.apm.model.ExecutionTrace;
import com.instabug.apm.networking.APMNetworkLogger;
import com.instabug.apm.networkinterception.cp.APMCPNetworkLog;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.util.Reflection;
import com.instabug.flutter.util.ThreadManager;
import io.flutter.plugin.common.BinaryMessenger;
import org.json.JSONException;
import org.json.JSONObject;
import java.lang.reflect.Method;
import java.util.HashMap;
import java.util.Map;
import java.util.Objects;

public class ApmApi implements ApmPigeon.ApmHostApi {
    private final String TAG = ApmApi.class.getName();
    private final HashMap<String, ExecutionTrace> traces = new HashMap<>();

    public static void init(BinaryMessenger messenger) {
        final ApmApi api = new ApmApi();
        ApmPigeon.ApmHostApi.setup(messenger, api);
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setColdAppLaunchEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setColdAppLaunchEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setAutoUITraceEnabled(@NonNull Boolean isEnabled) {
        try {
            APM.setAutoUITraceEnabled(isEnabled);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

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

    @Override
    public void startFlow(@NonNull String name) {
        try {
            APM.startFlow(name);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setFlowAttribute(@NonNull String name, @NonNull String key, @Nullable String value) {
        try {
            APM.setFlowAttribute(name, key, value);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void endFlow(@NonNull String name) {
        try {
            APM.endFlow(name);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void setExecutionTraceAttribute(@NonNull String id, @NonNull String key, @NonNull String value) {
        try {
            traces.get(id).setAttribute(key, value);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void endExecutionTrace(@NonNull String id) {
        try {
            traces.get(id).end();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void startUITrace(@NonNull String name) {
        try {
            APM.startUITrace(name);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void endUITrace() {
        try {
            APM.endUITrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void endAppLaunch() {
        try {
            APM.endAppLaunch();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void networkLogAndroid(@NonNull Map<String, Object> data) {
        try {
            APMNetworkLogger apmNetworkLogger = new APMNetworkLogger();
            final String requestUrl = (String) data.get("url");
            final String requestBody = (String) data.get("requestBody");
            final String responseBody = (String) data.get("responseBody");
            final String requestMethod = (String) data.get("method");
            //--------------------------------------------
            final String requestContentType = (String) data.get("requestContentType");
            final String responseContentType = (String) data.get("responseContentType");
            //--------------------------------------------
            final long requestBodySize = ((Number) data.get("requestBodySize")).longValue();
            final long responseBodySize = ((Number) data.get("responseBodySize")).longValue();
            //--------------------------------------------
            final String errorDomain = (String) data.get("errorDomain");
            final Integer statusCode = (Integer) data.get("responseCode");
            final long requestDuration = ((Number) data.get("duration")).longValue() / 1000;
            final long requestStartTime = ((Number) data.get("startTime")).longValue() * 1000;
            final String requestHeaders = (new JSONObject((HashMap<String, String>) data.get("requestHeaders"))).toString(4);
            final String responseHeaders = (new JSONObject((HashMap<String, String>) data.get("responseHeaders"))).toString(4);
            final String errorMessage;

            if (errorDomain.equals("")) {
                errorMessage = null;
            } else {
                errorMessage = errorDomain;
            }
            //--------------------------------------------------
            String gqlQueryName = null;
            if (data.containsKey("gqlQueryName")) {
                gqlQueryName = (String) data.get("gqlQueryName");
            }
            String serverErrorMessage = "";
            if (data.containsKey("serverErrorMessage")) {
                serverErrorMessage = (String) data.get("serverErrorMessage");
            }
            Boolean w3cc = null;
            Long partialId = null;
            Long etst = null;
            String wgeti = null;
            String wceti = null;

            try {
                w3cc = (Boolean) data.get("w3cc");

            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                partialId = (Long) data.get("partialId");

            } catch (Exception e) {
                e.printStackTrace();
            }

            try {
                etst = (Long) data.get("etst");

            } catch (Exception e) {
                e.printStackTrace();
            }

            try {

                wgeti = (String) data.get("wgeti");
                if (Objects.equals(wgeti, "null")) {
                    wgeti = null;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }


            try {
                wceti = (String) data.get("wceti");

                if (Objects.equals(wceti, "null")) {
                    wceti = null;
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
            APMCPNetworkLog.W3CExternalTraceAttributes w3cExternalTraceAttributes =
                    new APMCPNetworkLog.W3CExternalTraceAttributes(
                            w3cc, partialId, etst, wgeti, wceti

                    );


            Method method = Reflection.getMethod(Class.forName("com.instabug.apm.networking.APMNetworkLogger"), "log", long.class, long.class, String.class, String.class, long.class, String.class, String.class, String.class, String.class, String.class, long.class, int.class, String.class, String.class, String.class, String.class,APMCPNetworkLog.W3CExternalTraceAttributes.class);
            if (method != null) {
                method.invoke(apmNetworkLogger, requestStartTime, requestDuration, requestHeaders, requestBody, requestBodySize, requestMethod, requestUrl, requestContentType, responseHeaders, responseBody, responseBodySize, statusCode, responseContentType, errorMessage, gqlQueryName, serverErrorMessage,w3cExternalTraceAttributes);
            } else {
                Log.e(TAG, "APMNetworkLogger.log was not found by reflection");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
