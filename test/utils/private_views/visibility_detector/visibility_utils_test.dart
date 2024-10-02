import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/visibillity_utils.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  test(
      '[isWidgetVisible] should return false when the widget bounds are outside the screen visible area',
      () {
    const widgetBounds = Rect.fromLTWH(15, 25, 10, 20);
    const clipRect = Rect.fromLTWH(100, 200, 300, 400);
    final isVisible = isWidgetVisible(widgetBounds, clipRect);
    expect(isVisible, false);
  });

  test(
      '[isWidgetVisible] should return true when part of widget bounds are inside the screen visible area',
      () {
    const widgetBounds = Rect.fromLTWH(115, 225, 10, 20);
    const clipRect = Rect.fromLTWH(100, 200, 300, 400);
    final isVisible = isWidgetVisible(widgetBounds, clipRect);
    expect(isVisible, true);
  });

  test(
      '[isWidgetVisible] should return true when widget bounds are inside the screen visible area',
      () {
    const widgetBounds = Rect.fromLTWH(100, 200, 300, 399);
    const clipRect = Rect.fromLTWH(100, 200, 300, 400);
    final isVisible = isWidgetVisible(widgetBounds, clipRect);

    expect(isVisible, true);
  });
}
