import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class FeatureRequestsHostApi {
  void show();
  void setEmailFieldRequired(bool isRequired, List<String> actionTypes);
}
