// Mocks generated by Mockito 5.4.0 from annotations
// in instabug_flutter/test/crash_reporting_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:instabug_flutter/src/generated/crash_reporting.api.g.dart'
    as _i2;
import 'package:instabug_flutter/src/utils/ibg_build_info.dart' as _i4;
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

/// A class which mocks [CrashReportingHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockCrashReportingHostApi extends _i1.Mock
    implements _i2.CrashReportingHostApi {
  MockCrashReportingHostApi() {
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
  _i3.Future<void> send(
    String? arg_jsonCrash,
    bool? arg_isHandled,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #send,
          [
            arg_jsonCrash,
            arg_isHandled,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [IBGBuildInfo].
///
/// See the documentation for Mockito's code generation for more information.
class MockIBGBuildInfo extends _i1.Mock implements _i4.IBGBuildInfo {
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
