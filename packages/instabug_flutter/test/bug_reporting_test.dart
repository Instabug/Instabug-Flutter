import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/bug_reporting.api.g.dart';
import 'package:instabug_flutter/src/utils/enum_converter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'bug_reporting_test.mocks.dart';

@GenerateMocks([
  BugReportingHostApi,
  IBGBuildInfo,
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  final mHost = MockBugReportingHostApi();
  final mBuildInfo = MockIBGBuildInfo();

  setUpAll(() {
    BugReporting.$setHostApi(mHost);
    IBGBuildInfo.setInstance(mBuildInfo);
  });

  test('[setEnabled] should call host method', () async {
    const enabled = true;

    await BugReporting.setEnabled(enabled);

    verify(
      mHost.setEnabled(enabled),
    ).called(1);
  });

  test('[show] should call host method', () async {
    const report = ReportType.bug;
    const options = [InvocationOption.commentFieldRequired];

    await BugReporting.show(report, options);

    verify(
      mHost.show(report.toString(), options.mapToString()),
    ).called(1);
  });

  test('[setInvocationEvents] should call host method', () async {
    const events = [InvocationEvent.screenshot];

    await BugReporting.setInvocationEvents(events);

    verify(
      mHost.setInvocationEvents(events.mapToString()),
    ).called(1);
  });

  test('[setReportTypes] should call host method', () async {
    const reports = [ReportType.bug];

    await BugReporting.setReportTypes(reports);

    verify(
      mHost.setReportTypes(reports.mapToString()),
    ).called(1);
  });

  test('[setExtendedBugReportMode] should call host method', () async {
    const mode = ExtendedBugReportMode.disabled;

    await BugReporting.setExtendedBugReportMode(mode);

    verify(
      mHost.setExtendedBugReportMode(mode.toString()),
    ).called(1);
  });

  test('[setInvocationOptions] should call host method', () async {
    const options = [InvocationOption.commentFieldRequired];

    await BugReporting.setInvocationOptions(options);

    verify(
      mHost.setInvocationOptions(options.mapToString()),
    ).called(1);
  });

  test('[setFloatingButtonEdge] should call host method', () async {
    const edge = FloatingButtonEdge.left;
    const offset = 100;

    await BugReporting.setFloatingButtonEdge(edge, offset);

    verify(
      mHost.setFloatingButtonEdge(edge.toString(), offset),
    ).called(1);
  });

  test(
    '[setVideoRecordingFloatingButtonPosition] should call host method',
    () async {
      const position = Position.topLeft;

      await BugReporting.setVideoRecordingFloatingButtonPosition(position);

      verify(
        mHost.setVideoRecordingFloatingButtonPosition(position.toString()),
      ).called(1);
    },
  );

  test('[setShakingThresholdForiPhone] should call host method', () async {
    const threshold = 10.0;
    when(mBuildInfo.isIOS).thenReturn(true);

    await BugReporting.setShakingThresholdForiPhone(threshold);

    verify(
      mHost.setShakingThresholdForiPhone(threshold),
    ).called(1);
  });

  test('[setShakingThresholdForiPad] should call host method', () async {
    const threshold = 10.0;
    when(mBuildInfo.isIOS).thenReturn(true);

    await BugReporting.setShakingThresholdForiPad(threshold);

    verify(
      mHost.setShakingThresholdForiPad(threshold),
    ).called(1);
  });

  test('[setShakingThresholdForAndroid] should call host method', () async {
    const threshold = 10;
    when(mBuildInfo.isAndroid).thenReturn(true);

    await BugReporting.setShakingThresholdForAndroid(threshold);

    verify(
      mHost.setShakingThresholdForAndroid(threshold),
    ).called(1);
  });

  test('[setEnabledAttachmentTypes] should call host method', () async {
    const enabled = true;

    await BugReporting.setEnabledAttachmentTypes(
      enabled,
      enabled,
      enabled,
      enabled,
    );

    verify(
      mHost.setEnabledAttachmentTypes(
        enabled,
        enabled,
        enabled,
        enabled,
      ),
    ).called(1);
  });

  test('[setOnInvokeCallback] should call host method', () async {
    await BugReporting.setOnInvokeCallback(() {});

    verify(
      mHost.bindOnInvokeCallback(),
    ).called(1);
  });

  test('[setOnDismissCallback] should call host method', () async {
    await BugReporting.setOnDismissCallback((dismissType, reportType) {});

    verify(
      mHost.bindOnDismissCallback(),
    ).called(1);
  });

  test('[setDisclaimerText] should call host method', () async {
    const text = 'This is a disclaimer text!';

    await BugReporting.setDisclaimerText(text);

    verify(
      mHost.setDisclaimerText(text),
    ).called(1);
  });

  test('[setCommentMinimumCharacterCount] should call host method', () async {
    const count = 20;
    const reportTypes = [ReportType.bug];

    await BugReporting.setCommentMinimumCharacterCount(count, reportTypes);

    verify(
      mHost.setCommentMinimumCharacterCount(count, reportTypes.mapToString()),
    ).called(1);
  });
}
