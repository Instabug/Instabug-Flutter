import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/session_replay.api.g.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'session_replay_test.mocks.dart';

@GenerateMocks([
  SessionReplayHostApi,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockSessionReplayHostApi();

  setUpAll(() {
    SessionReplay.$setHostApi(mHost);
  });

  test('[setEnabled] should call host method', () async {
    const isEnabled = true;
    await SessionReplay.setEnabled(isEnabled);

    verify(
      mHost.setEnabled(isEnabled),
    ).called(1);
  });

  test('[setNetworkLogsEnabled] should call host method', () async {
    const isEnabled = true;
    await SessionReplay.setNetworkLogsEnabled(isEnabled);

    verify(
      mHost.setNetworkLogsEnabled(isEnabled),
    ).called(1);
  });

  test('[setInstabugLogsEnabled] should call host method', () async {
    const isEnabled = true;
    await SessionReplay.setInstabugLogsEnabled(isEnabled);

    verify(
      mHost.setInstabugLogsEnabled(isEnabled),
    ).called(1);
  });

  test('[setUserStepsEnabled] should call host method', () async {
    const isEnabled = true;
    await SessionReplay.setUserStepsEnabled(isEnabled);

    verify(
      mHost.setUserStepsEnabled(isEnabled),
    ).called(1);
  });

  test('[getSessionReplayLink] should call host method', () async {
    const link = 'link';
    when(mHost.getSessionReplayLink()).thenAnswer((_) async => link);

    final result = await SessionReplay.getSessionReplayLink();
    expect(result, link);
    verify(
      mHost.getSessionReplayLink(),
    ).called(1);
  });
}
