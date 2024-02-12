package com.instabug.flutter;

import static com.instabug.flutter.util.MockResult.makeResult;
import static org.junit.Assert.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.mockStatic;
import static org.mockito.Mockito.spy;
import static org.mockito.Mockito.verify;

import com.instabug.flutter.generated.SurveysPigeon;
import com.instabug.flutter.modules.SurveysApi;
import com.instabug.flutter.util.GlobalMocks;
import com.instabug.library.Feature;
import com.instabug.survey.Survey;
import com.instabug.survey.Surveys;
import com.instabug.survey.callbacks.OnDismissCallback;
import com.instabug.survey.callbacks.OnShowCallback;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;
import org.mockito.MockedStatic;

import java.util.Collections;
import java.util.List;

import io.flutter.plugin.common.BinaryMessenger;


public class SurveysApiTest {
    private final BinaryMessenger mMessenger = mock(BinaryMessenger.class);
    private final SurveysPigeon.SurveysFlutterApi flutterApi = new SurveysPigeon.SurveysFlutterApi(mMessenger);
    private final SurveysApi api = new SurveysApi(flutterApi);
    private MockedStatic<Surveys> mSurveys;
    private MockedStatic<SurveysPigeon.SurveysHostApi> mHostApi;

    @Before
    public void setUp() throws NoSuchMethodException {
        mSurveys = mockStatic(Surveys.class);
        mHostApi = mockStatic(SurveysPigeon.SurveysHostApi.class);
        GlobalMocks.setUp();
    }

    @After
    public void cleanUp() {
        mSurveys.close();
        mHostApi.close();
        GlobalMocks.close();
    }

    @Test
    public void testInit() {
        SurveysApi.init(mMessenger);

        mHostApi.verify(() -> SurveysPigeon.SurveysHostApi.setup(eq(mMessenger), any(SurveysApi.class)));
    }

    @Test
    public void testSetEnabledGivenTrue() {
        boolean isEnabled = true;

        api.setEnabled(isEnabled);

        mSurveys.verify(() -> Surveys.setState(Feature.State.ENABLED));
    }

    @Test
    public void testSetEnabledGivenFalse() {
        boolean isEnabled = false;

        api.setEnabled(isEnabled);

        mSurveys.verify(() -> Surveys.setState(Feature.State.DISABLED));
    }

    @Test
    public void testShowSurveyIfAvailable() {
        api.showSurveyIfAvailable();

        mSurveys.verify(Surveys::showSurveyIfAvailable);
    }

    @Test
    public void testShowSurvey() {
        String token = "survey-token";

        api.showSurvey(token);

        mSurveys.verify(() -> Surveys.showSurvey(token));
    }

    @Test
    public void testSetAutoShowingEnabled() {
        boolean isEnabled = true;

        api.setAutoShowingEnabled(isEnabled);

        mSurveys.verify(() -> Surveys.setAutoShowingEnabled(isEnabled));
    }

    @Test
    public void testSetShouldShowWelcomeScreen() {
        boolean shouldShowWelcomeScreen = true;

        api.setShouldShowWelcomeScreen(shouldShowWelcomeScreen);

        mSurveys.verify(() -> Surveys.setShouldShowWelcomeScreen(shouldShowWelcomeScreen));
    }

    @Test
    public void testHasRespondedToSurvey() {
        String token = "survey-token";
        boolean expected = true;
        SurveysPigeon.Result<Boolean> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mSurveys.when(() -> Surveys.hasRespondToSurvey(token)).thenReturn(expected);

        api.hasRespondedToSurvey(token, result);

        verify(result).success(expected);
        mSurveys.verify(() -> Surveys.hasRespondToSurvey(token));
    }

    @Test
    public void testGetAvailableSurveys() {
        List<String> expected = Collections.singletonList("survey1");
        List<Survey> surveys = Collections.singletonList(new Survey(1, "survey1"));
        SurveysPigeon.Result<List<String>> result = spy(makeResult((actual) -> assertEquals(expected, actual)));

        mSurveys.when(Surveys::getAvailableSurveys).thenReturn(surveys);

        api.getAvailableSurveys(result);

        verify(result).success(expected);
        mSurveys.verify(Surveys::getAvailableSurveys);
    }

    @Test
    public void testBindOnShowSurveyCallback() {
        api.bindOnShowSurveyCallback();

        mSurveys.verify(() -> Surveys.setOnShowCallback(any(OnShowCallback.class)));
    }

    @Test
    public void testBindOnDismissSurveyCallback() {
        api.bindOnDismissSurveyCallback();

        mSurveys.verify(() -> Surveys.setOnDismissCallback(any(OnDismissCallback.class)));
    }
}
