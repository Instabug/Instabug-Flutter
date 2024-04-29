import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class CrashReportingHostApi {
  void setEnabled(bool isEnabled);

  void send(String jsonCrash, bool isHandled);

  void sendNonFatalError(
    String jsonCrash,
    Map<String, String>? userAttributes,
    String? fingerprint,
    String nonFatalExceptionLevel,
  );
}
