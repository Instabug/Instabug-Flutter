package com.instabug.flutter.example

import com.example.InstabugSample.InstabugExampleMethodCallHandler
import com.example.InstabugSample.InstabugExampleMethodCallHandler.Companion.METHOD_CHANNEL_NAME
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class
MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL_NAME).setMethodCallHandler(InstabugExampleMethodCallHandler())
    }
}
