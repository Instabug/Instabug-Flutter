import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class SurveysFlutterApi {
  void onShowSurvey();
  void onDismissSurvey();
}

@HostApi()
abstract class SurveysHostApi {
  void setEnabled(bool isEnabled);
  void showSurveyIfAvailable();
  void showSurvey(String surveyToken);
  void setAutoShowingEnabled(bool isEnabled);
  void setShouldShowWelcomeScreen(bool shouldShowWelcomeScreen);
  void setAppStoreURL(String appStoreURL);

  @async
  bool hasRespondedToSurvey(String surveyToken);

  @async
  List<String> getAvailableSurveys();

  void bindOnShowSurveyCallback();
  void bindOnDismissSurveyCallback();
}
