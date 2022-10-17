package com.instabug.flutter;

import androidx.annotation.NonNull;

import com.instabug.featuresrequest.FeatureRequests;
import com.instabug.flutter.generated.FeatureRequestsPigeon;

import java.util.List;

public class FeatureRequestsApiImpl implements FeatureRequestsPigeon.FeatureRequestsApi {

    @Override
    public void show() {
        FeatureRequests.show();
    }

    @Override
    public void setEmailFieldRequired(@NonNull Boolean isRequired, @NonNull List<String> actionTypes) {
        int[] actions = new int[actionTypes.size()];
        for (int i = 0; i < actionTypes.size(); i++) {
            actions[i] = ArgsRegistry.getDeserializedValue(actionTypes.get(i));
        }

        FeatureRequests.setEmailFieldRequired(isRequired, actions);
    }
}
