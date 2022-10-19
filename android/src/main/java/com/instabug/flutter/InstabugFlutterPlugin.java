package com.instabug.flutter;

import android.content.Context;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.*;
import com.instabug.flutter.modules.*;

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
        InstabugPigeon.InstabugHostApi.setup(messenger, new InstabugApi(applicationContext));
        InstabugLogPigeon.InstabugLogHostApi.setup(messenger, new InstabugLogApi());
        ApmPigeon.ApmHostApi.setup(messenger, new ApmApi());
        BugReportingPigeon.BugReportingHostApi.setup(messenger, new BugReportingApi(messenger));
        CrashReportingPigeon.CrashReportingHostApi.setup(messenger, new CrashReportingApi());
        FeatureRequestsPigeon.FeatureRequestsHostApi.setup(messenger, new FeatureRequestsApi());
        RepliesPigeon.RepliesHostApi.setup(messenger, new RepliesApi(messenger));
        SurveysPigeon.SurveysHostApi.setup(messenger, new SurveysApi(messenger));
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
