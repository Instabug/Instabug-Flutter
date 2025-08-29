import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/enum_converter.dart';
import 'package:instabug_flutter/src/utils/feature_flags_manager.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_test.mocks.dart';

@GenerateMocks([
  InstabugHostApi,
  IBGBuildInfo,
  ScreenNameMasker,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockInstabugHostApi();
  final mBuildInfo = MockIBGBuildInfo();
  final mScreenNameMasker = MockScreenNameMasker();

  setUpAll(() {
    Instabug.$setHostApi(mHost);
    FeatureFlagsManager().$setHostApi(mHost);
    IBGBuildInfo.setInstance(mBuildInfo);
    ScreenNameMasker.setInstance(mScreenNameMasker);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await Instabug.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[isEnabled] should call host method', () async {
    const expected = true;
    when(mHost.isEnabled()).thenAnswer((_) async => expected);

    final actual = await Instabug.isEnabled();

    verify(
      mHost.isEnabled(),
    ).called(1);
    expect(actual, expected);
  });

  test('[isBuilt] should call host method', () async {
    const expected = true;
    when(mHost.isBuilt()).thenAnswer((_) async => expected);

    final actual = await Instabug.isBuilt();

    verify(
      mHost.isBuilt(),
    ).called(1);

    expect(actual, expected);
  });

  test('[start] should call host method', () async {
    const token = "068ba9a8c3615035e163dc5f829c73be";
    const events = [InvocationEvent.shake, InvocationEvent.screenshot];
    when(mHost.isW3CFeatureFlagsEnabled()).thenAnswer(
      (_) => Future.value({
        "isW3cExternalTraceIDEnabled": true,
        "isW3cExternalGeneratedHeaderEnabled": true,
        "isW3cCaughtHeaderEnabled": true,
      }),
    );
    when(mHost.getNetworkBodyMaxSize()).thenAnswer(
      (_) => Future.value(10240),
    );
    await Instabug.init(
      token: token,
      invocationEvents: events,
    );

    verify(
      mHost.init(token, events.mapToString(), LogLevel.error.toString(), null),
    ).called(1);
  });

  test(
      '[setScreenNameMaskingCallback] should set masking callback on screen name masker',
      () async {
    String callback(String screen) => 'REDACTED/$screen';

    Instabug.setScreenNameMaskingCallback(callback);

    verify(mScreenNameMasker.setMaskingCallback(callback)).called(1);
  });

  test('[show] should call host method', () async {
    await Instabug.show();

    verify(
      mHost.show(),
    ).called(1);
  });

  test('[showWelcomeMessageWithMode] should call host method', () async {
    const mode = WelcomeMessageMode.beta;

    await Instabug.showWelcomeMessageWithMode(mode);

    verify(
      mHost.showWelcomeMessageWithMode(mode.toString()),
    ).called(1);
  });

  test('[identifyUser] should call host method with no ID', () async {
    const email = "inst@bug.com";
    const name = "Instabug";

    await Instabug.identifyUser(email, name);

    verify(
      mHost.identifyUser(email, name, null),
    ).called(1);
  });

  test('[identifyUser] should call host method with an ID', () async {
    const email = "inst@bug.com";
    const name = "Instabug";
    const id = "123";

    await Instabug.identifyUser(email, name, id);

    verify(
      mHost.identifyUser(email, name, id),
    ).called(1);
  });

  test('[setUserData] should call host method', () async {
    const data = "User Data";

    await Instabug.setUserData(data);

    verify(
      mHost.setUserData(data),
    ).called(1);
  });

  test('[logUserEvent] should call host method', () async {
    const event = "User Event";

    await Instabug.logUserEvent(event);

    verify(
      mHost.logUserEvent(event),
    ).called(1);
  });

  test('[logOut] should call host method', () async {
    await Instabug.logOut();

    verify(
      mHost.logOut(),
    ).called(1);
  });

  test('[setLocale] should call host method', () async {
    const locale = IBGLocale.arabic;

    await Instabug.setLocale(locale);

    verify(
      mHost.setLocale(locale.toString()),
    ).called(1);
  });

  test('[setColorTheme] should call host method', () async {
    const theme = ColorTheme.dark;

    await Instabug.setColorTheme(theme);

    verify(
      mHost.setColorTheme(theme.toString()),
    ).called(1);
  });

  test('[setWelcomeMessageMode] should call host method', () async {
    const mode = WelcomeMessageMode.beta;

    await Instabug.setWelcomeMessageMode(mode);

    verify(
      mHost.setWelcomeMessageMode(mode.toString()),
    ).called(1);
  });

  test('[setSessionProfilerEnabled] should call host method', () async {
    const enabled = true;

    await Instabug.setSessionProfilerEnabled(enabled);

    verify(
      mHost.setSessionProfilerEnabled(enabled),
    ).called(1);
  });

  test('[setValueForStringWithKey] should call host method', () async {
    const value = "Report It!";
    const key = CustomTextPlaceHolderKey.reportBug;

    await Instabug.setValueForStringWithKey(value, key);

    verify(
      mHost.setValueForStringWithKey(value, key.toString()),
    ).called(1);
  });

  test('[appendTags] should call host method', () async {
    const tags = ["tag-1", "tag-2"];

    await Instabug.appendTags(tags);

    verify(
      mHost.appendTags(tags),
    ).called(1);
  });

  test('[resetTags] should call host method', () async {
    await Instabug.resetTags();

    verify(
      mHost.resetTags(),
    ).called(1);
  });

  test('[getTags] should call host method', () async {
    const tags = ["tag-1", "tag-2"];
    when(mHost.getTags()).thenAnswer((_) async => tags);

    final result = await Instabug.getTags();

    expect(result, tags);
    verify(
      mHost.getTags(),
    ).called(1);
  });

  test('[addFeatureFlags] should call host method', () async {
    await Instabug.addFeatureFlags([
      FeatureFlag(name: 'name1', variant: 'variant1'),
      FeatureFlag(name: 'name2', variant: 'variant2'),
    ]);

    verify(
      mHost.addFeatureFlags(<String, String>{
        "name1": "variant1",
        "name2": "variant2",
      }),
    ).called(1);
  });

  test('[removeFeatureFlags] should call host method', () async {
    const featureFlags = ["exp-1", "exp-2"];

    await Instabug.removeFeatureFlags(featureFlags);

    verify(
      mHost.removeFeatureFlags(featureFlags),
    ).called(1);
  });

  test('[clearAllFeatureFlags] should call host method', () async {
    await Instabug.clearAllFeatureFlags();

    verify(
      mHost.removeAllFeatureFlags(),
    ).called(1);
  });

  test('[setUserAttribute] should call host method', () async {
    const key = "attr-key";
    const attribute = "User Attribute";

    await Instabug.setUserAttribute(attribute, key);

    verify(
      mHost.setUserAttribute(attribute, key),
    ).called(1);
  });

  test('[removeUserAttribute] should call host method', () async {
    const key = "attr-key";

    await Instabug.removeUserAttribute(key);

    verify(
      mHost.removeUserAttribute(key),
    ).called(1);
  });

  test('[getUserAttributeForKey] should call host method', () async {
    const key = "attr-key";
    const attribute = "User Attribute";
    when(mHost.getUserAttributeForKey(key)).thenAnswer((_) async => attribute);

    final result = await Instabug.getUserAttributeForKey(key);

    expect(result, attribute);
    verify(
      mHost.getUserAttributeForKey(key),
    ).called(1);
  });

  test('[getUserAttributes] should call host method', () async {
    const attributes = {"attr-key": "User Attribute"};
    when(mHost.getUserAttributes()).thenAnswer((_) async => attributes);

    final result = await Instabug.getUserAttributes();

    expect(result, attributes);
    verify(
      mHost.getUserAttributes(),
    ).called(1);
  });

  test('[setReproStepsConfig] should call host method', () async {
    const bug = ReproStepsMode.enabled;
    const crash = ReproStepsMode.enabledWithNoScreenshots;
    const sessionReplay = ReproStepsMode.disabled;

    when(mBuildInfo.isIOS).thenReturn(false);

    await Instabug.setReproStepsConfig(
      bug: bug,
      crash: crash,
      sessionReplay: sessionReplay,
    );

    verify(
      mHost.setReproStepsConfig(
        bug.toString(),
        crash.toString(),
        sessionReplay.toString(),
      ),
    ).called(1);
  });

  test(
      '[setReproStepsConfig] should use [all] for [bug] and [crash] if present',
      () async {
    const all = ReproStepsMode.enabled;

    await Instabug.setReproStepsConfig(all: all);

    verify(
      mHost.setReproStepsConfig(all.toString(), all.toString(), all.toString()),
    ).called(1);
  });

  test('[setCustomBrandingImage] should call host method', () async {
    const lightImage = 'images/light_logo.jpeg';
    const darkImage = 'images/dark_logo.jpeg';

    await Instabug.setCustomBrandingImage(
      light: const AssetImage(lightImage),
      dark: const AssetImage(darkImage),
    );

    verify(
      mHost.setCustomBrandingImage(lightImage, darkImage),
    ).called(1);
  });

  test('[reportScreenChange] should call host method', () async {
    const screen = "home";

    await Instabug.reportScreenChange(screen);

    verify(
      mHost.reportScreenChange(screen),
    ).called(1);
  });

  test('[setFont] should call host method', () async {
    const font = "fonts/OpenSans-Regular.ttf";
    when(mBuildInfo.isIOS).thenReturn(true);

    await Instabug.setFont(font);

    verify(
      mHost.setFont(font),
    ).called(1);
  });

  test('[addFileAttachmentWithURL] should call host method', () async {
    const path = "/opt/android/logs/";
    const name = "log.txt";

    await Instabug.addFileAttachmentWithURL(path, name);

    verify(
      mHost.addFileAttachmentWithURL(path, name),
    ).called(1);
  });

  test('[addFileAttachmentWithData] should call host method', () async {
    final data = Uint8List.fromList([0]);
    const name = "log.bin";

    await Instabug.addFileAttachmentWithData(data, name);

    verify(
      mHost.addFileAttachmentWithData(data, name),
    ).called(1);
  });

  test('[clearFileAttachments] should call host method', () async {
    await Instabug.clearFileAttachments();

    verify(
      mHost.clearFileAttachments(),
    ).called(1);
  });

  test('[willRedirectToStore] should call host method', () async {
    await Instabug.willRedirectToStore();

    //assert
    verify(
      mHost.willRedirectToStore(),
    ).called(1);
  });

  test('[setFullscreen] should call host method', () async {
    const isEnabled = true;

    await Instabug.setFullscreen(isEnabled);

    verify(
      mHost.setFullscreen(isEnabled),
    ).called(1);
  });

  test('[setFullscreen] should call host method with false', () async {
    const isEnabled = false;

    await Instabug.setFullscreen(isEnabled);

    verify(
      mHost.setFullscreen(isEnabled),
    ).called(1);
  });

  test('[setTheme] should call host method with theme config', () async {
    const themeConfig = ThemeConfig(primaryColor: '#FF0000');

    await Instabug.setTheme(themeConfig);

    verify(
      mHost.setTheme(themeConfig.toMap()),
    ).called(1);
  });
}
