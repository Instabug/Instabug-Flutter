package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.ApmPigeon;
import com.instabug.flutter.generated.BugReportingPigeon;
import com.instabug.flutter.generated.CrashReportingPigeon;
import com.instabug.flutter.generated.FeatureRequestsPigeon;
import com.instabug.flutter.generated.InstabugLogPigeon;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.flutter.generated.SurveysPigeon;

import java.lang.reflect.Method;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry.Registrar;

public class InstabugFlutterPlugin implements FlutterPlugin {
    /**
     * Embedding v1
     */
    @SuppressWarnings("deprecation")
    public static void registerWith(Registrar registrar) {
        register(registrar.context().getApplicationContext(), registrar.messenger());
    }

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding binding) {
        register(binding.getApplicationContext(), binding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
    }

    private static void register(Context applicationContext, BinaryMessenger messenger){
        InstabugPigeon.InstabugApi.setup(messenger, new InstabugApiImpl(applicationContext));
        InstabugLogPigeon.InstabugLogApi.setup(messenger, new InstabugLogApiImpl());
        ApmPigeon.ApmApi.setup(messenger, new ApmApiImpl());
        BugReportingPigeon.BugReportingApi.setup(messenger, new BugReportingApiImpl(messenger));
        CrashReportingPigeon.CrashReportingApi.setup(messenger, new CrashReportingApiImpl());
        FeatureRequestsPigeon.FeatureRequestsApi.setup(messenger, new FeatureRequestsApiImpl());
        RepliesPigeon.RepliesApi.setup(messenger, new RepliesApiImpl(messenger));
        SurveysPigeon.SurveysApi.setup(messenger, new SurveysApiImpl(messenger));
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
}
