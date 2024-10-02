import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/base_render_visibility_detector.dart';

void main() {
  RenderVisibilityDetectorBase.updateInterval = Duration.zero;

  testWidgets('RenderVisibilityDetector unregisters its callback on paint',
      (WidgetTester tester) async {
    final detector = RenderVisibilityDetector(
      key: const Key('test'),
      onVisibilityChanged: (_) {},
    );

    final layer = ContainerLayer();
    final context = PaintingContext(layer, Rect.largest);
    expect(layer.subtreeHasCompositionCallbacks, false);

    renderBoxWidget(detector, context);

    context.stopRecordingIfNeeded(); // ignore: invalid_use_of_protected_member

    expect(layer.subtreeHasCompositionCallbacks, true);

    expect(detector.debugScheduleUpdateCount, 0);
    layer.buildScene(SceneBuilder()).dispose();

    expect(detector.debugScheduleUpdateCount, 1);
  });

  testWidgets('RenderVisibilityDetector unregisters its callback on dispose',
      (WidgetTester tester) async {
    final detector = RenderVisibilityDetector(
      key: const Key('test'),
      onVisibilityChanged: (_) {},
    );

    final layer = ContainerLayer();
    final context = PaintingContext(layer, Rect.largest);
    expect(layer.subtreeHasCompositionCallbacks, false);

    renderBoxWidget(detector, context);
    expect(layer.subtreeHasCompositionCallbacks, true);

    detector.dispose();
    expect(layer.subtreeHasCompositionCallbacks, false);

    expect(detector.debugScheduleUpdateCount, 0);
    context.stopRecordingIfNeeded(); // ignore: invalid_use_of_protected_member
    layer.buildScene(SceneBuilder()).dispose();

    expect(detector.debugScheduleUpdateCount, 0);
  });

  testWidgets(
      'RenderVisibilityDetector unregisters its callback when callback changes',
      (WidgetTester tester) async {
    final detector = RenderVisibilityDetector(
      key: const Key('test'),
      onVisibilityChanged: (_) {},
    );

    final layer = ContainerLayer();
    final context = PaintingContext(layer, Rect.largest);
    expect(layer.subtreeHasCompositionCallbacks, false);

    renderBoxWidget(detector, context);
    expect(layer.subtreeHasCompositionCallbacks, true);

    detector.onVisibilityChanged = null;

    expect(layer.subtreeHasCompositionCallbacks, false);

    expect(detector.debugScheduleUpdateCount, 0);
    context.stopRecordingIfNeeded(); // ignore: invalid_use_of_protected_member
    layer.buildScene(SceneBuilder()).dispose();

    expect(detector.debugScheduleUpdateCount, 0);
  });

  testWidgets(
      'RenderVisibilityDetector can schedule an update for a RO that is not laid out',
      (WidgetTester tester) async {
    final detector = RenderVisibilityDetector(
      key: const Key('test'),
      onVisibilityChanged: (_) {
        fail('should not get called');
      },
    );

    // Force an out of band update to get scheduled without laying out.
    detector.onVisibilityChanged = (_) {
      fail('This should also not get called');
    };

    expect(detector.debugScheduleUpdateCount, 1);

    detector.dispose();
  });
}

void renderBoxWidget(
  RenderVisibilityDetector detector,
  PaintingContext context,
) {
  detector.layout(BoxConstraints.tight(const Size(200, 200)));
  detector.paint(context, Offset.zero);
}
