package com.instabug.flutter.modules;

import android.annotation.SuppressLint;

import androidx.annotation.NonNull;

import com.instabug.featuresrequest.FeatureRequests;
import com.instabug.flutter.generated.FeatureRequestsPigeon;
import com.instabug.flutter.util.ArgsRegistry;

import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;

public class FeatureRequestsApi implements FeatureRequestsPigeon.FeatureRequestsHostApi {

    public static void init(BinaryMessenger messenger) {
        final FeatureRequestsApi api = new FeatureRequestsApi();
        FeatureRequestsPigeon.FeatureRequestsHostApi.setup(messenger, api);
    }

    @Override
    public void show() {
        FeatureRequests.show();
    }

    @SuppressLint("WrongConstant")
    @Override
    public void setEmailFieldRequired(@NonNull Boolean isRequired, @NonNull List<String> actionTypes) {
        int[] actions = new int[actionTypes.size()];
        for (int i = 0; i < actionTypes.size(); i++) {
            actions[i] = ArgsRegistry.actionTypes.get(actionTypes.get(i));
        }

        FeatureRequests.setEmailFieldRequired(isRequired, actions);
    }
}
