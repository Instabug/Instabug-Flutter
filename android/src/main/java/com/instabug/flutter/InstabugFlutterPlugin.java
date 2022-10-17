package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.bug.BugReporting;
import com.instabug.chat.Replies;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.generated.BugReportingPigeon;
import com.instabug.flutter.generated.CrashReportingPigeon;
import com.instabug.flutter.generated.FeatureRequestsPigeon;
import com.instabug.flutter.generated.InstabugLogPigeon;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.library.Instabug;
import com.instabug.library.model.NetworkLog;

import org.json.JSONException;
import org.json.JSONObject;

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
        ApmPigeon.ApmApi.setup(messenger, new ApmApiImpl());
        BugReportingPigeon.BugReportingApi.setup(messenger, new BugReportingApiImpl(messenger));
        CrashReportingPigeon.CrashReportingApi.setup(messenger, new CrashReportingApiImpl());
        FeatureRequestsPigeon.FeatureRequestsApi.setup(messenger, new FeatureRequestsApiImpl());
        RepliesPigeon.RepliesApi.setup(messenger, new RepliesApiImpl());
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
