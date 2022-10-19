package com.instabug.flutter.modules;

import android.os.Handler;
import android.os.Looper;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.library.Feature;
import com.instabug.survey.Survey;
import com.instabug.survey.Surveys;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;

public class SurveysApi implements SurveysPigeon.SurveysHostApi {
    private final SurveysPigeon.SurveysFlutterApi flutterApi;

    public SurveysApi(BinaryMessenger messenger) {
        flutterApi = new SurveysPigeon.SurveysFlutterApi(messenger);
        SurveysPigeon.SurveysHostApi.setup(messenger,this);
    }

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

    @Override
    public void hasRespondedToSurvey(@NonNull String surveyToken, SurveysPigeon.Result<Boolean> result) {
        final boolean hasResponded = Surveys.hasRespondToSurvey(surveyToken);
        result.success(hasResponded);
    }

    @Override
    public void getAvailableSurveys(SurveysPigeon.Result<List<String>> result) {
        List<Survey> surveys = Surveys.getAvailableSurveys();

        ArrayList<String> titles = new ArrayList<>();
        for (Survey survey : surveys != null ? surveys : new ArrayList<Survey>()) {
            titles.add(survey.getTitle());
        }

        result.success(titles);
    }

    @Override
    public void bindOnShowSurveyCallback() {
        Surveys.setOnShowCallback(() -> flutterApi.onShowSurvey(reply -> {}));
    }

    @Override
    public void bindOnDismissSurveyCallback() {
        Surveys.setOnDismissCallback(() -> flutterApi.onDismissSurvey(reply -> {}));
    }
}
