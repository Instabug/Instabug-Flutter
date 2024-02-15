package com.instabug.flutter.util;

import android.os.AsyncTask;
import android.os.Handler;
import android.os.Looper;

public class ThreadManager {
    // TODO: migrate to Flutter's TaskQueue
    public static void runOnBackground(Runnable runnable) {
        AsyncTask.execute(runnable);
    }

    public static void runOnMainThread(Runnable runnable) {
        new Handler(Looper.getMainLooper()).post(runnable);
    }
}
