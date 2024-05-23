// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:instabug_flutter/instabug_flutter.dart';
// import 'package:instabug_flutter/src/utils/screen_loading/route_wrapper.dart';
// import 'package:mockito/annotations.dart';
//
// import 'route_wrapper_test.mocks.dart';
//
//
// @GenerateMocks([Placeholder])
// void main() {
//
//   late MockPlaceholder mockWidget;
//   setUp(() => mockWidget = MockPlaceholder());
//
//   group('RouteWrapper', () {
//     testWidgets('wraps routes with InstabugCaptureScreenLoading widgets',
//             (WidgetTester tester) async {
//           // Create a map of routes
//           final routes = {
//             '/home': (context) => mockWidget,
//             '/settings': (context) =>  mockWidget,
//           };
//
//           // Create a RouteWrapper widget
//           final routeWrapper = RouteWrapper(
//             routes: routes,
//             child: const MaterialApp(),
//           );
//
//           // Pump the widget into the tester
//           await tester.pumpWidget(routeWrapper);
//
//           // Verify that the routes are wrapped with InstabugCaptureScreenLoading widgets
//           expect(find.byType(InstabugCaptureScreenLoading), findsWidgets);
//         });
//
//     testWidgets('initializes the initial route', (WidgetTester tester) async {
//       // Create a map of routes
//       final routes = {
//         '/home': (context) => mockWidget,
//         '/settings': (context) => mockWidget,
//       };
//
//       // Create a RouteWrapper widget with an initial route
//       final routeWrapper = RouteWrapper(
//         routes: routes,
//         initialRoute: '/settings',
//         child: const MaterialApp(),
//       );
//
//       // Pump the widget into the tester
//       await tester.pumpWidget(routeWrapper);
//
//       // Verify that the initial route is set correctly
//       expect(find.byType(MockPlaceholder), findsOneWidget);
//     });
//   });
// }