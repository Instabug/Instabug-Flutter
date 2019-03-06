package com.instabug.instabugflutter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Application;

import com.instabug.library.Instabug;
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
        HashMap map = (HashMap<String, String>)call.arguments;
        Iterator iterator = map.entrySet().iterator();
        while (iterator.hasNext()) {
          Map.Entry pair = (Map.Entry)iterator.next();
          tempParamValues.add(pair.getValue());
          iterator.remove();
        }
        Object[] paramValues = tempParamValues.toArray();
        try {
          method.invoke(this, paramValues);
        } catch (Exception e) {
          e.printStackTrace();
          result.notImplemented();
        } 
        result.success(null);
        break;
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
    return constants;
  }
}
