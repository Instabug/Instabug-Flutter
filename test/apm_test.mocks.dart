// Mocks generated by Mockito 5.4.2 from annotations
// in instabug_flutter/test/apm_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:instabug_flutter/src/generated/apm.api.g.dart' as _i2;
import 'package:instabug_flutter/src/utils/ibg_build_info.dart' as _i5;
import 'package:instabug_flutter/src/utils/ibg_date_time.dart' as _i4;
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

class _FakeDateTime_0 extends _i1.SmartFake implements DateTime {
  _FakeDateTime_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [ApmHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockApmHostApi extends _i1.Mock implements _i2.ApmHostApi {
  MockApmHostApi() {
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
  _i3.Future<void> setScreenLoadingEnabled(bool? arg_isEnabled) =>
      (super.noSuchMethod(
        Invocation.method(
          #setScreenLoadingEnabled,
          [arg_isEnabled],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<bool> isScreenLoadingEnabled() => (super.noSuchMethod(
        Invocation.method(
          #isScreenLoadingEnabled,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<void> setColdAppLaunchEnabled(bool? arg_isEnabled) =>
      (super.noSuchMethod(
        Invocation.method(
          #setColdAppLaunchEnabled,
          [arg_isEnabled],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setAutoUITraceEnabled(bool? arg_isEnabled) =>
      (super.noSuchMethod(
        Invocation.method(
          #setAutoUITraceEnabled,
          [arg_isEnabled],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<String?> startExecutionTrace(
    String? arg_id,
    String? arg_name,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #startExecutionTrace,
          [
            arg_id,
            arg_name,
          ],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);

  @override
  _i3.Future<void> startFlow(String? arg_name) => (super.noSuchMethod(
        Invocation.method(
          #startFlow,
          [arg_name],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setFlowAttribute(
    String? arg_name,
    String? arg_key,
    String? arg_value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setFlowAttribute,
          [
            arg_name,
            arg_key,
            arg_value,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> endFlow(String? arg_name) => (super.noSuchMethod(
        Invocation.method(
          #endFlow,
          [arg_name],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> setExecutionTraceAttribute(
    String? arg_id,
    String? arg_key,
    String? arg_value,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setExecutionTraceAttribute,
          [
            arg_id,
            arg_key,
            arg_value,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> endExecutionTrace(String? arg_id) => (super.noSuchMethod(
        Invocation.method(
          #endExecutionTrace,
          [arg_id],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> startUITrace(String? arg_name) => (super.noSuchMethod(
        Invocation.method(
          #startUITrace,
          [arg_name],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> endUITrace() => (super.noSuchMethod(
        Invocation.method(
          #endUITrace,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> endAppLaunch() => (super.noSuchMethod(
        Invocation.method(
          #endAppLaunch,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> networkLogAndroid(Map<String?, Object?>? arg_data) =>
      (super.noSuchMethod(
        Invocation.method(
          #networkLogAndroid,
          [arg_data],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> startCpUiTrace(
    String? arg_screenName,
    int? arg_microTimeStamp,
    int? arg_traceId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #startCpUiTrace,
          [
            arg_screenName,
            arg_microTimeStamp,
            arg_traceId,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> reportScreenLoadingCP(
    int? arg_startTimeStampMicro,
    int? arg_durationMicro,
    int? arg_uiTraceId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #reportScreenLoadingCP,
          [
            arg_startTimeStampMicro,
            arg_durationMicro,
            arg_uiTraceId,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> endScreenLoadingCP(
    int? arg_timeStampMicro,
    int? arg_uiTraceId,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #endScreenLoadingCP,
          [
            arg_timeStampMicro,
            arg_uiTraceId,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}

/// A class which mocks [IBGDateTime].
///
/// See the documentation for Mockito's code generation for more information.
class MockIBGDateTime extends _i1.Mock implements _i4.IBGDateTime {
  MockIBGDateTime() {
    _i1.throwOnMissingStub(this);
  }

  @override
  DateTime now() => (super.noSuchMethod(
        Invocation.method(
          #now,
          [],
        ),
        returnValue: _FakeDateTime_0(
          this,
          Invocation.method(
            #now,
            [],
          ),
        ),
      ) as DateTime);
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