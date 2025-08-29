package com.instabug.flutter.modules;

import androidx.annotation.NonNull;

import com.instabug.chat.Replies;
import com.instabug.flutter.generated.RepliesPigeon;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.Feature;

import io.flutter.plugin.common.BinaryMessenger;

public class RepliesApi implements RepliesPigeon.RepliesHostApi {
    private final RepliesPigeon.RepliesFlutterApi flutterApi;

    public static void init(BinaryMessenger messenger) {
        final RepliesPigeon.RepliesFlutterApi flutterApi = new RepliesPigeon.RepliesFlutterApi(messenger);
        final RepliesApi api = new RepliesApi(flutterApi);
        RepliesPigeon.RepliesHostApi.setup(messenger, api);
    }

    public RepliesApi(RepliesPigeon.RepliesFlutterApi flutterApi) {
        this.flutterApi = flutterApi;
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        if (isEnabled) {
            Replies.setState(Feature.State.ENABLED);
        } else {
            Replies.setState(Feature.State.DISABLED);
        }
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

    @Override
    public void getUnreadRepliesCount(RepliesPigeon.Result<Long> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        final long count = Replies.getUnreadRepliesCount();

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(count);
                            }
                        });
                    }
                }
        );
    }

    @Override
    public void hasChats(RepliesPigeon.Result<Boolean> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        final boolean hasChats = Replies.hasChats();

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(hasChats);
                            }
                        });
                    }
                }
        );
    }

    @Override
    public void bindOnNewReplyCallback() {
        Replies.setOnNewReplyReceivedCallback(new Runnable() {
            @Override
            public void run() {
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterApi.onNewReply(new RepliesPigeon.RepliesFlutterApi.Reply<Void>() {
                            @Override
                            public void reply(Void reply) {
                            }
                        });
                    }
                });
            }
        });
    }
}
