import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class ApmHostApi {

  void setEnabled(bool isEnabled);
  @async
  bool isEnabled();
  void setScreenLoadingMonitoringEnabled(bool isEnabled);
  @async
  bool isScreenLoadingMonitoringEnabled();
  void setColdAppLaunchEnabled(bool isEnabled);
  void setAutoUITraceEnabled(bool isEnabled);

  @async
  String? startExecutionTrace(String id, String name);

  void startFlow(String name);
  void setFlowAttribute(String name, String key, String? value);
  void endFlow(String name);
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

  void startCpUiTrace(String screenName, int microTimeStamp, int traceId);

  void reportScreenLoading(int startTimeStampMicro, int durationMicro, int uiTraceId);

  void endScreenLoading(int timeStampMicro, int uiTraceId);
}
