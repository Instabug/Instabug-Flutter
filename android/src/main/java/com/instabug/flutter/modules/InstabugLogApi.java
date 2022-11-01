package com.instabug.flutter.modules;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.InstabugLogPigeon;
import com.instabug.library.logging.InstabugLog;

import io.flutter.plugin.common.BinaryMessenger;

public class InstabugLogApi implements InstabugLogPigeon.InstabugLogHostApi {
    public static void init(BinaryMessenger messenger) {
        final InstabugLogApi api = new InstabugLogApi();
        InstabugLogPigeon.InstabugLogHostApi.setup(messenger, api);
    }

    @Override
    public void logVerbose(@NonNull String message) {
        InstabugLog.v(message);
    }

    @Override
    public void logDebug(@NonNull String message) {
        InstabugLog.d(message);
    }

    @Override
    public void logInfo(@NonNull String message) {
        InstabugLog.i(message);
    }

    @Override
    public void logWarn(@NonNull String message) {
        InstabugLog.w(message);
    }

    @Override
    public void logError(@NonNull String message) {
        InstabugLog.e(message);
    }

    @Override
    public void clearAllLogs() {
        InstabugLog.clearLogs();
    }
}
