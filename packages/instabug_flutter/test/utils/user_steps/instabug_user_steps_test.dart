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

  Widget buildTestWidget(Widget child) {
    return MaterialApp(home: InstabugUserSteps(child: child));
  }

  group('InstabugUserSteps Widget', () {
    testWidgets('builds child widget correctly', (tester) async {
      await tester.pumpWidget(buildTestWidget(const Text('Test Widget')));
      expect(find.text('Test Widget'), findsOneWidget);
    });

    testWidgets('detects tap gestures', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GestureDetector(onTap: () {}, child: const Text('Tap Me')),
        ),
      );

      await tester.tap(find.text('Tap Me'));
      await tester.pumpAndSettle();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.tap.toString(),
          any,
          any,
        ),
      ).called(1);
    });

    testWidgets('detects long press gestures', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          GestureDetector(
            onLongPress: () {},
            child: const Text('Long Press Me'),
          ),
        ),
      );

      final gesture = await tester
          .startGesture(tester.getCenter(find.text('Long Press Me')));
      await tester
          .pump(const Duration(seconds: 2)); // Simulate long press duration
      await gesture.up();

      await tester.pump();

      verify(
        mockInstabugHostApi.logUserSteps(
          GestureType.longPress.toString(),
          any,
          any,
        ),
      ).called(1);
    });

    group('Swipe Gestures', () {
      const scrollOffset = Offset(0, -200);
      const smallScrollOffset = Offset(0, -20);

      testWidgets('detects scroll gestures', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            ListView(children: List.generate(50, (i) => Text('Item $i'))),
          ),
        );

        await tester.fling(find.byType(ListView), scrollOffset, 1000);
        await tester.pumpAndSettle();

        verify(
          mockInstabugHostApi.logUserSteps(
            GestureType.scroll.toString(),
            any,
            any,
          ),
        ).called(1);
      });

      testWidgets('ignores small swipe gestures', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            ListView(children: List.generate(50, (i) => Text('Item $i'))),
          ),
        );

        await tester.fling(find.byType(ListView), smallScrollOffset, 1000);
        await tester.pumpAndSettle();

        verifyNever(
          mockInstabugHostApi.logUserSteps(
            GestureType.scroll.toString(),
            any,
            any,
          ),
        );
      });

      testWidgets('detects horizontal scroll', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(20, (i) => Text('Item $i')),
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

      testWidgets('detects vertical scroll direction', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            ListView(children: List.generate(20, (i) => Text('Item $i'))),
          ),
        );

        await tester.drag(find.byType(ListView), const Offset(0, -300));
        await tester.pumpAndSettle();

        verify(
          mockInstabugHostApi.logUserSteps(
            GestureType.scroll.toString(),
            argThat(contains('Down')),
            "ListView",
          ),
        ).called(1);
      });

      testWidgets('does not log small scroll gestures', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            ListView(children: List.generate(20, (i) => Text('Item $i'))),
          ),
        );

        await tester.drag(find.byType(ListView), const Offset(0, -10));
        await tester.pumpAndSettle();

        verifyNever(
          mockInstabugHostApi.logUserSteps(
            GestureType.scroll.toString(),
            argThat(contains('Down')),
            "ListView",
          ),
        );
      });
    });

    group('Pinch Gestures', () {
      testWidgets('handles pinch gestures', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Transform.scale(
              scale: 1.0,
              child: const Icon(Icons.add, size: 300),
            ),
          ),
        );

        final iconFinder = find.byIcon(Icons.add);
        final pinchStart = tester.getCenter(iconFinder);

        final gesture1 = await tester.startGesture(pinchStart);
        final gesture2 =
            await tester.startGesture(pinchStart + const Offset(100.0, 0.0));

        await tester.pump();
        await gesture1.moveTo(pinchStart + const Offset(150.0, 0.0));
        await gesture2.moveTo(pinchStart + const Offset(70.0, 0.0));

        await gesture1.up();
        await gesture2.up();

        await tester.pump(const Duration(seconds: 1));

        verify(
          mockInstabugHostApi.logUserSteps(
            GestureType.pinch.toString(),
            any,
            any,
          ),
        ).called(1);
      });

      testWidgets('ignores small pinch gestures', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            Transform.scale(
              scale: 1.0,
              child: const Icon(Icons.add, size: 300),
            ),
          ),
        );

        final iconFinder = find.byIcon(Icons.add);
        final pinchStart = tester.getCenter(iconFinder);

        final gesture1 = await tester.startGesture(pinchStart);
        final gesture2 =
            await tester.startGesture(pinchStart + const Offset(100.0, 0.0));

        await tester.pump();
        await gesture1.moveTo(pinchStart + const Offset(10.0, 0.0));
        await gesture2.moveTo(pinchStart + const Offset(110.0, 0.0));

        await gesture1.up();
        await gesture2.up();

        await tester.pump(const Duration(seconds: 1));

        verifyNever(
          mockInstabugHostApi.logUserSteps(
            GestureType.pinch.toString(),
            any,
            any,
          ),
        );
      });
    });

    group('Double Tap Gestures', () {
      testWidgets('logs double tap gestures', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            GestureDetector(
              onDoubleTap: () {},
              child: const Text('Double Tap Me'),
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

      testWidgets('does not log single taps as double taps', (tester) async {
        await tester.pumpWidget(
          buildTestWidget(
            GestureDetector(
              onDoubleTap: () {},
              child: const Text('Double Tap Me'),
            ),
          ),
        );

        final doubleTapFinder = find.text('Double Tap Me');
        await tester.tap(doubleTapFinder);
        await tester.pump(const Duration(milliseconds: 50));

        verifyNever(
          mockInstabugHostApi.logUserSteps(
            GestureType.doubleTap.toString(),
            any,
            any,
          ),
        );
      });
    });
  });
}
