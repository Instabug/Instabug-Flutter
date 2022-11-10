package com.instabug.flutter.util;

import android.os.AsyncTask;

public class ThreadManager {
    // TODO: migrate to Flutter's TaskQueue
    public static void runOnBackground(Runnable runnable) {
        AsyncTask.execute(runnable);
    }
}
