import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/base_render_visibility_detector.dart';

class RenderSliverVisibilityDetector extends RenderProxySliver
    with RenderVisibilityDetectorBase {
  /// Constructor.  See the corresponding properties for parameter details.
  RenderSliverVisibilityDetector({
    RenderSliver? sliver,
    required this.key,
    required VisibilityChangedCallback? onVisibilityChanged,
  }) : super(sliver) {
    init(visibilityChangedCallback: onVisibilityChanged);
  }

  @override
  final Key key;

  @override
  Rect? get bounds {
    if (geometry == null) {
      return null;
    }

    Size widgetSize;
    Offset widgetOffset;
    switch (applyGrowthDirectionToAxisDirection(
      constraints.axisDirection,
      constraints.growthDirection,
    )) {
      case AxisDirection.down:
        widgetOffset = Offset(0, -constraints.scrollOffset);
        widgetSize = Size(constraints.crossAxisExtent, geometry!.scrollExtent);
        break;
      case AxisDirection.up:
        final startOffset = geometry!.paintExtent +
            constraints.scrollOffset -
            geometry!.scrollExtent;
        widgetOffset = Offset(0, math.min(startOffset, 0));
        widgetSize = Size(constraints.crossAxisExtent, geometry!.scrollExtent);
        break;
      case AxisDirection.right:
        widgetOffset = Offset(-constraints.scrollOffset, 0);
        widgetSize = Size(geometry!.scrollExtent, constraints.crossAxisExtent);
        break;
      case AxisDirection.left:
        final startOffset = geometry!.paintExtent +
            constraints.scrollOffset -
            geometry!.scrollExtent;
        widgetOffset = Offset(math.min(startOffset, 0), 0);
        widgetSize = Size(geometry!.scrollExtent, constraints.crossAxisExtent);
        break;
    }
    return widgetOffset & widgetSize;
  }
}

class SliverVisibilityDetector extends SingleChildRenderObjectWidget {
  /// Constructor.
  ///
  /// `key` is required to properly identify this widget; it must be unique
  /// among all [VisibilityDetector] and [SliverVisibilityDetector] widgets.
  ///
  /// `onVisibilityChanged` may be `null` to disable this
  /// [SliverVisibilityDetector].
  const SliverVisibilityDetector({
    required Key key,
    required Widget sliver,
    required this.onVisibilityChanged,
  }) : super(key: key, child: sliver);

  /// The callback to invoke when this widget's visibility changes.
  final VisibilityChangedCallback? onVisibilityChanged;

  /// See [RenderObjectWidget.createRenderObject].
  @override
  RenderSliverVisibilityDetector createRenderObject(BuildContext context) {
    return RenderSliverVisibilityDetector(
      key: key!,
      onVisibilityChanged: onVisibilityChanged,
    );
  }

  /// See [RenderObjectWidget.updateRenderObject].
  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverVisibilityDetector renderObject,
  ) {
    assert(renderObject.key == key);
    renderObject.onVisibilityChanged = onVisibilityChanged;
  }
}
