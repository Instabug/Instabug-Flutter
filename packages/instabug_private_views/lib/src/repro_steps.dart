import 'package:instabug_private_views/src/generated/instabug_private_view.api.g.dart';
import 'package:instabug_private_views/src/private_views_manager.dart';

// ignore: avoid_classes_with_only_static_members
class ReproSteps {
  static void enableMaskingPrivateViews() {
    final api = InstabugPrivateViewHostApi();
    api.init();
    InstabugPrivateViewFlutterApi.setup(PrivateViewsManager.I);
  }
}
