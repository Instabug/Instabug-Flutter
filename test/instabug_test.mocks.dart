// Mocks generated by Mockito 5.4.2 from annotations
// in instabug_flutter/test/instabug_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;
import 'dart:typed_data' as _i4;

import 'package:instabug_flutter/src/generated/instabug.api.g.dart' as _i2;
import 'package:instabug_flutter/src/utils/ibg_build_info.dart' as _i5;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [InstabugHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockInstabugHostApi extends _i1.Mock implements _i2.InstabugHostApi {
  MockInstabugHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> setEnabled(bool? arg_isEnabled) => (super.noSuchMethod(
        Invocation.method(
          #setEnabled,
          [arg_isEnabled],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> isEnabled() => (super.noSuchMethod(
        Invocation.method(
          #isEnabled,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<bool> isBuilt() => (super.noSuchMethod(
        Invocation.method(
          #isBuilt,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<void> init(
    String? arg_token,
    List<String?>? arg_invocationEvents,
    String? arg_debugLogsLevel,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #init,
          [
            arg_token,
            arg_invocationEvents,
            arg_debugLogsLevel,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> show() => (super.noSuchMethod(
        Invocation.method(
          #show,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> showWelcomeMessageWithMode(String? arg_mode) =>
      (super.noSuchMethod(
        Invocation.method(
          #showWelcomeMessageWithMode,
          [arg_mode],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> identifyUser(
    String? arg_email,
    String? arg_name,
    String? arg_userId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #identifyUser,
          [
            arg_email,
            arg_name,
            arg_userId,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setUserData(String? arg_data) => (super.noSuchMethod(
        Invocation.method(
          #setUserData,
          [arg_data],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> logUserEvent(String? arg_name) => (super.noSuchMethod(
        Invocation.method(
          #logUserEvent,
          [arg_name],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> logOut() => (super.noSuchMethod(
        Invocation.method(
          #logOut,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setLocale(String? arg_locale) => (super.noSuchMethod(
        Invocation.method(
          #setLocale,
          [arg_locale],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setColorTheme(String? arg_theme) => (super.noSuchMethod(
        Invocation.method(
          #setColorTheme,
          [arg_theme],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setWelcomeMessageMode(String? arg_mode) =>
      (super.noSuchMethod(
        Invocation.method(
          #setWelcomeMessageMode,
          [arg_mode],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setPrimaryColor(int? arg_color) => (super.noSuchMethod(
        Invocation.method(
          #setPrimaryColor,
          [arg_color],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setSessionProfilerEnabled(bool? arg_enabled) =>
      (super.noSuchMethod(
        Invocation.method(
          #setSessionProfilerEnabled,
          [arg_enabled],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setValueForStringWithKey(
    String? arg_value,
    String? arg_key,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setValueForStringWithKey,
          [
            arg_value,
            arg_key,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> appendTags(List<String?>? arg_tags) => (super.noSuchMethod(
        Invocation.method(
          #appendTags,
          [arg_tags],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> resetTags() => (super.noSuchMethod(
        Invocation.method(
          #resetTags,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<String?>?> getTags() => (super.noSuchMethod(
        Invocation.method(
          #getTags,
          [],
        ),
        returnValue: _i3.Future<List<String?>?>.value(),
      ) as _i3.Future<List<String?>?>);

  @override
  _i3.Future<void> addExperiments(List<String?>? arg_experiments) =>
      (super.noSuchMethod(
        Invocation.method(
          #addExperiments,
          [arg_experiments],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> removeExperiments(List<String?>? arg_experiments) =>
      (super.noSuchMethod(
        Invocation.method(
          #removeExperiments,
          [arg_experiments],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> clearAllExperiments() => (super.noSuchMethod(
        Invocation.method(
          #clearAllExperiments,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setUserAttribute(
    String? arg_value,
    String? arg_key,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setUserAttribute,
          [
            arg_value,
            arg_key,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> removeUserAttribute(String? arg_key) => (super.noSuchMethod(
        Invocation.method(
          #removeUserAttribute,
          [arg_key],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<String?> getUserAttributeForKey(String? arg_key) =>
      (super.noSuchMethod(
        Invocation.method(
          #getUserAttributeForKey,
          [arg_key],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);

  @override
  _i3.Future<Map<String?, String?>?> getUserAttributes() => (super.noSuchMethod(
        Invocation.method(
          #getUserAttributes,
          [],
        ),
        returnValue: _i3.Future<Map<String?, String?>?>.value(),
      ) as _i3.Future<Map<String?, String?>?>);

  @override
  _i3.Future<void> setReproStepsConfig(
    String? arg_bugMode,
    String? arg_crashMode,
    String? arg_sessionReplayMode,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setReproStepsConfig,
          [
            arg_bugMode,
            arg_crashMode,
            arg_sessionReplayMode,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> reportScreenChange(String? arg_screenName) =>
      (super.noSuchMethod(
        Invocation.method(
          #reportScreenChange,
          [arg_screenName],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setCustomBrandingImage(
    String? arg_light,
    String? arg_dark,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setCustomBrandingImage,
          [
            arg_light,
            arg_dark,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setFont(String? arg_font) => (super.noSuchMethod(
        Invocation.method(
          #setFont,
          [arg_font],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> addFileAttachmentWithURL(
    String? arg_filePath,
    String? arg_fileName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addFileAttachmentWithURL,
          [
            arg_filePath,
            arg_fileName,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> addFileAttachmentWithData(
    _i4.Uint8List? arg_data,
    String? arg_fileName,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #addFileAttachmentWithData,
          [
            arg_data,
            arg_fileName,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> clearFileAttachments() => (super.noSuchMethod(
        Invocation.method(
          #clearFileAttachments,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> networkLog(Map<String?, Object?>? arg_data) =>
      (super.noSuchMethod(
        Invocation.method(
          #networkLog,
          [arg_data],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> willRedirectToStore() => (super.noSuchMethod(
        Invocation.method(
          #willRedirectToStore,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [IBGBuildInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockIBGBuildInfo extends _i1.Mock implements _i5.IBGBuildInfo {
  MockIBGBuildInfo() {
    _i1.throwOnMissingStub(this);
  }

  @override
  bool get isAndroid => (super.noSuchMethod(
        Invocation.getter(#isAndroid),
        returnValue: false,
      ) as bool);

  @override
  bool get isIOS => (super.noSuchMethod(
        Invocation.getter(#isIOS),
        returnValue: false,
      ) as bool);

  @override
  String get operatingSystem => (super.noSuchMethod(
        Invocation.getter(#operatingSystem),
        returnValue: '',
      ) as String);

  @override
  bool get isReleaseMode => (super.noSuchMethod(
        Invocation.getter(#isReleaseMode),
        returnValue: false,
      ) as bool);

  @override
  bool get isDebugMode => (super.noSuchMethod(
        Invocation.getter(#isDebugMode),
        returnValue: false,
      ) as bool);
}
