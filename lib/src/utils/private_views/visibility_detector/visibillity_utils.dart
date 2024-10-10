import 'dart:math';

import 'package:flutter/widgets.dart';

bool isWidgetVisible(
  Rect widgetBounds,
  Rect clipRect,
) {
  final overlaps = widgetBounds.overlaps(clipRect);
  // Compute the intersection in the widget's local coordinates.
  final visibleBounds = overlaps
      ? widgetBounds.intersect(clipRect).shift(-widgetBounds.topLeft)
      : Rect.zero;
  final visibleArea = _area(visibleBounds.size);
  final maxVisibleArea = _area(widgetBounds.size);

  if (_floatNear(maxVisibleArea, 0)) {
    return false;
  }

  final visibleFraction = visibleArea / maxVisibleArea;

  if (_floatNear(visibleFraction, 0)) {
    return false;
  } else if (_floatNear(visibleFraction, 1)) {
    return true;
  }

  return true;
}

/// Computes the area of a rectangle of the specified dimensions.
double _area(Size size) {
  assert(size.width >= 0);
  assert(size.height >= 0);
  return size.width * size.height;
}

/// Returns whether two floating-point values are approximately equal.
bool _floatNear(double f1, double f2) {
  final absDiff = (f1 - f2).abs();
  return absDiff <= _kDefaultTolerance ||
      (absDiff / max(f1.abs(), f2.abs()) <= _kDefaultTolerance);
}

const _kDefaultTolerance = 0.01;
