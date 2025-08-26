import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class FeatureFlagsFlutterApi {
  void onW3CFeatureFlagChange(
    bool isW3cExternalTraceIDEnabled,
    bool isW3cExternalGeneratedHeaderEnabled,
    bool isW3cCaughtHeaderEnabled,
  );

  void onNetworkLogBodyMaxSizeChange(int networkBodyMaxSize);
}

@HostApi()
abstract class InstabugHostApi {
  void setEnabled(bool isEnabled);

  bool isEnabled();

  bool isBuilt();

  void init(
    String token,
    List<String> invocationEvents,
    String debugLogsLevel,
    String? appVariant,
  );

  void enableAutoMasking(List<String> autoMasking);

  void show();

  void showWelcomeMessageWithMode(String mode);

  void identifyUser(String email, String? name, String? userId);

  void setUserData(String data);

  void setAppVariant(String appVariant);

  void logUserEvent(String name);

  void logOut();

  void setEnableUserSteps(bool isEnabled);

  void logUserSteps(
    String gestureType,
    String message,
    String? viewName,
  );

  void setLocale(String locale);

  void setColorTheme(String theme);

  void setWelcomeMessageMode(String mode);

  void setSessionProfilerEnabled(bool enabled);

  void setValueForStringWithKey(String value, String key);

  void appendTags(List<String> tags);

  void resetTags();

  @async
  List<String>? getTags();

  void addFeatureFlags(Map<String, String> featureFlagsMap);

  void removeFeatureFlags(List<String> featureFlags);

  void removeAllFeatureFlags();

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

  void registerFeatureFlagChangeListener();

  Map<String, bool> isW3CFeatureFlagsEnabled();

  void willRedirectToStore();

  void setNetworkLogBodyEnabled(bool isEnabled);

  @async
  double? getNetworkBodyMaxSize();

  void setTheme(Map<String, Object> themeConfig);
  void setFullscreen(bool isEnabled);
}
