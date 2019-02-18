package com.instabug.instabugflutterexample;

import io.flutter.app.FlutterApplication;
import com.instabug.instabugflutter.InstabugFlutterPlugin;

public class CustomFlutterApplication extends FlutterApplication {
  @Override
  public void onCreate() {
    super.onCreate();

    new InstabugFlutterPlugin().start(CustomFlutterApplication.this, "9582e6cfe34e2b8897f48cfa3b617adb");
  }
}