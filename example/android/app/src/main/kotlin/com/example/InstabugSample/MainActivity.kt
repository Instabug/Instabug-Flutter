package com.instabug.flutter.example

import com.example.InstabugSample.methodChannel.MethodChannelHandler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            METHOD_CHANNEL_NAME
        )
            .setMethodCallHandler(MethodChannelHandler())
    }

    companion object {
        private const val METHOD_CHANNEL_NAME = "instabug_example_native_method_channel"
    }
}


