import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/user_steps/user_step_details.dart';

void main() {
  group('GestureTypeText Extension', () {
    test('GestureType.text returns correct text', () {
      expect(GestureType.swipe.text, 'Swiped');
      expect(GestureType.scroll.text, 'Scrolled');
      expect(GestureType.tap.text, 'Tapped');
      expect(GestureType.pinch.text, 'Pinched');
      expect(GestureType.longPress.text, 'Long Pressed');
      expect(GestureType.doubleTap.text, 'Double Tapped');
    });
  });

  group('UserStepDetails', () {
    test('key returns correct value', () {
      final widget = Container(key: const ValueKey('testKey'));
      final element = widget.createElement();
      final details = UserStepDetails(
        element: element,
        isPrivate: false,
      );

      expect(details.key, 'testKey');
    });

    test('widgetName identifies widget types correctly', () {
      const inkWell = InkWell(
        child: Text('Child'),
      );
      final detailsInkWell = UserStepDetails(
        element: inkWell.createElement(),
        isPrivate: false,
      );
      expect(detailsInkWell.widgetName, "Text Wrapped with InkWell");

      final gestureDetector = GestureDetector(
        child: const Icon(Icons.add),
      );
      final detailsGestureDetector = UserStepDetails(
        element: gestureDetector.createElement(),
        isPrivate: false,
      );
      expect(
        detailsGestureDetector.widgetName,
        "Icon Wrapped with GestureDetector",
      );
    });

    test('message constructs correctly with gestureType', () {
      final widget = Container(key: const ValueKey('testKey'));
      final element = widget.createElement();

      final details = UserStepDetails(
        element: element,
        isPrivate: false,
        gestureType: GestureType.tap,
      );

      expect(
        details.message,
        " Container  with key 'testKey'",
      );
    });

    test('_getWidgetSpecificDetails handles slider widgets', () {
      final slider = Slider(value: 0.5, onChanged: (_) {});
      final element = slider.createElement();

      final details = UserStepDetails(
        element: element,
        isPrivate: false,
        gestureType: GestureType.tap,
      );

      expect(
        details.message,
        contains(" Slider  to '0.5'"),
      );
    });

    test('_getWidgetSpecificDetails handles null widget gracefully', () {
      final details = UserStepDetails(
        element: null,
        isPrivate: false,
      );

      expect(details.message, isNull);
    });

    test('widgetName handles null child gracefully in InkWell', () {
      const inkWell = InkWell();
      final details = UserStepDetails(
        element: inkWell.createElement(),
        isPrivate: false,
      );
      expect(details.widgetName, "InkWell");
    });

    test('message includes additional metadata when gestureMetaData is empty',
        () {
      final widget = Container(key: const ValueKey('testKey'));
      final element = widget.createElement();

      final details = UserStepDetails(
        element: element,
        isPrivate: false,
        gestureType: GestureType.tap,
        gestureMetaData: '',
      );

      expect(
        details.message,
        " Container  with key 'testKey'",
      );
    });

    test('widgetName handles GestureDetector without child', () {
      final gestureDetector = GestureDetector();
      final details = UserStepDetails(
        element: gestureDetector.createElement(),
        isPrivate: false,
      );
      expect(details.widgetName, "GestureDetector");
    });
  });
// });
}
