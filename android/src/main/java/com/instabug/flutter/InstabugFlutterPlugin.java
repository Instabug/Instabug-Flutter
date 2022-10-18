package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.bug.BugReporting;
import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.generated.BugReportingPigeon;
import com.instabug.flutter.generated.CrashReportingPigeon;
import com.instabug.flutter.generated.FeatureRequestsPigeon;
import com.instabug.flutter.generated.InstabugLogPigeon;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.library.Instabug;

import java.lang.reflect.Method;
import java.util.ArrayList;

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
        RepliesPigeon.RepliesApi.setup(messenger, new RepliesApiImpl(messenger));
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
