package com.instabug.flutter;

import static com.instabug.flutter.InstabugFlutterPlugin.getMethod;

import android.annotation.SuppressLint;
import android.app.Application;
import android.content.Context;
import android.util.Log;

import androidx.annotation.NonNull;
import androidx.annotation.VisibleForTesting;

import com.instabug.bug.BugReporting;
import com.instabug.flutter.generated.InstabugPigeon;
import com.instabug.library.Instabug;
import com.instabug.library.Platform;
import com.instabug.library.invocation.InstabugInvocationEvent;

import java.lang.reflect.Method;
import java.util.List;

public class InstabugApiImpl implements InstabugPigeon.InstabugApi {
    private final String TAG = InstabugApiImpl.class.getName();
    private final Context context;

    InstabugApiImpl(Context context) {
        this.context = context;
    }

    public void start(@NonNull String token, @NonNull List<String> invocationEvents) {
        setCurrentPlatform();
        InstabugInvocationEvent[] invocationEventsArray = new InstabugInvocationEvent[invocationEvents.size()];
        for (int i = 0; i < invocationEvents.size(); i++) {
            String key = invocationEvents.get(i);
            invocationEventsArray[i] = ArgsRegistry.getDeserializedValue(key);
        }

        final Application application = (Application) context;
        new Instabug.Builder(application, token)
                .setInvocationEvents(invocationEventsArray)
                .build();

        enableScreenShotByMediaProjection(true);
    }

    private void setCurrentPlatform() {
        try {
            Method method = getMethod(Class.forName("com.instabug.library.Instabug"), "setCurrentPlatform", int.class);
            if (method != null) {
                Log.i(TAG, "invoking setCurrentPlatform with platform: " + Platform.FLUTTER);
                method.invoke(null, Platform.FLUTTER);
            } else {
                Log.e(TAG, "setCurrentPlatform was not found by reflection");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Enables taking screenshots by media projection.
     */
    @SuppressLint("NewApi")
    @VisibleForTesting
    public static void enableScreenShotByMediaProjection(boolean isEnabled) {
        BugReporting.setScreenshotByMediaProjectionEnabled(isEnabled);
    }
}
