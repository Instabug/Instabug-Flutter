import 'package:instabug_private_views/src/generated/instabug_private_view.api.g.dart';
import 'package:instabug_private_views/src/private_views_manager.dart';

export 'src/instabug_private_view.dart';
export 'src/instabug_sliver_private_view.dart';

class InstabugPrivateViewManager{
  static void enable() {
    final api = InstabugPrivateViewHostApi();
    api.init();
    InstabugPrivateViewFlutterApi.setup(PrivateViewsManager.I);
  }


}
