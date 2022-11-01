import 'package:pigeon/pigeon.dart';

@FlutterApi()
abstract class RepliesFlutterApi {
  void onNewReply();
}

@HostApi()
abstract class RepliesHostApi {
  void setEnabled(bool isEnabled);
  void show();
  void setInAppNotificationsEnabled(bool isEnabled);
  void setInAppNotificationSound(bool isEnabled);
  int getUnreadRepliesCount();
  bool hasChats();
  void bindOnNewReplyCallback();
}
