import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/base_render_visibility_detector.dart';

class RenderVisibilityDetector extends RenderProxyBox
    with RenderVisibilityDetectorBase {
  RenderVisibilityDetector({
    RenderBox? child,
    required this.key,
    required VisibilityChangedCallback? onVisibilityChanged,
  }) : super(child) {
    init(visibilityChangedCallback: onVisibilityChanged);
  }

  @override
  final Key key;

  @override
  Rect? get bounds => hasSize ? semanticBounds : null;
}

class VisibilityDetector extends SingleChildRenderObjectWidget {
  const VisibilityDetector({
    required Key key,
    required Widget child,
    required this.onVisibilityChanged,
  }) : super(key: key, child: child);

  /// The callback to invoke when this widget's visibility changes.
  final VisibilityChangedCallback? onVisibilityChanged;

  @override
  RenderVisibilityDetector createRenderObject(BuildContext context) {
    return RenderVisibilityDetector(
      key: key!,
      onVisibilityChanged: onVisibilityChanged,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderVisibilityDetector renderObject,
  ) {
    assert(renderObject.key == key);
    renderObject.onVisibilityChanged = onVisibilityChanged;
  }
}
