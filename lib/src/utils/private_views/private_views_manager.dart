import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instabug_flutter/src/generated/instabug_private_view.api.g.dart';

/// responsible for masking views
/// before they are sent to the native SDKs.
class PrivateViewsManager implements InstabugPrivateViewApi {
  PrivateViewsManager._();

  static PrivateViewsManager _instance = PrivateViewsManager._();

  static PrivateViewsManager get instance => _instance;

  /// Shorthand for [instance]
  static PrivateViewsManager get I => instance;

  final Set<GlobalKey> _keys = {};

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(PrivateViewsManager instance) {
    _instance = instance;
  }

  Rect? getLayoutRectInfoFromKey(GlobalKey key) {
    final renderObject = key.currentContext?.findRenderObject();

    if (renderObject == null) {
      return null;
    }

    final globalOffset = _getRenderGlobalOffset(renderObject);

    if (renderObject is RenderProxyBox) {
      if (renderObject.child == null) {
        return null;
      }

      return MatrixUtils.transformRect(
        renderObject.child!.getTransformTo(renderObject),
        Offset.zero & renderObject.child!.size,
      ).shift(globalOffset);
    }

    return renderObject.paintBounds.shift(globalOffset);
  }

  // The is the same implementation used in RenderBox.localToGlobal (a subclass of RenderObject)
  Offset _getRenderGlobalOffset(RenderObject renderObject) {
    return MatrixUtils.transformPoint(
      renderObject.getTransformTo(null),
      Offset.zero,
    );
  }

  void mask(GlobalKey key) {
    _keys.add(key);
  }

  void unMask(GlobalKey key) {
    _keys.remove(key);
  }

  @override
  List<double?> getPrivateViews() {
    final stopwatch = Stopwatch()..start();

    final result = <double>[];

    for (final view in _keys) {
      final rect = getLayoutRectInfoFromKey(view);

      if (rect == null) continue;

      result.addAll([
        rect.left,
        rect.top,
        rect.right,
        rect.bottom,
      ]);
    }

    debugPrint(
      "IBG-PV-Perf: Flutter getPrivateViews took: ${stopwatch.elapsedMilliseconds}ms",
    );

    return result;
  }
}
