package com.instabug.instabugflutter;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

import android.app.Application;

import com.instabug.library.Instabug;
import com.instabug.library.invocation.InstabugInvocationEvent;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

// import com.instabug.library.InstabugColorTheme;
// import com.instabug.library.InstabugCustomTextPlaceHolder;
// import com.instabug.library.internal.module.InstabugLocale;
// import com.instabug.library.ui.onboarding.WelcomeMessage;

/** InstabugFlutterPlugin */
public class InstabugFlutterPlugin implements MethodCallHandler {
    
  private ArrayList<InstabugInvocationEvent> invocationEvents = new ArrayList<>();

  /** Plugin registration. */
  public static void registerWith(Registrar registrar) {
    final MethodChannel channel = new MethodChannel(registrar.messenger(), "instabug_flutter");
    channel.setMethodCallHandler(new InstabugFlutterPlugin());
  }

  @Override
  public void onMethodCall(MethodCall call, Result result) {
    Method[] methods = this.getClass().getMethods();
    boolean isImplemented = false;
    for(Method method : methods){
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
  public void start(Application application, String token) {
    new Instabug.Builder(application, token).build();
  }

}
