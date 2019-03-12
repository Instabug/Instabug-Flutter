package com.instabug.instabugflutter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Application;

import com.instabug.library.Instabug;
import com.instabug.library.InstabugColorTheme;
import com.instabug.library.logging.InstabugLog;
import com.instabug.library.internal.module.InstabugLocale;
import com.instabug.library.invocation.InstabugInvocationEvent;
import com.instabug.library.ui.onboarding.WelcomeMessage;

import java.lang.reflect.Array;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import android.os.Handler;
import android.os.Looper;
import android.util.Log;


// import com.instabug.library.InstabugColorTheme;
// import com.instabug.library.InstabugCustomTextPlaceHolder;
// import com.instabug.library.internal.module.InstabugLocale;
// import com.instabug.library.ui.onboarding.WelcomeMessage;

/** InstabugFlutterPlugin */
public class InstabugFlutterPlugin implements MethodCallHandler {

  final public static String INVOCATION_EVENT_NONE = "InvocationEvent.none";
  final public static String INVOCATION_EVENT_SCREENSHOT = "InvocationEvent.screenshot";
  final public static String INVOCATION_EVENT_TWO_FINGER_SWIPE_LEFT = "InvocationEvent.twoFingersSwipeLeft";
  final public static String INVOCATION_EVENT_FLOATING_BUTTON = "InvocationEvent.floatingButton";
  final public static String INVOCATION_EVENT_SHAKE = "InvocationEvent.shake";

  private Map<String, Object> constants = getConstants();

  /** Plugin registration. */
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
        HashMap<String, String> map = new HashMap<>();
        if (call.arguments != null) {
          map = (HashMap<String, String>) call.arguments;
        }
        Iterator iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
          Map.Entry pair = (Map.Entry)iterator.next();
          tempParamValues.add(pair.getValue());
          iterator.remove();
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
   * @param application the application Object
   * @param token token The token that identifies the app, you can find
   * it on your dashboard.
   * @param invocationEvents invocationEvents The events that invoke
   * the SDK's UI.
   */
  public void start(Application application, String token, ArrayList<String> invocationEvents) {
    InstabugInvocationEvent[] invocationEventsArray = new InstabugInvocationEvent[invocationEvents.size()];
    for (int i = 0; i < invocationEvents.size(); i++) {
      invocationEventsArray[i] = (InstabugInvocationEvent)constants.get(invocationEvents.get(i));
    }
    new Instabug.Builder(application, token).setInvocationEvents(invocationEventsArray).build();
  }


  /**
   * Shows the welcome message in a specific mode.
   *
   * @param welcomeMessageMode An enum to set the welcome message mode to
   *                          live, or beta.
  */
  public void showWelcomeMessageWithMode(String welcomeMessageMode) {
      Instabug.showWelcomeMessage((WelcomeMessage.State) constants.get(welcomeMessageMode));
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
         Instabug.changeLocale((Locale) constants.get(instabugLocale));
    }


   /**
    * Appends a log message to Instabug internal log
    * These logs are then sent along the next uploaded report.
    * All log messages are timestamped
    * Note: logs passed to this method are NOT printed to Logcat
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
    * @param message the message
    */
     public void logInfo(String message) {
        InstabugLog.i(message);
   }

    /**
     * Sets the color theme of the SDK's whole UI.
     * @param colorTheme an InstabugColorTheme to set the SDK's UI to.
     */
   public void setColorTheme(String colorTheme) {
         Instabug.setColorTheme((InstabugColorTheme) constants.get(colorTheme));
   }

    /**
     * Appends a set of tags to previously added tags of reported feedback, bug or crash.
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
     * @return An array of tags.
     */
   public ArrayList<String> getTags() {
      return Instabug.getTags();
   }

    /**
     * Set custom user attributes that are going to be sent with each feedback, bug or crash.
     * @param value User attribute value.
     * @param key User attribute key.
     */
   public void setUserAttribute(String value, String key) {
       Instabug.setUserAttribute(key, value);
   }

    /**
     * Removes a given key and its associated value from user attributes.
     * Does nothing if a key does not exist.
     * @param key The key to remove.
     */
   public void removeUserAttributeForKey(String key) {
       Instabug.removeUserAttribute(key);
   }

  public Map<String, Object> getConstants() {
    final Map<String, Object> constants = new HashMap<>();
    constants.put("InvocationEvent.none", InstabugInvocationEvent.NONE);
    constants.put("InvocationEvent.screenshot", InstabugInvocationEvent.SCREENSHOT);
    constants.put("InvocationEvent.twoFingersSwipeLeft", InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT);
    constants.put("InvocationEvent.floatingButton", InstabugInvocationEvent.FLOATING_BUTTON);
    constants.put("InvocationEvent.shake", InstabugInvocationEvent.SHAKE);

    constants.put("WelcomeMessageMode.live", WelcomeMessage.State.LIVE);
    constants.put("WelcomeMessageMode.beta", WelcomeMessage.State.BETA);
    constants.put("WelcomeMessageMode.disabled", WelcomeMessage.State.DISABLED);

    constants.put("ColorTheme.dark", InstabugColorTheme.InstabugColorThemeDark);
    constants.put("ColorTheme.light", InstabugColorTheme.InstabugColorThemeLight);

    constants.put("Locale.Arabic",
            new Locale(InstabugLocale.ARABIC.getCode(), InstabugLocale.ARABIC.getCountry()));
    constants.put("Locale.ChineseSimplified",
            new Locale(InstabugLocale.SIMPLIFIED_CHINESE.getCode(), InstabugLocale.SIMPLIFIED_CHINESE.getCountry()));
    constants.put("Locale.ChineseTraditional",
            new Locale(InstabugLocale.TRADITIONAL_CHINESE.getCode(), InstabugLocale.TRADITIONAL_CHINESE.getCountry()));
    constants.put("Locale.Czech",
            new Locale(InstabugLocale.CZECH.getCode(), InstabugLocale.CZECH.getCountry()));
    constants.put("Locale.Danish",
            new Locale(InstabugLocale.DANISH.getCode(), InstabugLocale.DANISH.getCountry()));
    constants.put("Locale.Dutch",
            new Locale(InstabugLocale.NETHERLANDS.getCode(), InstabugLocale.NETHERLANDS.getCountry()));
    constants.put("Locale.English",
            new Locale(InstabugLocale.ENGLISH.getCode(), InstabugLocale.ENGLISH.getCountry()));
    constants.put("Locale.French",
            new Locale(InstabugLocale.FRENCH.getCode(), InstabugLocale.FRENCH.getCountry()));
    constants.put("Locale.German",
            new Locale(InstabugLocale.GERMAN.getCode(), InstabugLocale.GERMAN.getCountry()));
    constants.put("Locale.Italian",
            new Locale(InstabugLocale.ITALIAN.getCode(), InstabugLocale.ITALIAN.getCountry()));
    constants.put("Locale.Japanese",
            new Locale(InstabugLocale.JAPANESE.getCode(), InstabugLocale.JAPANESE.getCountry()));
    constants.put("Locale.Korean",
            new Locale(InstabugLocale.KOREAN.getCode(), InstabugLocale.KOREAN.getCountry()));
    constants.put("Locale.Polish",
            new Locale(InstabugLocale.POLISH.getCode(), InstabugLocale.POLISH.getCountry()));
    constants.put("Locale.PortugueseBrazil",
            new Locale(InstabugLocale.PORTUGUESE_BRAZIL.getCode(), InstabugLocale.PORTUGUESE_BRAZIL.getCountry()));
    constants.put("Locale.Russian",
            new Locale(InstabugLocale.RUSSIAN.getCode(), InstabugLocale.RUSSIAN.getCountry()));
    constants.put("Locale.Spanish",
            new Locale(InstabugLocale.SPANISH.getCode(), InstabugLocale.SPANISH.getCountry()));
    constants.put("Locale.Swedish",
            new Locale(InstabugLocale.SWEDISH.getCode(), InstabugLocale.SWEDISH.getCountry()));
    constants.put("Locale.Turkish",
            new Locale(InstabugLocale.TURKISH.getCode(), InstabugLocale.TURKISH.getCountry()));

    return constants;
  }
}
