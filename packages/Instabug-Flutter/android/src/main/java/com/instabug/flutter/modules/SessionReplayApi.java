package com.instabug.flutter.modules;

import androidx.annotation.NonNull;
import com.instabug.flutter.generated.SessionReplayPigeon;
import com.instabug.library.sessionreplay.SessionReplay;
import io.flutter.plugin.common.BinaryMessenger;

public class SessionReplayApi implements SessionReplayPigeon.SessionReplayHostApi {

    public static void init(BinaryMessenger messenger) {
        final SessionReplayApi api = new SessionReplayApi();
        SessionReplayPigeon.SessionReplayHostApi.setup(messenger, api);
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        SessionReplay.setEnabled(isEnabled);
    }

    @Override
    public void setNetworkLogsEnabled(@NonNull Boolean isEnabled) {
        SessionReplay.setNetworkLogsEnabled(isEnabled);
    }

    @Override
    public void setInstabugLogsEnabled(@NonNull Boolean isEnabled) {
        SessionReplay.setIBGLogsEnabled(isEnabled);
    }

    @Override
    public void setUserStepsEnabled(@NonNull Boolean isEnabled) {
        SessionReplay.setUserStepsEnabled(isEnabled);
    }

    @Override
    public void getSessionReplayLink(@NonNull SessionReplayPigeon.Result<String> result) {
        SessionReplay.getSessionReplayLink(result::success);
    }


}
