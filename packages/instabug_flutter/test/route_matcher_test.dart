import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/screen_loading/route_matcher.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  test('[match] should return true when static paths match', () {
    const routePath = '/user/profile';
    const actualPath = '/user/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isTrue);
  });

  test(
      '[match] should return true when static paths match ignoring query parameters',
      () {
    const routePath = '/user/profile?name=John&premium=true';
    const actualPath = '/user/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isTrue);
  });

  test('[match] should return false when static paths do not match', () {
    const routePath = '/user/profile';
    const actualPath = '/user/settings';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isFalse);
  });

  test('[match] should return true when parameterized paths match', () {
    const routePath = '/user/:id/profile';
    const actualPath = '/user/123/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isTrue);
  });

  test('[match] should return false when parameterized paths do not match', () {
    const routePath = '/user/:id/profile';
    const actualPath = '/user/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isFalse);
  });

  test('[match] should return true when paths match with wildcard', () {
    const routePath = '/user/**';
    const actualPath = '/user/123/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isTrue);
  });

  test('[match] should return false when paths do not match with wildcard', () {
    const routePath = '/profile/**';
    const actualPath = '/user/123/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isFalse);
  });

  test(
      '[match] should return true when paths match with wildcard and parameters',
      () {
    const routePath = '/user/:id/friends/:friend/**';
    const actualPath = '/user/123/friends/456/profile/about';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isTrue);
  });

  test(
      '[match] should return false when paths do not match with wildcard and parameters',
      () {
    const routePath = '/user/:id/friends/:friend/profile/**';
    const actualPath = '/user/123/friends/123/about';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isFalse);
  });

  test(
      '[match] should return true when paths match ignoring leading and trailing slashes',
      () {
    const routePath = 'user/:id/friends/:friend/profile/';
    const actualPath = '/user/123/friends/123/profile';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isTrue);
  });

  test(
      '[match] should return false when paths do not match ignoring leading and trailing slashes',
      () {
    const routePath = 'user/:id/friends/:friend/profile/';
    const actualPath = '/user/123/friends/123/about';

    final isMatch = RouteMatcher.I.match(
      routePath: routePath,
      actualPath: actualPath,
    );

    expect(isMatch, isFalse);
  });
}
