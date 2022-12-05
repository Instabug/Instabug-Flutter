import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/replies.api.g.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'replies_test.mocks.dart';

@GenerateMocks([
  RepliesHostApi,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockRepliesHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  setUpAll(() {
    Replies.$setHostApi(mHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await Replies.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[show] should call host method', () async {
    await Replies.show();

    verify(
      mHost.show(),
    ).called(1);
  });

  test('[setInAppNotificationsEnabled] should call host method', () async {
    const enabled = true;

    await Replies.setInAppNotificationsEnabled(enabled);

    verify(
      mHost.setInAppNotificationsEnabled(enabled),
    ).called(1);
  });

  test('[setInAppNotificationSound] should call host method', () async {
    const enabled = true;
    when(mBuildInfo.isAndroid).thenReturn(true);

    await Replies.setInAppNotificationSound(enabled);

    verify(
      mHost.setInAppNotificationSound(enabled),
    ).called(1);
  });

  test('[getUnreadRepliesCount] should call host method', () async {
    const count = 10;
    when(mHost.getUnreadRepliesCount()).thenAnswer((_) async => count);

    final result = await Replies.getUnreadRepliesCount();

    expect(result, count);
    verify(
      mHost.getUnreadRepliesCount(),
    ).called(1);
  });

  test('[hasChats] should call host method', () async {
    const hasChats = true;
    when(mHost.hasChats()).thenAnswer((_) async => hasChats);

    final result = await Replies.hasChats();

    expect(result, hasChats);
    verify(
      mHost.hasChats(),
    ).called(1);
  });

  test('[setOnNewReplyReceivedCallback] should call host method', () async {
    await Replies.setOnNewReplyReceivedCallback(() {});

    verify(
      mHost.bindOnNewReplyCallback(),
    ).called(1);
  });
}
