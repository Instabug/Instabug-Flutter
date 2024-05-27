// Mocks generated by Mockito 5.4.2 from annotations
// in instabug_flutter/test/feature_requests_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:instabug_flutter/src/generated/feature_requests.api.g.dart'
    as _i2;
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

/// A class which mocks [FeatureRequestsHostApi].
///
/// See the documentation for Mockito's code generation for more information.
class MockFeatureRequestsHostApi extends _i1.Mock
    implements _i2.FeatureRequestsHostApi {
  MockFeatureRequestsHostApi() {
    _i1.throwOnMissingStub(this);
  }

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
  _i3.Future<void> setEmailFieldRequired(
    bool? arg_isRequired,
    List<String?>? arg_actionTypes,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #setEmailFieldRequired,
          [
            arg_isRequired,
            arg_actionTypes,
          ],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}