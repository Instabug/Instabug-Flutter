import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/generated/instabug.api.g.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/enum_converter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'instabug_test.mocks.dart';

@GenerateMocks([
  InstabugHostApi,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockInstabugHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  setUpAll(() {
    Instabug.$setHostApi(mHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await Instabug.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[start] should call host method', () async {
    const token = "068ba9a8c3615035e163dc5f829c73be";
    const events = [InvocationEvent.shake, InvocationEvent.screenshot];

    await Instabug.start(token, events);

    verify(
      mHost.start(token, events.mapToString()),
    ).called(1);
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

  test('[identifyUser] should call host method', () async {
    const email = "inst@bug.com";
    const name = "Instabug";

    await Instabug.identifyUser(email, name);

    verify(
      mHost.identifyUser(email, name),
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

  test('[setPrimaryColor] should call host method', () async {
    const color = Color(0x00000000);

    await Instabug.setPrimaryColor(color);

    verify(
      mHost.setPrimaryColor(color.value),
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

  test('[addExperiments] should call host method', () async {
    const experiments = ["exp-1", "exp-2"];

    await Instabug.addExperiments(experiments);

    verify(
      mHost.addExperiments(experiments),
    ).called(1);
  });

  test('[removeExperiments] should call host method', () async {
    const experiments = ["exp-1", "exp-2"];

    await Instabug.removeExperiments(experiments);

    verify(
      mHost.removeExperiments(experiments),
    ).called(1);
  });

  test('[clearAllExperiments] should call host method', () async {
    await Instabug.clearAllExperiments();

    verify(
      mHost.clearAllExperiments(),
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

  test('[setDebugEnabled] should call host method', () async {
    const enabled = true;
    when(mBuildInfo.isAndroid).thenReturn(true);

    await Instabug.setDebugEnabled(enabled);

    verify(
      mHost.setDebugEnabled(enabled),
    ).called(1);
  });

  test('[setSdkDebugLogsLevel] should call host method', () async {
    const level = IBGSDKDebugLogsLevel.error;

    await Instabug.setSdkDebugLogsLevel(level);

    verify(
      mHost.setSdkDebugLogsLevel(level.toString()),
    ).called(1);
  });

  test('[setReproStepsMode] should call host method', () async {
    const mode = ReproStepsMode.enabled;

    await Instabug.setReproStepsMode(mode);

    verify(
      mHost.setReproStepsMode(mode.toString()),
    ).called(1);
  });

  test('[reportScreenChange] should call host method', () async {
    const screen = "home";

    await Instabug.reportScreenChange(screen);

    verify(
      mHost.reportScreenChange(screen),
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

  test('[enableAndroid] should call host method', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);

    // ignore: deprecated_member_use_from_same_package
    await Instabug.enableAndroid();

    verify(
      mHost.enableAndroid(),
    ).called(1);
  });

  test('[disableAndroid] should call host method', () async {
    when(mBuildInfo.isAndroid).thenReturn(true);

    // ignore: deprecated_member_use_from_same_package
    await Instabug.disableAndroid();

    verify(
      mHost.disableAndroid(),
    ).called(1);
  });
}
