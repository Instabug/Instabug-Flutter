import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

/// A widget that wraps the app's routes with [InstabugCaptureScreenLoading] widgets.
///
/// This allows Instabug to automatically capture screen loading times.
class RouteWrapper extends StatelessWidget {
  /// The child widget to wrap.
  final Widget child;

  /// A map of routes to wrap.
  final Map<String, WidgetBuilder> routes;

  /// The initial route to navigate to.
  final String? initialRoute;

  final List<String> exclude;

  /// Creates a new instance of [RouteWrapper].
  const RouteWrapper(
      {Key? key,
      required this.child,
      required this.routes,
      this.initialRoute,
      this.exclude = const []})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Navigator(
      observers: [InstabugNavigatorObserver()],
      initialRoute: initialRoute,
      onGenerateRoute: (settings) {
        final route = routes[settings.name];

        if (route == null) return null; //Guard case

        // if(exclude.contains(settings.name)) {
        //   return null ;
        // }
        return MaterialPageRoute(
          builder: (context) {
            debugPrint("[RouteWrapper] Screen: ${settings.name} wrapped: ");
            return InstabugCaptureScreenLoading(
              screenName: settings.name ?? "",
              child: route.call(context),
            );
          },
          settings: settings,
        );
      },
    );
  }
}
