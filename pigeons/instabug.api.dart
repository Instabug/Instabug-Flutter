import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class FeatureFlagsFlutterApi {
  void onW3CFeatureFlagChange(bool isW3ExternalTraceIDEnabled,
      bool isW3ExternalGeneratedHeaderEnabled, bool isW3CaughtHeaderEnabled);
}

@HostApi()
abstract class InstabugHostApi {
  void setEnabled(bool isEnabled);
  bool isEnabled();
  bool isBuilt();
  void init(String token, List<String> invocationEvents, String debugLogsLevel);

  void show();
  void showWelcomeMessageWithMode(String mode);

  void identifyUser(String email, String? name, String? userId);
  void setUserData(String data);
  void logUserEvent(String name);
  void logOut();

  void setLocale(String locale);
  void setColorTheme(String theme);
  void setWelcomeMessageMode(String mode);
  void setPrimaryColor(int color);
  void setSessionProfilerEnabled(bool enabled);
  void setValueForStringWithKey(String value, String key);

  void appendTags(List<String> tags);
  void resetTags();

  @async
  List<String>? getTags();

  void addExperiments(List<String> experiments);
  void removeExperiments(List<String> experiments);
  void clearAllExperiments();

  void setUserAttribute(String value, String key);
  void removeUserAttribute(String key);

  @async
  String? getUserAttributeForKey(String key);

  @async
  Map<String, String>? getUserAttributes();

  void setReproStepsConfig(
    String? bugMode,
    String? crashMode,
    String? sessionReplayMode,
  );
  void reportScreenChange(String screenName);

  void setCustomBrandingImage(String light, String dark);
  void setFont(String font);

  void addFileAttachmentWithURL(String filePath, String fileName);
  void addFileAttachmentWithData(Uint8List data, String fileName);
  void clearFileAttachments();

  void networkLog(Map<String, Object> data);

  void bindOnW3CFeatureFlagChangeCallback();

  Map<String, bool> isW3FeatureFlagsEnabled();

  void willRedirectToStore();
}
