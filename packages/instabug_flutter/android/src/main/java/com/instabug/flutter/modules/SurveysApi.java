package com.instabug.flutter.modules;

import androidx.annotation.NonNull;

import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.flutter.util.ThreadManager;
import com.instabug.library.Feature;
import com.instabug.survey.Survey;
import com.instabug.survey.Surveys;
import com.instabug.survey.callbacks.OnDismissCallback;
import com.instabug.survey.callbacks.OnShowCallback;

import java.util.ArrayList;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;

public class SurveysApi implements SurveysPigeon.SurveysHostApi {
    private final SurveysPigeon.SurveysFlutterApi flutterApi;

    public static void init(BinaryMessenger messenger) {
        final SurveysPigeon.SurveysFlutterApi flutterApi = new SurveysPigeon.SurveysFlutterApi(messenger);
        final SurveysApi api = new SurveysApi(flutterApi);
        SurveysPigeon.SurveysHostApi.setup(messenger, api);
    }

    public SurveysApi(SurveysPigeon.SurveysFlutterApi flutterApi) {
        this.flutterApi = flutterApi;
    }

    @Override
    public void setEnabled(@NonNull Boolean isEnabled) {
        if (isEnabled) {
            Surveys.setState(Feature.State.ENABLED);
        } else {
            Surveys.setState(Feature.State.DISABLED);
        }
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
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        final boolean hasResponded = Surveys.hasRespondToSurvey(surveyToken);

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(hasResponded);
                            }
                        });
                    }
                }
        );
    }

    @Override
    public void getAvailableSurveys(SurveysPigeon.Result<List<String>> result) {
        ThreadManager.runOnBackground(
                new Runnable() {
                    @Override
                    public void run() {
                        List<Survey> surveys = Surveys.getAvailableSurveys();

                        ArrayList<String> titles = new ArrayList<>();
                        for (Survey survey : surveys != null ? surveys : new ArrayList<Survey>()) {
                            titles.add(survey.getTitle());
                        }

                        ThreadManager.runOnMainThread(new Runnable() {
                            @Override
                            public void run() {
                                result.success(titles);
                            }
                        });
                    }
                }
        );
    }

    @Override
    public void bindOnShowSurveyCallback() {
        Surveys.setOnShowCallback(new OnShowCallback() {
            @Override
            public void onShow() {
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterApi.onShowSurvey(new SurveysPigeon.SurveysFlutterApi.Reply<Void>() {
                            @Override
                            public void reply(Void reply) {
                            }
                        });
                    }
                });
            }
        });
    }

    @Override
    public void bindOnDismissSurveyCallback() {
        Surveys.setOnDismissCallback(new OnDismissCallback() {
            @Override
            public void onDismiss() {
                ThreadManager.runOnMainThread(new Runnable() {
                    @Override
                    public void run() {
                        flutterApi.onDismissSurvey(new SurveysPigeon.SurveysFlutterApi.Reply<Void>() {
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
