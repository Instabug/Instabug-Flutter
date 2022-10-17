package com.instabug.flutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.instabug.chat.Replies;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.library.Feature;

public class RepliesApiImpl implements RepliesPigeon.RepliesApi {
    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                if (isEnabled) {
                    Replies.setState(Feature.State.ENABLED);
                } else {
                    Replies.setState(Feature.State.DISABLED);
                }
            }
        });
    }

    @Override
    public void show() {
        Replies.show();
    }

    @Override
    public void setInAppNotificationsEnabled(@NonNull Boolean isEnabled) {
        Replies.setInAppNotificationEnabled(isEnabled);
    }

    @Override
    public void setInAppNotificationSound(@NonNull Boolean isEnabled) {
        Replies.setInAppNotificationSound(isEnabled);
    }
}
