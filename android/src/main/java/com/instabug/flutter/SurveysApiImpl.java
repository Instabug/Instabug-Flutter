package com.instabug.flutter;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.library.Feature;
import com.instabug.survey.Surveys;

public class SurveysApiImpl implements SurveysPigeon.SurveysApi {
    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        new Handler(Looper.getMainLooper()).post(new Runnable() {
            @Override
            public void run() {
                if (isEnabled) {
                    Surveys.setState(Feature.State.ENABLED);
                } else {
                    Surveys.setState(Feature.State.DISABLED);
                }
            }
        });
    }

    @Override
    public void showSurveyIfAvailable() {
        Surveys.showSurveyIfAvailable();
    }

    @Override
    public void showSurvey(@NonNull String surveyToken) {
        Surveys.showSurvey(surveyToken);
    }

    @Override
    public void setAutoShowingEnabled(@NonNull Boolean isEnabled) {
        Surveys.setAutoShowingEnabled(isEnabled);
    }

    @Override
    public void setShouldShowWelcomeScreen(@NonNull Boolean shouldShowWelcomeScreen) {
        Surveys.setShouldShowWelcomeScreen(shouldShowWelcomeScreen);
    }

    @Override
    public void setAppStoreURL(@NonNull String appStoreURL) {
        // iOS Only
    }
}
