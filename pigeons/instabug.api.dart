import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class InstabugApi {
  void start(String token, List<String> invocationEvents);
}
