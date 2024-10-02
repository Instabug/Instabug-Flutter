import 'dart:ui';

import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/base_render_visibility_detector.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/sliver_visibility_detector.dart';

void main() {
  RenderVisibilityDetectorBase.updateInterval = Duration.zero;

  void renderSliverWidget(RenderSliverVisibilityDetector detector,
      ContainerLayer layer, PaintingContext context,) {
    expect(layer.subtreeHasCompositionCallbacks, false);

    detector.layout(
      const SliverConstraints(
        axisDirection: AxisDirection.down,
        growthDirection: GrowthDirection.forward,
        userScrollDirection: ScrollDirection.forward,
        scrollOffset: 0,
        precedingScrollExtent: 0,
        overlap: 0,
        remainingPaintExtent: 0,
        crossAxisExtent: 0,
        crossAxisDirection: AxisDirection.left,
        viewportMainAxisExtent: 0,
        remainingCacheExtent: 0,
        cacheOrigin: 0,
      ),
    );

    final owner = PipelineOwner();
    detector.attach(owner);
    owner.flushCompositingBits();

    detector.paint(context, Offset.zero);
  }

  testWidgets(
      'RenderSliverVisibilityDetector unregisters its callback on paint',
      (WidgetTester tester) async {
    final detector = RenderSliverVisibilityDetector(
      key: const Key('test'),
      onVisibilityChanged: (_) {},
      sliver: RenderSliverToBoxAdapter(child: RenderLimitedBox()),
    );
    final layer = ContainerLayer();
    final context = PaintingContext(layer, Rect.largest);

    renderSliverWidget(detector, layer, context);
    expect(layer.subtreeHasCompositionCallbacks, true);
    expect(detector.debugScheduleUpdateCount, 0);
    context.stopRecordingIfNeeded(); // ignore: invalid_use_of_protected_member
    layer.buildScene(SceneBuilder()).dispose();

    expect(detector.debugScheduleUpdateCount, 1);
  });

  testWidgets(
      'RenderSliverVisibilityDetector unregisters its callback on dispose',
      (WidgetTester tester) async {
    final detector = RenderSliverVisibilityDetector(
      key: const Key('test'),
      sliver: RenderSliverToBoxAdapter(child: RenderLimitedBox()),
      onVisibilityChanged: (_) {},
    );

    final layer = ContainerLayer();
    final context = PaintingContext(layer, Rect.largest);
    renderSliverWidget(detector, layer, context);

    expect(layer.subtreeHasCompositionCallbacks, true);

    detector.dispose();
    expect(layer.subtreeHasCompositionCallbacks, false);

    expect(detector.debugScheduleUpdateCount, 0);
    context.stopRecordingIfNeeded(); // ignore: invalid_use_of_protected_member
    layer.buildScene(SceneBuilder()).dispose();

    expect(detector.debugScheduleUpdateCount, 0);
  });

  testWidgets(
      'RenderSliverVisibilityDetector unregisters its callback when callback changes',
      (WidgetTester tester) async {
    final detector = RenderSliverVisibilityDetector(
      key: const Key('test'),
      sliver: RenderSliverToBoxAdapter(child: RenderLimitedBox()),
      onVisibilityChanged: (_) {},
    );

    final layer = ContainerLayer();
    final context = PaintingContext(layer, Rect.largest);
    renderSliverWidget(detector, layer, context);

    expect(layer.subtreeHasCompositionCallbacks, true);

    detector.onVisibilityChanged = null;

    expect(layer.subtreeHasCompositionCallbacks, false);

    expect(detector.debugScheduleUpdateCount, 0);
    context.stopRecordingIfNeeded(); // ignore: invalid_use_of_protected_member
    layer.buildScene(SceneBuilder()).dispose();

    expect(detector.debugScheduleUpdateCount, 0);
  });

  testWidgets(
      'RenderSliverVisibilityDetector  can schedule an update for a RO that is not laid out',
      (WidgetTester tester) async {
    final detector = RenderSliverVisibilityDetector(
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
