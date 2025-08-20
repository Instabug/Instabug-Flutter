import 'package:flutter_modular/flutter_modular.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter_modular/src/instabug_module.dart';
import 'package:meta/meta.dart';

class InstabugModularManager {
  InstabugModularManager._();

  static InstabugModularManager _instance = InstabugModularManager._();
  static InstabugModularManager get instance => _instance;

  /// Shorthand for [instance]
  static InstabugModularManager get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(InstabugModularManager instance) {
    _instance = instance;
  }

  List<ModularRoute> wrapRoutes(
    List<ModularRoute> routes, {
    String parent = '/',
    bool wrapModules = true,
  }) {
    return routes
        .map(
          (route) => wrapRoute(
            route,
            parent: parent,
            wrapModules: wrapModules,
          ),
        )
        .toList();
  }

  ModularRoute wrapRoute(
    ModularRoute route, {
    String parent = '/',
    bool wrapModules = true,
  }) {
    final fullPath = (parent + route.name).replaceFirst('//', '/');

    if (route is ModuleRoute && route.context is Module && wrapModules) {
      final module = InstabugModule(
        route.context! as Module,
        path: fullPath,
      );

      return route.addModule(
        route.name,
        module: module,
      );
    } else if (route is ParallelRoute && route is! ModuleRoute) {
      ModularChild? child;

      if (route.child != null) {
        child = (context, args) => InstabugCaptureScreenLoading(
              screenName: fullPath,
              child: route.child!(context, args),
            );
      }

      return route.copyWith(
        child: child,
        children: wrapRoutes(
          route.children,
          parent: fullPath,
          wrapModules: wrapModules,
        ),
      );
    }

    return route;
  }
}
