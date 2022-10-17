import 'package:pigeon/pigeon.dart';

@HostApi()
abstract class RepliesApi {
  void setEnabled(bool isEnabled);
  void show();
  void setInAppNotificationsEnabled(bool isEnabled);
  void setInAppNotificationSound(bool isEnabled);
}
