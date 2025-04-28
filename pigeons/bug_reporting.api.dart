import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class BugReportingFlutterApi {
  void onSdkInvoke();
  void onSdkDismiss(String dismissType, String reportType);
}

@HostApi()
abstract class BugReportingHostApi {
  void setEnabled(bool isEnabled);
  void show(String reportType, List<String> invocationOptions);
  void setInvocationEvents(List<String> events);
  void setReportTypes(List<String> types);
  void setExtendedBugReportMode(String mode);
  void setInvocationOptions(List<String> options);
  void setFloatingButtonEdge(String edge, int offset);
  void setVideoRecordingFloatingButtonPosition(String position);
  void setShakingThresholdForiPhone(double threshold);
  void setShakingThresholdForiPad(double threshold);
  void setShakingThresholdForAndroid(int threshold);
  void setEnabledAttachmentTypes(
    bool screenshot,
    bool extraScreenshot,
    bool galleryImage,
    bool screenRecording,
  );
  void bindOnInvokeCallback();
  void bindOnDismissCallback();
  void setDisclaimerText(String text);
  void setCommentMinimumCharacterCount(
    int limit,
    List<String>? reportTypes,
  );
  void addUserConsents(
    String key,
    String description,
    bool mandatory,
    bool checked,
    String? actionType,
  );
}
