import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/generated/instabug_private_view.api.g.dart';
import 'package:instabug_flutter/src/utils/enum_converter.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

enum AutoMasking { labels, textInputs, media, none }

extension ValidationMethod on AutoMasking {
  bool Function(Widget) hides() {
    switch (this) {
      case AutoMasking.labels:
        return isTextWidget;
      case AutoMasking.textInputs:
        return isTextInputWidget;
      case AutoMasking.media:
        return isMedia;
      case AutoMasking.none:
        return (_) => false;
    }
  }
}

/// responsible for masking views
/// before they are sent to the native SDKs.
class PrivateViewsManager implements InstabugPrivateViewFlutterApi {
  PrivateViewsManager._() {
    _viewChecks = List.of([isPrivateWidget]);
  }

  static PrivateViewsManager _instance = PrivateViewsManager._();

  static PrivateViewsManager get instance => _instance;
  static final _host = InstabugHostApi();

  /// Shorthand for [instance]
  static PrivateViewsManager get I => instance;

  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void setInstance(PrivateViewsManager instance) {
    _instance = instance;
  }

  static bool isPrivateWidget(Widget widget) {
    final isPrivate = (widget.runtimeType == InstabugPrivateView) ||
        (widget.runtimeType == InstabugSliverPrivateView);

    return isPrivate;
  }

  late List<bool Function(Widget)> _viewChecks;

  void addAutoMasking(List<AutoMasking> masking) {
    _viewChecks = List.of([isPrivateWidget]);
    if (!(masking.contains(AutoMasking.none) && masking.length == 1)) {
      _viewChecks.addAll(masking.map((e) => e.hides()).toList());
    }
    _host.enableAutoMasking(masking.mapToString());
  }

  Rect? getLayoutRectInfoFromRenderObject(RenderObject? renderObject) {
    if (renderObject == null || !renderObject.attached) {
      return null;
    }

    final globalOffset = _getRenderGlobalOffset(renderObject);

    // Case 1: RenderBox (e.g. Container, Text, etc.)
    if (renderObject is RenderBox) {
      return renderObject.paintBounds.shift(globalOffset);
    }

    // Case 2: RenderSliver (e.g. SliverList, SliverToBoxAdapter, etc.)
    if (renderObject is RenderSliver) {
      final geometry = renderObject.geometry;
      if (geometry == null) {
        return null;
      }

      final crossAxisExtent = renderObject.constraints.crossAxisExtent;
      final paintExtent = geometry.paintExtent;

      return Rect.fromLTWH(
        globalOffset.dx,
        globalOffset.dy,
        // assume vertical scroll by default
        crossAxisExtent,
        paintExtent,
      );
    }

    return null;
  }

  // The is the same implementation used in RenderBox.localToGlobal (a subclass of RenderObject)
  Offset _getRenderGlobalOffset(RenderObject renderObject) {
    // Find the nearest RenderBox ancestor to calculate global position
    RenderObject? current = renderObject;
    while (current != null && current is! RenderBox) {
      final parentNode = current.parent;
      if (parentNode is RenderObject) {
        current = parentNode;
      } else {
        current = null;
      }
    }

    if (current is RenderBox) {
      // Get transform from this object to screen root
      final transform = renderObject.getTransformTo(null);
      return MatrixUtils.transformPoint(transform, Offset.zero);
    }

    // fallback: treat as zero offset (shouldn't happen if widget is mounted in tree)
    return Offset.zero;
  }

  List<Rect> getRectsOfPrivateViews() {
    final context = instabugWidgetKey.currentContext;
    if (context == null) return [];

    final rootRenderObject =
        context.findRenderObject() as RenderRepaintBoundary?;
    if (rootRenderObject is! RenderBox) return [];

    final bounds = Offset.zero & rootRenderObject!.size;

    final rects = <Rect>[];

    void findPrivateViews(Element element) {
      final widget = element.widget;
      final isPrivate = _viewChecks.any((e) => e.call(widget));
      if (isPrivate) {
        final renderObject = element.findRenderObject();
        if ((renderObject is RenderBox || renderObject is RenderSliver) &&
            renderObject?.attached == true) {
          final isElementInCurrentScreen = isElementInCurrentRoute(element);
          final rect = getLayoutRectInfoFromRenderObject(renderObject);
          if (rect != null &&
              rect.overlaps(bounds) &&
              isElementInCurrentScreen) {
            rects.add(rect);
          }
        }
      } else {
        element.visitChildElements(findPrivateViews);
      }
    }

    rects.clear();
    context.visitChildElements(findPrivateViews);

    return rects;
  }

  bool isElementInCurrentRoute(Element element) {
    final modalRoute = ModalRoute.of(element);
    return modalRoute?.isCurrent ?? false;
  }

  @override
  List<double?> getPrivateViews() {
    final rects = getRectsOfPrivateViews();
    final result = <double>[];

    for (final rect in rects) {
      result.addAll([
        rect.left,
        rect.top,
        rect.right,
        rect.bottom,
      ]);
    }

    return result;
  }
}
