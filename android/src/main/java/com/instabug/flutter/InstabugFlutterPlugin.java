package com.instabug.flutter;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import androidx.annotation.NonNull;

import com.instabug.apm.APM;
import com.instabug.apm.model.ExecutionTrace;
import com.instabug.apm.networking.APMNetworkLogger;
import com.instabug.bug.BugReporting;
import com.instabug.chat.Replies;
import com.instabug.flutter.generated.BugReportingPigeon;
import com.instabug.flutter.generated.CrashReportingPigeon;
import com.instabug.flutter.generated.FeatureRequestsPigeon;
import com.instabug.flutter.generated.InstabugLogPigeon;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.library.Feature;
import com.instabug.library.Instabug;
import com.instabug.library.model.NetworkLog;

import org.json.JSONException;
import org.json.JSONObject;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * InstabugFlutterPlugin
 */
public class InstabugFlutterPlugin implements MethodCallHandler, FlutterPlugin {

    final public static String INVOCATION_EVENT_NONE = "InvocationEvent.none";
    final public static String INVOCATION_EVENT_SCREENSHOT = "InvocationEvent.screenshot";
    final public static String INVOCATION_EVENT_TWO_FINGER_SWIPE_LEFT = "InvocationEvent.twoFingersSwipeLeft";
    final public static String INVOCATION_EVENT_FLOATING_BUTTON = "InvocationEvent.floatingButton";
    final public static String INVOCATION_EVENT_SHAKE = "InvocationEvent.shake";

    HashMap<String, ExecutionTrace> traces = new HashMap<String, ExecutionTrace>();

    private static Context context;
    static MethodChannel channel;

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        register(registrar.context().getApplicationContext(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        context = null;
    }

    private static void register(Context applicationContext, BinaryMessenger messenger){
        context = applicationContext;
        channel = new MethodChannel(messenger, "instabug_flutter");
        channel.setMethodCallHandler(new InstabugFlutterPlugin());

        InstabugPigeon.InstabugApi.setup(messenger, new InstabugApiImpl(context));
        InstabugLogPigeon.InstabugLogApi.setup(messenger, new InstabugLogApiImpl());
        BugReportingPigeon.BugReportingApi.setup(messenger, new BugReportingApiImpl(messenger));
        CrashReportingPigeon.CrashReportingApi.setup(messenger, new CrashReportingApiImpl());
        FeatureRequestsPigeon.FeatureRequestsApi.setup(messenger, new FeatureRequestsApiImpl());
        SurveysPigeon.SurveysApi.setup(messenger, new SurveysApiImpl(messenger));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Method[] methods = this.getClass().getMethods();
        boolean isImplemented = false;
        String callMethod = call.method;
        if (callMethod.contains(":")) {
            callMethod = call.method.substring(0, call.method.indexOf(":"));
        }
        for (Method method : methods) {
            if (callMethod.equals(method.getName())) {
                isImplemented = true;
                ArrayList<Object> tempParamValues = new ArrayList<>();
                if (call.arguments != null) {
                    tempParamValues = (ArrayList<Object>) call.arguments;
                }
                Object[] paramValues = tempParamValues.toArray();
                try {
                    Object returnVal = method.invoke(this, paramValues);
                    result.success(returnVal);
                    break;
                } catch (Exception e) {
                    e.printStackTrace();
                    result.notImplemented();
                }
            }
        }
        if (!isImplemented) {
            result.notImplemented();
        }
    }

    /**
     * Gets the private method that matches the class, method name and parameter
     * types given and making it accessible. For private use only.
     * 
     * @param clazz         the class the method is in
     * @param methodName    the method name
     * @param parameterType list of the parameter types of the method
     * @return the method that matches the class, method name and param types given
     */
    public static Method getMethod(Class clazz, String methodName, Class... parameterType) {
        final Method[] methods = clazz.getDeclaredMethods();
        for (Method method : methods) {
            if (method.getName().equals(methodName) && method.getParameterTypes().length == parameterType.length) {
                for (int i = 0; i < parameterType.length; i++) {
                    if (method.getParameterTypes()[i] == parameterType[i]) {
                        if (i == method.getParameterTypes().length - 1) {
                            method.setAccessible(true);
                            return method;
                        }
                    } else {
                        break;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Enables and disables everything related to receiving replies.
     * 
     * @param {boolean} isEnabled
     */
    public void setRepliesEnabled(final boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                if (isEnabled) {
                    Replies.setState(Feature.State.ENABLED);
                } else {
                    Replies.setState(Feature.State.DISABLED);
                }
            }
        });
    }

    /**
     * Manual invocation for replies.
     */
    public void showReplies() {
        Replies.show();
    }

    /**
     * Tells whether the user has chats already or not.
     */
    public void hasChats() {
        boolean hasChats = Replies.hasChats();
        channel.invokeMethod("hasChatsCallback", hasChats);
    }

    /**
     * Sets a block of code that gets executed when a new message is received.
     */
    public void setOnNewReplyReceivedCallback() {
        Runnable onNewMessageRunnable = new Runnable() {
            @Override
            public void run() {
                channel.invokeMethod("onNewReplyReceivedCallback", null);
            }
        };
        Replies.setOnNewReplyReceivedCallback(onNewMessageRunnable);
    }

    /**
     * Get current unread count of messages for this user
     *
     * @return number of messages that are unread for this user
     */
    public void getUnreadRepliesCount() {
        int unreadMessages = Replies.getUnreadRepliesCount();
        channel.invokeMethod("unreadRepliesCountCallback", unreadMessages);
    }

    /**
     * Enabled/disable chat notification
     *
     * @param isChatNotificationEnable whether chat notification is reburied or not
     */
    public void setChatNotificationEnabled(boolean isChatNotificationEnable) {
        Replies.setInAppNotificationEnabled(isChatNotificationEnable);
    }

    /**
     * Set whether new in app notification received will play a small sound
     * notification or not (Default is {@code false})
     *
     * @param shouldPlaySound desired state of conversation sounds
     * @since 4.1.0
     */
    public void setEnableInAppNotificationSound(boolean shouldPlaySound) {
        Replies.setInAppNotificationSound(shouldPlaySound);
    }

    /**
     * Extracts HTTP connection properties. Request method, Headers, Date, Url and
     * Response code
     *
     * @param jsonObject the JSON object containing all HTTP connection properties
     */
    public void networkLog(HashMap<String, Object> jsonObject) throws JSONException {

        int responseCode = 0;

        NetworkLog networkLog = new NetworkLog();
        String date = System.currentTimeMillis() + "";
        networkLog.setDate(date);
        networkLog.setUrl((String) jsonObject.get("url"));
        networkLog.setRequest((String) jsonObject.get("requestBody"));
        networkLog.setResponse((String) jsonObject.get("responseBody"));
        networkLog.setMethod((String) jsonObject.get("method"));
        networkLog.setResponseCode((Integer) jsonObject.get("responseCode"));
        networkLog.setRequestHeaders(
                (new JSONObject((HashMap<String, String>) jsonObject.get("requestHeaders"))).toString(4));
        networkLog.setResponseHeaders(
                (new JSONObject((HashMap<String, String>) jsonObject.get("responseHeaders"))).toString(4));
        networkLog.setTotalDuration(((Number) jsonObject.get("duration")).longValue() / 1000);
        networkLog.insert();
    }

    /**
     * Enables and disables everything related to APM feature.
     * 
     * @param {boolean} isEnabled
     */
    public void setAPMEnabled(final boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    APM.setEnabled(isEnabled);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Sets the printed logs priority. Filter to one of the following levels.
     *
     * @param {String} logLevel.
     */
    public void setAPMLogLevel(final String logLevel) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    if (ArgsRegistry.getDeserializedValue(logLevel) == null) {
                        return;
                    }
                    APM.setLogLevel((int) ArgsRegistry.getRawValue(logLevel));
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
  
    /**
     * Enables or disables cold app launch tracking.
     * @param isEnabled boolean indicating enabled or disabled.
     */
    public void setColdAppLaunchEnabled(final boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    APM.setAppLaunchEnabled(isEnabled);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
    /**
     * Starts an execution trace
     * @param name string name of the trace.
     */
    public String startExecutionTrace(final String name, final String id) {
        try {
            String result = null;
            ExecutionTrace trace = APM.startExecutionTrace(name);
            if (trace != null) {
                result = id;
                traces.put(id, trace);
            }
            return result;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
  
    /**
     * Sets an execution trace attribute
     * @param id string id of the trace.
     * @param key string key of the attribute.
     * @param value string value of the attribute.
     */
    public void setExecutionTraceAttribute(final String id, final String key, final String value) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    traces.get(id).setAttribute(key, value);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
  
    /**
     * Ends an execution trace
     * @param id string id of the trace.
     */
    public void endExecutionTrace(final String id) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    traces.get(id).end();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }
  
    /**
     * Enables or disables auto UI tracing
     * @param isEnabled boolean indicating enabled or disabled.
     */
    public void setAutoUITraceEnabled(final boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    APM.setAutoUITraceEnabled(isEnabled);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Starts a UI trace
     * @param name string name of the UI trace.
     */
    public void startUITrace(final String name) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    APM.startUITrace(name);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Ends the current running UI trace
     */
    public void endUITrace() {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    APM.endUITrace();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    /**
     * Ends app launch
     */
    public void endAppLaunch() {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                try {
                    APM.endAppLaunch();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });
    }

    public void apmNetworkLogByReflection(HashMap<String, Object> jsonObject) throws JSONException {
        try {
            APMNetworkLogger apmNetworkLogger = new APMNetworkLogger();
            final String requestUrl = (String) jsonObject.get("url");
            final String requestBody = (String) jsonObject.get("requestBody");
            final String responseBody = (String) jsonObject.get("responseBody");
            final String requestMethod = (String) jsonObject.get("method");
            //--------------------------------------------
            final String requestContentType = (String) jsonObject.get("requestContentType");
            final String responseContentType = (String) jsonObject.get("responseContentType");
            //--------------------------------------------
            final long requestBodySize = ((Number) jsonObject.get("requestBodySize")).longValue();
            final long responseBodySize = ((Number) jsonObject.get("responseBodySize")).longValue();
            //--------------------------------------------
            final String errorDomain = (String) jsonObject.get("errorDomain");
            final Integer statusCode = (Integer) jsonObject.get("responseCode");
            final long requestDuration = ((Number) jsonObject.get("duration")).longValue() / 1000;
            final long requestStartTime = ((Number) jsonObject.get("startTime")).longValue() * 1000;
            final String requestHeaders = (new JSONObject((HashMap<String, String>) jsonObject.get("requestHeaders"))).toString(4);
            final String responseHeaders = (new JSONObject((HashMap<String, String>) jsonObject.get("responseHeaders"))).toString(4);
            final String errorMessage;

            if(errorDomain.equals("")) {
                errorMessage = null;
            } else {
                errorMessage = errorDomain;
            }
            //--------------------------------------------------
            String gqlQueryName = null;
            if(jsonObject.containsKey("gqlQueryName")){
                gqlQueryName = (String) jsonObject.get("gqlQueryName");
            }
            String serverErrorMessage = "";
            if(jsonObject.containsKey("serverErrorMessage")){
                serverErrorMessage = (String) jsonObject.get("serverErrorMessage");
            }  

            try {
                Method method = getMethod(Class.forName("com.instabug.apm.networking.APMNetworkLogger"), "log", long.class, long.class, String.class, String.class, long.class, String.class, String.class, String.class, String.class, String.class, long.class, int.class, String.class, String.class, String.class, String.class);
                if (method != null) {
                    method.invoke(apmNetworkLogger, requestStartTime, requestDuration, requestHeaders, requestBody, requestBodySize, requestMethod, requestUrl, requestContentType, responseHeaders, responseBody, responseBodySize, statusCode, responseContentType, errorMessage, gqlQueryName, serverErrorMessage);
                } else {
                    Log.e("IB-CP-Bridge", "apmNetworkLogByReflection was not found by reflection");
                }
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            } catch (IllegalAccessException e) {
                e.printStackTrace();
            } catch (InvocationTargetException e) {
                e.printStackTrace();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Sets the threshold value of the shake gesture for android devices. Default
     * for android is an integer value equals 350. you could increase the shaking
     * difficulty level by increasing the `350` value and vice versa
     * 
     * @param androidThreshold Threshold for android devices.
     */
    public void setShakingThresholdForAndroid(int androidThreshold) {
        BugReporting.setShakingThreshold(androidThreshold);
    }

    /**
     * Enables all Instabug functionality
     */
    public void enable() {
        Instabug.enable();
    }

    /**
     * Disables all Instabug functionality
     */
    public void disable() {
        Instabug.disable();
    }


}
