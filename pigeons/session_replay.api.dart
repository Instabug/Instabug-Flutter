import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class SessionReplayHostApi {
  void setEnabled(bool isEnabled);
  void setNetworkLogsEnabled(bool isEnabled);
  void setInstabugLogsEnabled(bool isEnabled);
  void setUserStepsEnabled(bool isEnabled);
  @async
  String getSessionReplayLink();
}
