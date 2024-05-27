// Mocks generated by Mockito 5.4.2 from annotations
// in instabug_flutter/test/instabug_log_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:instabug_flutter/src/generated/instabug_log.api.g.dart' as _i2;
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

/// A class which mocks [InstabugLogHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockInstabugLogHostApi extends _i1.Mock
    implements _i2.InstabugLogHostApi {
  MockInstabugLogHostApi() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> logVerbose(String? arg_message) => (super.noSuchMethod(
        Invocation.method(
          #logVerbose,
          [arg_message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> logDebug(String? arg_message) => (super.noSuchMethod(
        Invocation.method(
          #logDebug,
          [arg_message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> logInfo(String? arg_message) => (super.noSuchMethod(
        Invocation.method(
          #logInfo,
          [arg_message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> logWarn(String? arg_message) => (super.noSuchMethod(
        Invocation.method(
          #logWarn,
          [arg_message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> logError(String? arg_message) => (super.noSuchMethod(
        Invocation.method(
          #logError,
          [arg_message],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<void> clearAllLogs() => (super.noSuchMethod(
        Invocation.method(
          #clearAllLogs,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}