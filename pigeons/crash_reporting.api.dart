import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class CrashReportingApi {
  void setEnabled(bool isEnabled);
  void send(String jsonCrash, bool isHandled);
}
