import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class CrashReportingHostApi {
  void setEnabled(bool isEnabled);
  void send(String jsonCrash, bool isHandled);
  void setNDKCrashesEnabled(bool isEnabled);
}
