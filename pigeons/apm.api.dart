import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class ApmHostApi {
  void setEnabled(bool isEnabled);
  void setColdAppLaunchEnabled(bool isEnabled);
  void setAutoUITraceEnabled(bool isEnabled);
  void setLogLevel(String level);
  String? startExecutionTrace(String id, String name);
  void setExecutionTraceAttribute(
    String id,
    String key,
    String value,
  );
  void endExecutionTrace(String id);
  void startUITrace(String name);
  void endUITrace();
  void endAppLaunch();
  void networkLogAndroid(Map<String, Object> data);
}
