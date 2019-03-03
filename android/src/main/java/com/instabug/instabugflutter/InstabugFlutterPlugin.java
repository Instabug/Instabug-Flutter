package com.instabug.instabugflutter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Application;

import com.instabug.library.Instabug;
import com.instabug.library.invocation.InstabugInvocationEvent;

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
    for (Method method : methods) {
      if (call.method.equals(method.getName())) {
        isImplemented = true;
        ArrayList<Object> tempParamValues = new ArrayList<>();
        HashMap map = (HashMap<String, String>)call.arguments;
        Iterator it = map.entrySet().iterator();
        while (it.hasNext()) {
          Map.Entry pair = (Map.Entry)it.next();
          tempParamValues.add(pair.getValue());
          it.remove();
        }
        Object[] paramValues = tempParamValues.toArray();
        try {
          method.invoke(this, paramValues);
        } catch (Exception e) {
          e.printStackTrace();
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
     * starts the SDK with the desired
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

  public Map<String, Object> getConstants() {
    final Map<String, Object> constants = new HashMap<>();
    constants.put("InvocationEvent.none", InstabugInvocationEvent.NONE);
    constants.put("InvocationEvent.screenshot", InstabugInvocationEvent.SCREENSHOT);
    constants.put("InvocationEvent.twoFingersSwipeLeft", InstabugInvocationEvent.TWO_FINGER_SWIPE_LEFT);
    constants.put("InvocationEvent.floatingButton", InstabugInvocationEvent.FLOATING_BUTTON);
    constants.put("InvocationEvent.shake", InstabugInvocationEvent.SHAKE);
    return constants;
  }
}
