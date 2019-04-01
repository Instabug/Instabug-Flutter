package com.instabug.instabugflutter;

import android.app.Application;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import com.instabug.bug.BugReporting;
import com.instabug.bug.invocation.Option;
import com.instabug.chat.Chats;
import com.instabug.chat.Replies;
import com.instabug.library.Feature;
import com.instabug.library.Instabug;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.InstabugCustomTextPlaceHolder;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.logging.InstabugLog;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/**
 * InstabugFlutterPlugin
 */
public class InstabugFlutterPlugin implements MethodCallHandler {

    final public static String INVOCATION_EVENT_NONE = "InvocationEvent.none";
    final public static String INVOCATION_EVENT_SCREENSHOT = "InvocationEvent.screenshot";
    final public static String INVOCATION_EVENT_TWO_FINGER_SWIPE_LEFT = "InvocationEvent.twoFingersSwipeLeft";
    final public static String INVOCATION_EVENT_FLOATING_BUTTON = "InvocationEvent.floatingButton";
    final public static String INVOCATION_EVENT_SHAKE = "InvocationEvent.shake";

    private InstabugCustomTextPlaceHolder placeHolder = new InstabugCustomTextPlaceHolder();

    /**
     * Plugin registration.
     */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "instabug_flutter");
        channel.setMethodCallHandler(new InstabugFlutterPlugin());
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        Method[] methods = this.getClass().getMethods();
        boolean isImplemented = false;
        String callMethod = call.method;
        if (callMethod.contains(":")) {
            callMethod = call.method.substring( 0, call.method.indexOf(":"));
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
     * starts the SDK
     *
     * @param application      the application Object
     * @param token            token The token that identifies the app, you can find
     *                         it on your dashboard.
     * @param invocationEvents invocationEvents The events that invoke
     *                         the SDK's UI.
     */
    public void start(Application application, String token, ArrayList<String> invocationEvents) {
        InstabugInvocationEvent[] invocationEventsArray = new InstabugInvocationEvent[invocationEvents.size()];
        for (int i = 0; i < invocationEvents.size(); i++) {
            String key = invocationEvents.get(i);
            invocationEventsArray[i] = ArgsRegistry.getDeserializedValue(key, InstabugInvocationEvent.class);
        }
        new Instabug.Builder(application, token).setInvocationEvents(invocationEventsArray).build();
        enableScreenShotByMediaProjection();
    }


    /**
     * Shows the welcome message in a specific mode.
     *
     * @param welcomeMessageMode An enum to set the welcome message mode to
     *                           live, or beta.
     */
    public void showWelcomeMessageWithMode(String welcomeMessageMode) {
        WelcomeMessage.State resolvedWelcomeMessageMode = ArgsRegistry.getDeserializedValue(
                welcomeMessageMode, WelcomeMessage.State.class);
        Instabug.showWelcomeMessage(resolvedWelcomeMessageMode);
    }

    /**
     * Set the user identity.
     *
     * @param userName  Username.
     * @param userEmail User's default email
     */
    public void identifyUserWithEmail(String userEmail, String userName) {
        Instabug.identifyUser(userEmail, userName);
    }

    /**
     * Sets the default value of the user's email to null and show email field and remove user
     * name from all reports
     * It also reset the chats on device and removes user attributes, user data and completed
     * surveys.
     */
    public void logOut() {
        Instabug.logoutUser();
    }

    /**
     * Change Locale of Instabug UI elements(defaults to English)
     *
     * @param instabugLocale
     */
    public void setLocale(String instabugLocale) {
        Locale resolvedLocale = ArgsRegistry.getDeserializedValue(instabugLocale, Locale.class);
        Instabug.setLocale(resolvedLocale);
    }

    /**
     * Appends a log message to Instabug internal log
     * These logs are then sent along the next uploaded report.
     * All log messages are timestamped
     * Note: logs passed to this method are NOT printed to Logcat
     *
     * @param message the message
     */
    public void logVerbose(String message) {
        InstabugLog.v(message);
    }

    /**
     * Appends a log message to Instabug internal log
     * These logs are then sent along the next uploaded report.
     * All log messages are timestamped
     * Note: logs passed to this method are NOT printed to Logcat
     *
     * @param message the message
     */
    public void logDebug(String message) {
        InstabugLog.d(message);
    }

    /**
     * Appends a log message to Instabug internal log
     * These logs are then sent along the next uploaded report.
     * All log messages are timestamped
     * Note: logs passed to this method are NOT printed to Logcat
     *
     * @param message the message
     */
    public void logInfo(String message) {
        InstabugLog.i(message);
    }

    /**
     * Appends a log message to Instabug internal log
     * These logs are then sent along the next uploaded report.
     * All log messages are timestamped
     * Note: logs passed to this method are NOT printed to Logcat
     *
     * @param message the message
     */
    public void logError(String message) {
        InstabugLog.e(message);
    }

    /**
     * Appends a log message to Instabug internal log
     * These logs are then sent along the next uploaded report.
     * All log messages are timestamped
     * Note: logs passed to this method are NOT printed to Logcat
     *
     * @param message the message
     */
    public void logWarn(String message) {
        InstabugLog.w(message);
    }

    /**
     * Clears Instabug internal log
     */
    public void clearAllLogs() {
        InstabugLog.clearLogs();
    }

    /**
     * Sets the color theme of the SDK's whole UI.
     *
     * @param colorTheme an InstabugColorTheme to set the SDK's UI to.
     */
    public void setColorTheme(String colorTheme) {
        InstabugColorTheme resolvedTheme = ArgsRegistry.getDeserializedValue(colorTheme, InstabugColorTheme.class);
        if (resolvedTheme != null) {
            Instabug.setColorTheme(resolvedTheme);
        }
    }

    /**
     * Appends a set of tags to previously added tags of reported feedback, bug or crash.
     *
     * @param tags An array of tags to append to current tags.
     */
    public void appendTags(ArrayList<String> tags) {
        Instabug.addTags(tags.toArray(new String[0]));
    }

    /**
     * Manually removes all tags of reported feedback, bug or crash.
     */
    public void resetTags() {
        Instabug.resetTags();
    }

    /**
     * Gets all tags of reported feedback, bug or crash.
     *
     * @return An array of tags.
     */
    public ArrayList<String> getTags() {
        return Instabug.getTags();
    }

    /**
     * Set custom user attributes that are going to be sent with each feedback, bug or crash.
     *
     * @param value User attribute value.
     * @param key   User attribute key.
     */
    public void setUserAttribute(String value, String key) {
        Instabug.setUserAttribute(key, value);
    }

    /**
     * Removes a given key and its associated value from user attributes.
     * Does nothing if a key does not exist.
     *
     * @param key The key to remove.
     */
    public void removeUserAttributeForKey(String key) {
        Instabug.removeUserAttribute(key);
    }

    /**
     * Returns the user attribute associated with a given key.
     * @param key The key for which to return the corresponding value.
     * @return The value associated with aKey, or null if no value is associated with aKey.
     */
   public String getUserAttributeForKey(String key) {
       return Instabug.getUserAttribute(key);
   }

    /**
     * Returns all user attributes.
     * @return A new HashMap containing all the currently set user attributes, or an empty HashMap if no user attributes have been set.
     */
   public HashMap<String, String> getUserAttributes() {
       return Instabug.getAllUserAttributes();
   }

    /**
     * invoke sdk manually
     */
    public void show() {
        Handler handler = new Handler(Looper.getMainLooper());
        handler.post(new Runnable() {
            @Override
            public void run() {
                Instabug.show();
            }
        });
    }

     /**
     * invoke sdk manually with desire invocation mode
     *
     * @param invocationMode the invocation mode
     * @param invocationOptions the array of invocation options
     */
     public void invokeWithMode(String invocationMode, List<String> invocationOptions) {
        switch (invocationMode) {
            case "InvocationMode.CHATS" : Chats.show();
                return;
            case "InvocationMode.REPLIES" : Replies.show();
                return;
        }
        int[] options = new int[invocationOptions.size()];
        for (int i = 0; i < invocationOptions.size(); i++) {
           options[i] = ArgsRegistry.getDeserializedValue(invocationOptions.get(i), Integer.class);
        }
        int invMode = ArgsRegistry.getDeserializedValue(invocationMode, Integer.class);
        BugReporting.show(invMode, options);
     }

    /**
     * Logs a user event that happens through the lifecycle of the application.
     * Logged user events are going to be sent with each report, as well as at the end of a session.
     *
     * @param name Event name.
     */
    public void logUserEventWithName(String name) {
        Instabug.logUserEvent(name);
    }

    /**
     * Overrides any of the strings shown in the SDK with custom ones.
     * @param value String value to override the default one.
     * @param forStringWithKey Key of string to override.
     */
    public void setValue(String value, String forStringWithKey) {
        InstabugCustomTextPlaceHolder.Key key = ArgsRegistry.getDeserializedValue(forStringWithKey, InstabugCustomTextPlaceHolder.Key.class);
        placeHolder.set(key, value);
        Instabug.setCustomTextPlaceHolders(placeHolder);
      }

    /**
     * Enables taking screenshots by media projection.
     */
    private void enableScreenShotByMediaProjection() {
        try {
            Method method = getMethod(Class.forName("com.instabug.bug.BugReporting"), "setScreenshotByMediaProjectionEnabled", boolean.class);
            if (method != null) {
                method.invoke(null, true);
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        } catch (IllegalAccessException e) {
            e.printStackTrace();
        } catch (InvocationTargetException e) {
            e.printStackTrace();
        }
    }

    /**
     * Gets the private method that matches the class, method name and parameter types given and making it accessible.
     * For private use only.
     * @param clazz the class the method is in
     * @param methodName the method name
     * @param parameterType list of the parameter types of the method
     * @return the method that matches the class, method name and param types given
     */
    public static Method getMethod(Class clazz, String methodName, Class... parameterType) {
        final Method[] methods = clazz.getDeclaredMethods();
        for (Method method : methods) {
            if (method.getName().equals(methodName) && method.getParameterTypes().length ==
                    parameterType.length) {
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
     * Enable/disable session profiler
     *
     * @param sessionProfilerEnabled desired state of the session profiler feature
     */
    public void setSessionProfilerEnabled(boolean sessionProfilerEnabled) {
        if (sessionProfilerEnabled) {
            Instabug.setSessionProfilerState(Feature.State.ENABLED);
        } else {
            Instabug.setSessionProfilerState(Feature.State.DISABLED);
        }
    }

    /**
     * Set the primary color that the SDK will use to tint certain UI elements in the SDK
     *
     * @param primaryColor The value of the primary color 
     */
    public void setPrimaryColor(final long primaryColor) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                Instabug.setPrimaryColor((int)primaryColor);
            }
        });
    }
}
