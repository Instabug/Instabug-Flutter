import 'package:flutter/material.dart';
import 'package:instabug_flutter/instabug_flutter.dart';

/// A widget that wraps the app's routes with [InstabugCaptureScreenLoading] widgets.
///
/// This allows Instabug to automatically capture screen loading times.
class RouteWrapper extends StatelessWidget {
  final Map<String, WidgetBuilder> routes;
  final List<String> exclude;

  final RouteWrapperNavigatorConfig navigatorConfig;
  final RouteWrapperPageBuilderConfig pageBuilderConfig;

  const RouteWrapper({
    Key? key,
    required this.routes,
    required this.exclude,
    this.navigatorConfig = const RouteWrapperNavigatorConfig(),
    this.pageBuilderConfig = const RouteWrapperPageBuilderConfig(),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final excludedRoutes = <String, bool>{};
    for (final route in exclude) {
      excludedRoutes[route] = true;
    }

    return Navigator(
      onGenerateRoute: (settings) {
        final route = routes[settings.name];

        ///Guard case
        if (route == null) return null;

        final screen = route.call(context);

        /// in exclude or already wrapped
        if (excludedRoutes.containsKey(settings.name) ||
            screen is InstabugCaptureScreenLoading) {
          return _getPageRoute(screen, settings);
        }
        return _getPageRoute(
          InstabugCaptureScreenLoading(
            screenName: settings.name ?? "",
            child: screen,
          ),
          settings,
        );
      },
      observers: [InstabugNavigatorObserver() , ...navigatorConfig.observers],
      clipBehavior: navigatorConfig.clipBehavior,
      initialRoute: navigatorConfig.initialRoute,
      onGenerateInitialRoutes: navigatorConfig.onGenerateInitialRoutes,
      onPopPage: navigatorConfig.onPopPage,
      onUnknownRoute: navigatorConfig.onUnknownRoute,
      reportsRouteUpdateToEngine: navigatorConfig.reportsRouteUpdateToEngine,
      requestFocus: navigatorConfig.requestFocus,
      restorationScopeId: navigatorConfig.restorationScopeId,
      routeTraversalEdgeBehavior: navigatorConfig.routeTraversalEdgeBehavior,
      transitionDelegate: navigatorConfig.transitionDelegate,
    );
  }

  PageRouteBuilder _getPageRoute(Widget child, RouteSettings? settings) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondAnimation) => child,
      settings: settings,
      allowSnapshotting: pageBuilderConfig.allowSnapshotting,
      barrierColor: pageBuilderConfig.barrierColor,
      barrierDismissible: pageBuilderConfig.barrierDismissible,
      barrierLabel: pageBuilderConfig.barrierLabel,
      fullscreenDialog: pageBuilderConfig.fullscreenDialog,
      maintainState: pageBuilderConfig.maintainState,
      opaque: pageBuilderConfig.opaque,
      reverseTransitionDuration: pageBuilderConfig.reverseTransitionDuration,
      transitionDuration: pageBuilderConfig.transitionDuration,
      transitionsBuilder: pageBuilderConfig.transitionsBuilder,
    );
  }
}

//-----------------------------------------------------------------------

// class RouteWrapper extends StatelessWidget {
//   final Map<String, WidgetBuilder> routes;
//   final List<String> exclude;
//   final String? initialRoute;
//   final bool Function(Route<dynamic>, dynamic)? onPopPage;
//   final List<Route<dynamic>> Function(NavigatorState, String)
//       onGenerateInitialRoutes;
//   final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
//   final TransitionDelegate<dynamic> transitionDelegate;
//   final bool reportsRouteUpdateToEngine;
//   final Clip clipBehavior;
//   final List<NavigatorObserver> observers;
//   final bool requestFocus;
//   final String? restorationScopeId;
//   final TraversalEdgeBehavior routeTraversalEdgeBehavior;
//
//   final Map<String, Page<dynamic>> pages;
//
//   const RouteWrapper({
//     Key? key,
//     required this.routes,
//     this.initialRoute,
//     this.pages = const <String, Page<dynamic>>{},
//     this.exclude = const [],
//     this.onPopPage,
//     this.onUnknownRoute,
//     this.restorationScopeId,
//     this.onGenerateInitialRoutes = Navigator.defaultGenerateInitialRoutes,
//     this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
//     this.reportsRouteUpdateToEngine = false,
//     this.clipBehavior = Clip.hardEdge,
//     this.observers = const <NavigatorObserver>[],
//     this.requestFocus = true,
//     this.routeTraversalEdgeBehavior = kDefaultRouteTraversalEdgeBehavior,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final excludedRoutes = <String, bool>{};
//     for (final route in exclude) {
//       excludedRoutes[route] = true;
//     }
//
//     return Navigator(
//       onGenerateRoute: (settings) {
//         final route = routes[settings.name];
//         final routeFromPages = pages[settings.name];
//
//         ///Guard case
//         if (route == null) return null;
//
//         final screen = route.call(context);
//
//         if (routeFromPages is MaterialPage) {
//           /// in exclude or already wrapped
//           if (excludedRoutes.containsKey(settings.name) ||
//               screen is InstabugCaptureScreenLoading) {
//             return MaterialPageRoute(
//               builder: (context) {
//
//                 InstabugLogger.I.d(
//                   '[RouteWrapper] Screen: <${settings.name}> has been already wrapped.',
//                   tag: APM.tag,
//                 );
//                 return screen;
//               },
//               settings: settings,
//             );
//           }
//           return MaterialPageRoute(
//             builder: (context) {
//
//               InstabugLogger.I.d(
//                 '[RouteWrapper] Screen: <${settings.name}> has been wrapped successfully',
//                 tag: APM.tag,
//               );
//               return InstabugCaptureScreenLoading(
//                 screenName: settings.name ?? "",
//                 child: route.call(context),
//               );
//             },
//             settings: settings,
//           );
//         } else if (routeFromPages is CupertinoPage) {
//           /// in exclude or already wrapped
//           if (excludedRoutes.containsKey(settings.name) ||
//               screen is InstabugCaptureScreenLoading) {
//             return CupertinoPageRoute(
//               builder: (context) {
//
//                 InstabugLogger.I.d(
//                   '[RouteWrapper] Screen: <${settings.name}> has been already wrapped.',
//                   tag: APM.tag,
//                 );
//                 return screen;
//               },
//               settings: settings,
//             );
//           }
//           return CupertinoPageRoute(
//             builder: (context) {
//
//               InstabugLogger.I.d(
//                 '[RouteWrapper] Screen: <${settings.name}> has been wrapped successfully',
//                 tag: APM.tag,
//               );
//               return InstabugCaptureScreenLoading(
//                 screenName: settings.name ?? "",
//                 child: route.call(context),
//               );
//             },
//             settings: settings,
//           );
//         } else {
//           /// in exclude or already wrapped
//           if (excludedRoutes.containsKey(settings.name) ||
//               screen is InstabugCaptureScreenLoading) {
//             return PageRouteBuilder(
//               pageBuilder: (context, animation, secondAnimation) {
//
//                 InstabugLogger.I.d(
//                   '[RouteWrapper] Screen: <${settings.name}> has been already wrapped.',
//                   tag: APM.tag,
//                 );
//                 return screen;
//               },
//               settings: settings,
//             );
//           }
//           PageRouteBuilder(
//             pageBuilder: (context, animation, secondAnimation) {
//
//               InstabugLogger.I.d(
//                 '[RouteWrapper] Screen: <${settings.name}> has been wrapped successfully',
//                 tag: APM.tag,
//               );
//               return InstabugCaptureScreenLoading(
//                 screenName: settings.name ?? "",
//                 child: route.call(context),
//               );
//             },
//             settings: settings,
//           );
//         }
//       },
//       observers: observers,
//       clipBehavior: clipBehavior,
//       initialRoute: initialRoute,
//       onGenerateInitialRoutes: onGenerateInitialRoutes,
//       onPopPage: onPopPage,
//       onUnknownRoute: onUnknownRoute,
//       reportsRouteUpdateToEngine: reportsRouteUpdateToEngine,
//       requestFocus: requestFocus,
//       restorationScopeId: restorationScopeId,
//       routeTraversalEdgeBehavior: routeTraversalEdgeBehavior,
//       transitionDelegate: transitionDelegate,
//     );
//   }
// }

class RouteWrapperNavigatorConfig {
  final String? initialRoute;
  final bool Function(Route<dynamic>, dynamic)? onPopPage;
  final List<Route<dynamic>> Function(NavigatorState, String)
      onGenerateInitialRoutes;
  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final TransitionDelegate<dynamic> transitionDelegate;
  final bool reportsRouteUpdateToEngine;
  final Clip clipBehavior;
  final List<NavigatorObserver> observers;
  final bool requestFocus;
  final String? restorationScopeId;
  final TraversalEdgeBehavior routeTraversalEdgeBehavior;

  const RouteWrapperNavigatorConfig({
    this.initialRoute,
    this.onPopPage,
    this.onUnknownRoute,
    this.restorationScopeId,
    this.onGenerateInitialRoutes = Navigator.defaultGenerateInitialRoutes,
    this.transitionDelegate = const DefaultTransitionDelegate<dynamic>(),
    this.reportsRouteUpdateToEngine = false,
    this.clipBehavior = Clip.hardEdge,
    this.observers = const <NavigatorObserver>[],
    this.requestFocus = true,
    this.routeTraversalEdgeBehavior = kDefaultRouteTraversalEdgeBehavior,
  });
}

Widget _defaultTransitionsBuilder(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return child;
}

class RouteWrapperPageBuilderConfig {
  final Widget Function(
          BuildContext, Animation<double>, Animation<double>, Widget)
      transitionsBuilder;

  final Duration transitionDuration;
  final Duration reverseTransitionDuration;
  final bool opaque;
  final bool barrierDismissible;

  final Color? barrierColor;
  final String? barrierLabel;
  final bool maintainState;
  final bool fullscreenDialog;

  final bool allowSnapshotting;

  const RouteWrapperPageBuilderConfig({
    this.transitionsBuilder = _defaultTransitionsBuilder,
    this.opaque = true,
    this.barrierDismissible = false,
    this.transitionDuration = const Duration(milliseconds: 300),
    this.reverseTransitionDuration = const Duration(milliseconds: 300),
    this.barrierColor,
    this.barrierLabel,
    this.maintainState = true,
    this.fullscreenDialog = false,
    this.allowSnapshotting = true,
  });
}
