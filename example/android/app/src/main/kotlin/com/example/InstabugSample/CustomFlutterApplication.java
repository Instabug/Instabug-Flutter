package com.example.InstabugSample;

import io.flutter.app.FlutterApplication;
import com.instabug.instabugflutter.InstabugFlutterPlugin;

import java.util.ArrayList;

public class CustomFlutterApplication extends FlutterApplication {
  @Override
  public void onCreate() {
    super.onCreate();
    ArrayList<String> invocation_events = new ArrayList<>();
    invocation_events.add(InstabugFlutterPlugin.INVOCATION_EVENT_FLOATING_BUTTON);
    InstabugFlutterPlugin instabug = new InstabugFlutterPlugin();
    instabug.start(CustomFlutterApplication.this, "ed6f659591566da19b67857e1b9d40ab", invocation_events);
    instabug.setWelcomeMessageMode("WelcomeMessageMode.disabled");
  }
}
