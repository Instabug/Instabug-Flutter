import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/surveys.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'surveys_test.mocks.dart';

@GenerateMocks([
  SurveysHostApi,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockSurveysHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  setUpAll(() {
    Surveys.$setHostApi(mHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await Surveys.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[showSurveyIfAvailable] should call host method', () async {
    await Surveys.showSurveyIfAvailable();

    verify(
      mHost.showSurveyIfAvailable(),
    ).called(1);
  });

  test('[showSurvey] should call host method', () async {
    const token = "ZAKSlVz98QdPyOx1wIt8BA";

    await Surveys.showSurvey(token);

    verify(
      mHost.showSurvey(token),
    ).called(1);
  });

  test('[setAutoShowingEnabled] should call host method', () async {
    const enabled = true;

    await Surveys.setAutoShowingEnabled(enabled);

    verify(
      mHost.setAutoShowingEnabled(enabled),
    ).called(1);
  });

  test('[setShouldShowWelcomeScreen] should call host method', () async {
    const shouldShow = true;

    await Surveys.setShouldShowWelcomeScreen(shouldShow);

    verify(
      mHost.setShouldShowWelcomeScreen(shouldShow),
    ).called(1);
  });

  test('[setAppStoreURL] should call host method', () async {
    const url = "http://appstore.com/apple/";
    when(mBuildInfo.isIOS).thenReturn(true);

    await Surveys.setAppStoreURL(url);

    verify(
      mHost.setAppStoreURL(url),
    ).called(1);
  });

  test('[hasRespondedToSurvey] should call host method', () async {
    const token = "ZAKSlVz98QdPyOx1wIt8BA";
    const responded = true;
    when(mHost.hasRespondedToSurvey(token)).thenAnswer((_) async => responded);

    final result = await Surveys.hasRespondedToSurvey(token);

    expect(result, responded);
    verify(
      mHost.hasRespondedToSurvey(token),
    ).called(1);
  });

  test('[getAvailableSurveys] should call host method', () async {
    const surveys = ["survey-1", "survey-2"];
    when(mHost.getAvailableSurveys()).thenAnswer((_) async => surveys);

    final result = await Surveys.getAvailableSurveys();

    expect(result, surveys);
    verify(
      mHost.getAvailableSurveys(),
    ).called(1);
  });

  test('[bindOnShowSurveyCallback] should call host method', () async {
    await Surveys.setOnShowCallback(() {});

    verify(
      mHost.bindOnShowSurveyCallback(),
    ).called(1);
  });

  test('[bindOnDismissSurveyCallback] should call host method', () async {
    await Surveys.setOnDismissCallback(() {});

    verify(
      mHost.bindOnDismissSurveyCallback(),
    ).called(1);
  });
}
