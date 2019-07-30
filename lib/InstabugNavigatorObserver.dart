
import 'package:flutter/material.dart';
import 'package:instabug/Instabug.dart';

class InstabugNavigatorObserver extends NavigatorObserver {

  @override
  void didPop(Route route, Route previousRoute) {
    // TODO: implement didPop
    print("POPPED");
    Instabug.reportScreenChange(previousRoute.settings.name.toString());
    print(previousRoute.settings.runtimeType.toString());
  }

  @override
  void didPush(Route route, Route previousRoute) {
    // TODO: implement didPush
    print("PUSHED");
    Instabug.reportScreenChange(route.settings.name.toString());
    print(route.settings.name);
  }

  @override
  void didRemove(Route route, Route previousRoute) {
    // TODO: implement didRemove
    print("REMOVED");
  }

  @override
  void didReplace({Route newRoute, Route oldRoute}) {
    // TODO: implement didReplace
    print("REPLACE");
  }

  @override
  void didStartUserGesture(Route route, Route previousRoute) {
    // TODO: implement didStartUserGesture
    print("STARTEDGESTURES");
  }

  @override
  void didStopUserGesture() {
    // TODO: implement didStopUserGesture
     print("STOPPEDGESTURES");
  }

  @override
  // TODO: implement navigator
  NavigatorState get navigator => null;
}