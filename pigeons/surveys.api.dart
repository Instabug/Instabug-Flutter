import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class SurveysApi {
  void setEnabled(bool isEnabled);
  void showSurveyIfAvailable();
  void showSurvey(String surveyToken);
  void setAutoShowingEnabled(bool isEnabled);
  void setShouldShowWelcomeScreen(bool shouldShowWelcomeScreen);
  void setAppStoreURL(String appStoreURL);
}
