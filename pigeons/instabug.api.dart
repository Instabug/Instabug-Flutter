import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class InstabugHostApi {
  void start(String token, List<String> invocationEvents);

  void show();
  void showWelcomeMessageWithMode(String mode);

  void identifyUser(String email, String? name);
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

  void setDebugEnabled(bool enabled);
  void setSdkDebugLogsLevel(String level);

  void setReproStepsMode(String mode);
  void reportScreenChange(String screenName);

  void addFileAttachmentWithURL(String filePath, String fileName);
  void addFileAttachmentWithData(Uint8List data, String fileName);
  void clearFileAttachments();

  void enableAndroid();
  void disableAndroid();

  void networkLog(Map<String, Object> data);
}
