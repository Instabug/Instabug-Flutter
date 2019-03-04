package com.instabug.instabugflutterexample;

import io.flutter.app.FlutterApplication;
import com.instabug.instabugflutter.InstabugFlutterPlugin;

import java.util.ArrayList;

public class CustomFlutterApplication extends FlutterApplication {
  @Override
  public void onCreate() {
    super.onCreate();
    ArrayList<String> invocation_events = new ArrayList<>();
    invocation_events.add(InstabugFlutterPlugin.INVOCATION_EVENT_FLOATING_BUTTON);
    new InstabugFlutterPlugin().start(CustomFlutterApplication.this, "9582e6cfe34e2b8897f48cfa3b617adb", invocation_events);
  }
}