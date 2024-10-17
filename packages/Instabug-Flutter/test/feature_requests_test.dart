import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/feature_requests.api.g.dart';
import 'package:instabug_flutter/src/utils/enum_converter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'feature_requests_test.mocks.dart';

@GenerateMocks([
  FeatureRequestsHostApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockFeatureRequestsHostApi();

  setUpAll(() {
    FeatureRequests.$setHostApi(mHost);
  });

  test('[show] should call host method', () async {
    await FeatureRequests.show();

    verify(
      mHost.show(),
    ).called(1);
  });

  test('[setEmailFieldRequired] should call host method', () async {
    const required = true;
    const types = [ActionType.requestNewFeature];

    await FeatureRequests.setEmailFieldRequired(required, types);

    verify(
      mHost.setEmailFieldRequired(required, types.mapToString()),
    ).called(1);
  });
}
