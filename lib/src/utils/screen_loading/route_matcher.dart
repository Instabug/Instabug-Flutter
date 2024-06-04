import 'package:meta/meta.dart';

class RouteMatcher {
  RouteMatcher._();

  static RouteMatcher _instance = RouteMatcher._();

  static RouteMatcher get instance => _instance;

  /// Shorthand for [instance]
  static RouteMatcher get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(RouteMatcher instance) {
    _instance = instance;
  }

  /// Checks whether the given [routePath] definition matches the given [actualPath].
  ///
  /// The [routePath] definition can contain parameters in the form of `:param`,
  /// or `**` for a wildcard parameter.
  ///
  /// Returns `true` if the [actualPath] matches the [routePath], otherwise `false`.
  ///
  /// Example:
  /// ```dart
  /// RouteMatcher.I.match('/users', '/users'); // true
  /// RouteMatcher.I.match('/user/:id', '/user/123'); // true
  /// RouteMatcher.I.match('/user/**', '/user/123/profile'); // false
  /// ```
  bool match({
    required String? routePath,
    required String? actualPath,
  }) {
    // null paths are considered equal.
    if (routePath == null || actualPath == null) {
      return routePath == actualPath;
    }

    final routePathSegments = _segmentPath(routePath);
    final actualPathSegments = _segmentPath(actualPath);

    final hasWildcard = routePathSegments.contains('**');

    if (routePathSegments.length != actualPathSegments.length && !hasWildcard) {
      return false;
    }

    for (var i = 0; i < routePathSegments.length; i++) {
      final routeSegment = routePathSegments[i];

      final isWildcard = routeSegment == '**';
      final isParameter = routeSegment.startsWith(':');

      final noMoreActualSegments = i >= actualPathSegments.length;

      if (noMoreActualSegments) {
        // Only wilcard segments match empty segments
        return isWildcard;
      }

      final pathSegment = actualPathSegments[i];

      // If the route segment is a parameter, then segments automatically match.
      if (isParameter) {
        continue;
      }

      // A wildcard matches any path, the assumption is that wildcard paths only
      // appear at the end of the route so we return a match if we reach this point.
      if (isWildcard) {
        return true;
      }

      if (routeSegment != pathSegment) {
        return false;
      }
    }

    return true;
  }

  List<String> _segmentPath(String path) {
    final pathWithoutQuery = path.split('?').first;

    return pathWithoutQuery
        .split('/')
        .where((segment) => segment.isNotEmpty)
        .toList();
  }
}
