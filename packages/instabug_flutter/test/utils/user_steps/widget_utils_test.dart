import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

void main() {
  group('keyToStringValue', () {
    test('returns null for null key', () {
      expect(keyToStringValue(null), isNull);
    });

    test('returns value for ValueKey', () {
      expect(keyToStringValue(const ValueKey('test')), 'test');
    });

    test('returns value for GlobalObjectKey', () {
      const globalKey = GlobalObjectKey('globalKey');
      expect(keyToStringValue(globalKey), 'globalKey');
    });

    test('returns value for ObjectKey', () {
      expect(keyToStringValue(const ObjectKey('objectKey')), 'objectKey');
    });

    test('returns toString for unknown key type', () {
      const customKey = Key('customKey');
      expect(keyToStringValue(customKey), 'customKey');
    });
  });

  group('isButtonWidget', () {
    test('detects ButtonStyleButton', () {
      final button =
          ElevatedButton(onPressed: () {}, child: const Text('Button'));
      expect(isButtonWidget(button), true);
    });

    test('detects disabled MaterialButton', () {
      const button = MaterialButton(onPressed: null);
      expect(isButtonWidget(button), false);
    });

    test('detects IconButton with onPressed', () {
      final button = IconButton(onPressed: () {}, icon: const Icon(Icons.add));
      expect(isButtonWidget(button), true);
    });

    test('returns false for non-button widget', () {
      const widget = Text('Not a button');
      expect(isButtonWidget(widget), false);
    });
  });

  group('isTappedWidget', () {
    test('detects button widget', () {
      final button =
          ElevatedButton(onPressed: () {}, child: const Text('Button'));
      expect(isTappedWidget(button), true);
    });

    test('returns false for null widget', () {
      expect(isTappedWidget(null), false);
    });
  });

  group('isTextWidget', () {
    test('detects Text widget', () {
      const widget = Text('Hello');
      expect(isTextWidget(widget), true);
    });

    test('returns false for non-text widget', () {
      const widget = Icon(Icons.add);
      expect(isTextWidget(widget), false);
    });
  });

  group('getLabel', () {
    test('returns label from Text widget', () {
      const widget = Text('Label');
      expect(getLabel(widget), 'Label');
    });

    test('returns label from Tooltip', () {
      const widget = Tooltip(message: 'Tooltip message', child: Text('Child'));
      expect(getLabel(widget), 'Tooltip message');
    });

    test('returns null for unlabeled widget', () {
      const widget = Icon(Icons.add);
      expect(getLabel(widget), isNull);
    });
  });

  group('getSliderValue', () {
    test('returns value from Slider', () {
      final widget = Slider(value: 0.5, onChanged: (_) {});
      expect(getSliderValue(widget), '0.5');
    });

    test('returns value from RangeSlider', () {
      final widget =
          RangeSlider(values: const RangeValues(0.2, 0.8), onChanged: (_) {});
      expect(getSliderValue(widget), '(0.2,0.8)');
    });

    test('returns null for non-slider widget', () {
      const widget = Text('Not a slider');
      expect(getSliderValue(widget), isNull);
    });
  });
}
