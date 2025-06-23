package com.instabug.flutter.modules;

import android.app.Application;
import android.util.Log;

import androidx.annotation.VisibleForTesting;

import com.instabug.flutter.util.Reflection;
import com.instabug.library.Instabug;
import com.instabug.library.Platform;
import com.instabug.library.invocation.InstabugInvocationEvent;

import java.lang.reflect.Method;

public class InstabugInitializer {
    private final String TAG = InstabugApi.class.getName();
    private static InstabugInitializer instance;

    private InstabugInitializer() {}

    public static InstabugInitializer getInstance() {
        if (instance == null) {
            synchronized (InstabugInitializer.class) {
                if (instance == null) {
                    instance = new InstabugInitializer();
                }
            }
        }
        return instance;
    }

    @VisibleForTesting
    public void setCurrentPlatform() {
        try {
            Method method = Reflection.getMethod(Class.forName("com.instabug.library.Instabug"), "setCurrentPlatform", int.class);
            if (method != null) {
                method.invoke(null, Platform.FLUTTER);
            } else {
                Log.e(TAG, "setCurrentPlatform was not found by reflection");
            }
        } catch (Exception e) {
            Log.e(TAG, "Error setting current platform", e);
        }
    }

    public static class Builder {
        /**
         * Application instance to initialize Instabug.
         */
        private Application application;

        /**
         * The application token obtained from the Instabug dashboard.
         */
        private String applicationToken;

        /**
         * The level of detail in logs that you want to print.
         */
        private int logLevel;

        /**
         * The events that trigger the SDK's user interface.
         */
        private InstabugInvocationEvent[] invocationEvents;

        /**
         * Initialize Instabug SDK with application token and invocation trigger events
         *
         * @param application      Application object for initialization of library
         * @param applicationToken The app's identifying token, available on your dashboard.
         * @param invocationEvents The events that trigger the SDK's user interface.
         *                         <p>Choose from the available events listed in {@link InstabugInvocationEvent}.</p>
         */
        public Builder(Application application, String applicationToken, int logLevel, InstabugInvocationEvent... invocationEvents) {
            this.application = application;
            this.applicationToken = applicationToken;
            this.logLevel = logLevel;
            this.invocationEvents = invocationEvents;
        }

        public void build() {
            try {
                InstabugInitializer.getInstance().setCurrentPlatform();

                Instabug.Builder instabugBuilder = new Instabug.Builder(application, applicationToken, invocationEvents)
                        .setSdkDebugLogsLevel(logLevel);

                instabugBuilder.build();
            } catch (Exception e) {
                Log.e(InstabugInitializer.instance.TAG, "Error building Instabug", e);
            }
        }
    }
}