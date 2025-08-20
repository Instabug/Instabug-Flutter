import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class InstabugPrivateViewFlutterApi {
  List<double> getPrivateViews();
}

@HostApi()
abstract class InstabugPrivateViewHostApi {
  void init();
}
