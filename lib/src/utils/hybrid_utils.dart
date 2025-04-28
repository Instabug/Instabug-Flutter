import 'package:instabug_flutter/src/generated/instabug_flutter.api.g.dart';
import 'package:instabug_flutter/src/utils/instabug_navigator_observer.dart';

class HybridUtils implements InstabugFlutterApi {

  // Access the singleton instance
  factory HybridUtils() {
    return _instance;
  }
  // Private constructor to prevent instantiation from outside the class
  HybridUtils._();

  // Singleton instance
  static final HybridUtils _instance = HybridUtils._();

  static void $setup(){
    InstabugFlutterApi.setup(_instance); // Use 'this' instead of _instance
  }

  @override
  void reportLastScreenChange() {
    InstabugNavigatorObserver.reportLastScreenChange();
  }


}
