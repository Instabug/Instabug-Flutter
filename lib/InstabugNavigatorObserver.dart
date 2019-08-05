
import 'package:flutter/material.dart';
import 'package:instabug/Instabug.dart';

class InstabugNavigatorObserver extends NavigatorObserver {

  @override
  void didPop(Route route, Route previousRoute) {
    Instabug.reportScreenChange(previousRoute.settings.name.toString());
    print(previousRoute.settings.runtimeType.toString());
  }

  @override
  void didPush(Route route, Route previousRoute) {
    Instabug.reportScreenChange(route.settings.name.toString());
    print(route.settings.name);
  }
  
}