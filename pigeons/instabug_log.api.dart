import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class InstabugLogHostApi {
  void logVerbose(String message);
  void logDebug(String message);
  void logInfo(String message);
  void logWarn(String message);
  void logError(String message);
  void clearAllLogs();
}
