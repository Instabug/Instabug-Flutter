import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/user_steps/user_step_details.dart';
import 'package:mockito/mockito.dart';

import '../../instabug_test.mocks.dart';

void main() {
  late MockInstabugHostApi mockInstabugHostApi;
  setUp(() {
    mockInstabugHostApi = MockInstabugHostApi();
    Instabug.$setHostApi(mockInstabugHostApi);
  });

  group('InstabugUserSteps Widget', () {
    testWidgets('builds child widget correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: InstabugUserSteps(
            child: Text('Test Widget'),
          ),
        ),
      );

      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('detects tap gestures', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InstabugUserSteps(
            child: GestureDetector(
              onTap: () {},
              child: const Text('Tap Me'),
            ),
          ),
        ),
      );

      final gestureDetector = find.text('Tap Me');
      await tester.tap(gestureDetector);
      await tester.pumpAndSettle();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.tap.toString(),
          any,
          any,
        ),
      ).called(1);
    });

    testWidgets('detects long press gestures', (WidgetTester tester) async {
      return tester.runAsync(() async {
        await tester.pumpWidget(
          MaterialApp(
            home: InstabugUserSteps(
              child: GestureDetector(
                onLongPress: () {},
                onTap: () {},
                child: const Text('Long Press Me'),
              ),
            ),
          ),
        );

        final gestureDetector = find.text('Long Press Me');
        final gesture = await tester.startGesture(
          tester.getCenter(gestureDetector),
        );
        await Future.delayed(const Duration(seconds: 1));

        // Release the gesture
        await gesture.up(timeStamp: const Duration(seconds: 1));

        await tester.pump();

        verify(
          mockInstabugHostApi.logUserSteps(
            GestureType.longPress.toString(),
            any,
            any,
          ),
        ).called(1);
      });
    });

    testWidgets('detects swipe gestures', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InstabugUserSteps(
            child: ListView(
              children: List.generate(50, (index) => Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.fling(find.byType(ListView), const Offset(0, -200), 1000);
      await tester.pumpAndSettle();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.scroll.toString(),
          any,
          any,
        ),
      ).called(1);
    });

    testWidgets('handles pinch gestures', (WidgetTester tester) async {
      return tester.runAsync(() async {
        // Build the widget with a Transform.scale
        await tester.pumpWidget(
          MaterialApp(
            home: InstabugUserSteps(
              child: Transform.scale(
                scale: 1.0,
                child: const Icon(
                  Icons.add,
                  size: 300,
                ),
              ),
            ),
          ),
        );

        // Find the widget to interact with
        final textFinder = find.byIcon(
          Icons.add,
        );
        final pinchStart = tester.getCenter(textFinder);

        // Start two gestures for the pinch (simulate two fingers)
        final gesture1 = await tester.startGesture(pinchStart);
        final gesture2 = await tester.startGesture(
          pinchStart + const Offset(100.0, 0.0),
        ); // Slightly offset for two fingers

        // Simulate the pinch by moving the gestures closer together
        await tester.pump();
        await gesture1.moveTo(pinchStart + const Offset(150.0, 0.0));
        await gesture2.moveTo(pinchStart + const Offset(70.0, 0.0));
        // End the gestures
        await gesture1.up(timeStamp: const Duration(seconds: 1));
        await gesture2.up(timeStamp: const Duration(seconds: 1));

        await tester.pump(const Duration(seconds: 1));

        await Future.delayed(const Duration(seconds: 1));
        verify(
          mockInstabugHostApi.logUserSteps(
            GestureType.pinch.toString(),
            any,
            any,
          ),
        ).called(1);
      });
    });

    testWidgets('logs double tap gestures', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InstabugUserSteps(
            child: GestureDetector(
              onDoubleTap: () {},
              child: const Text('Double Tap Me'),
            ),
          ),
        ),
      );

      final doubleTapFinder = find.text('Double Tap Me');
      await tester.tap(doubleTapFinder);
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(doubleTapFinder);
      await tester.pumpAndSettle();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.doubleTap.toString(),
          any,
          any,
        ),
      ).called(1);
    });

    testWidgets('detects scroll direction correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InstabugUserSteps(
            child: ListView(
              children: List.generate(20, (index) => Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(0, -300));
      await tester.pumpAndSettle();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.scroll.toString(),
          argThat(
            contains('Down'),
          ),
          "ListView",
        ),
      ).called(1);
    });

    testWidgets('detects horizontal scroll', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: InstabugUserSteps(
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(20, (index) => Text('Item $index')),
            ),
          ),
        ),
      );

      await tester.drag(find.byType(ListView), const Offset(-300, 0));
      await tester.pumpAndSettle();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.scroll.toString(),
          argThat(contains('Left')),
          "ListView",
        ),
      ).called(1);
    });
  });
}
