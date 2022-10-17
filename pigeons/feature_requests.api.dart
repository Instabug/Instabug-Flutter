import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class FeatureRequestsApi {
  void show();
  void setEmailFieldRequired(bool isRequired, List<String> actionTypes);
}
