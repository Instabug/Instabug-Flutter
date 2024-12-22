import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

Element? _clickTrackerElement;

class WidgetDetails {
  Element element;
  bool isPrivate;
  late Widget widget;
  WidgetDetails({
    required this.element,
    required this.isPrivate,
  }){
    widget = element.widget;
  }

  String? get key {
    return WidgetUtils.toStringValue(widget.key);
  }

  String get widgetName {
    if (widget is InkWell) {
      final inkWellWidget = widget as InkWell;
      return "${inkWellWidget.child.runtimeType} Wrapped with InkWell";
    } else if (widget is GestureDetector) {
      final gestureDetectorWidget = widget as GestureDetector;
      return "${gestureDetectorWidget.child.runtimeType} Wrapped with GestureDetector";
    } else {
      return widget.runtimeType.toString();
    }
  }

  String? get text {
    if (isPrivate) {
      return null;
    }

    if (WidgetUtils.isSliderWidget(widget)) {
      return "A slider changed to ${WidgetDetails.getSliderValue(widget)}";
    }

    if (WidgetUtils.isButtonWidget(widget)) {
      return WidgetUtils.getLabelRecursively(widget);
    } else if (WidgetUtils.isTextWidget(widget)) {
      return WidgetUtils.getLabelRecursively(visitedElement);
    } else if (WidgetUtils.isToggleableWidget(widget)) {
      return WidgetUtils.getToggleValue(widget);
    } else if (WidgetUtils.isTextInputWidget(widget)) {
      return WidgetUtils.getTextInputValue(widget);
    }
    return null;
  }
}

enum GestureType { swipe, scroll, tap, pinch, longPress, doubleTap }

class InstabugUserSteps extends StatefulWidget {
  final Widget child;

  const InstabugUserSteps({Key? key, required this.child}) : super(key: key);

  @override
  _InstabugUserStepsState createState() => _InstabugUserStepsState();

  @override
  StatefulElement createElement() {
    final element = super.createElement();
    _clickTrackerElement = element;
    return element;
  }
}

class _InstabugUserStepsState extends State<InstabugUserSteps> {
  Timer? _timer;
  Offset? _pointerDownLocation;
  DateTime? _lastTapTime;
  bool? _isLongPressed;
  String? _swipeDirection;
  GestureType? gestureType;
  DateTime? currentTime;
  static const double _doubleTapThreshold = 300;
  int? _pointerCount;
  double _endDistance = 0.0;

  void _onPointerDown(PointerDownEvent downEvent) {
    _isLongPressed = false;
    gestureType = null;
    _pointerDownLocation = downEvent.localPosition;
    _lastTapTime = currentTime;
    _pointerCount = downEvent.buttons; // Store pointer count (to check pinch)
    _timer = Timer(const Duration(milliseconds: 500), () {
      _isLongPressed = true;
    });
  }

  void _onPointerUp(PointerUpEvent upEvent, BuildContext context) {
    _timer?.cancel();
    currentTime = DateTime.now();
    if (_pointerDownLocation == null) {
      return;
    }
    if (_pointerCount == 1) {
      final deltaX = upEvent.localPosition.dx - _pointerDownLocation!.dx;
      final deltaY = upEvent.localPosition.dy - _pointerDownLocation!.dy;
      const tapSensitivity = 20 * 20;
      final offset = Offset(deltaX, deltaY);
      if (offset.distanceSquared < tapSensitivity) {
        if (_isLongPressed!) {
          gestureType = GestureType.longPress;
        } else if (_lastTapTime != null &&
            currentTime!.difference(_lastTapTime!).inMilliseconds <=
                _doubleTapThreshold) {
          gestureType = GestureType.doubleTap;
        } else {
          gestureType = GestureType.tap;
        }
      } else {
        if (deltaX.abs() > deltaY.abs()) {
          gestureType = GestureType.swipe;

          if (deltaX > 0) {
            print('Swipe Right');
          } else {
            print('Swipe Left');
          }
        }
      }
    } else if (_pointerCount == 2) {
      // Pinch detection
      final double pinchDelta = _endDistance - 0.0;
      if (pinchDelta.abs() > 20) {
        gestureType = GestureType.pinch;
      }
    }

    if (gestureType == null) {
      return;
    }

    final tappedWidget =
        _getWidgetDetails(upEvent.localPosition, context, gestureType!);
    if (tappedWidget == null) {
      return;
    }

    // if (tappedWidget["widget"] == null) {
    //   return;
    // }
    //
    // print("Ahmed " +
    //     "${gestureType!.name} ${tappedWidget["widget"]} ${tappedWidget["description"]}");
  }

  double? _previousOffset;

  void _detectScrollDirection(double currentOffset, Axis direction) {
    if (_previousOffset == null) {
      return;
    }
    final delta = (currentOffset - _previousOffset!).abs();
    if (delta < 50) {
      return;
    }
    switch (direction) {
      case Axis.horizontal:
        if (currentOffset > _previousOffset!) {
          _swipeDirection = "Scrolling Left";
        } else {
          _swipeDirection = "Scrolling Right";
        }
        break;
      case Axis.vertical:
        if (currentOffset > _previousOffset!) {
          _swipeDirection = "Scrolling Down";
        } else {
          _swipeDirection = "Scrolling Up";
        }
        break;
    }

    print("Ahmed ${_swipeDirection!}");
  }

  double _calculateDistance(Offset point1, Offset point2) {
    // Calculate distance between two points for pinch detection
    return sqrt(pow(point2.dx - point1.dx, 2) + pow(point2.dy - point1.dy, 2));
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: (event) {
        // Track the movement while the pointer is moving
        if (_pointerCount == 2) {
          // Track distance between two fingers for pinch detection
          _endDistance =
              _calculateDistance(event.localPosition, _pointerDownLocation!);
        }
      },
      onPointerUp: (event) {
        _onPointerUp(event, context);
      },
      child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification is ScrollStartNotification) {
              _previousOffset = notification.metrics.pixels;
            } else if (notification is ScrollEndNotification) {
              _detectScrollDirection(
                  notification.metrics.pixels, // Vertical position
                  notification.metrics.axis);
            }

            return true;
          },
          child: widget.child),
    );
  }

  WidgetDetails? _getWidgetDetails(
      Offset location, BuildContext context, GestureType type) {
    Widget? tappedWidget;
    // String? text;
    var isPrivate = false;

    final rootElement = _clickTrackerElement;
    if (rootElement == null || rootElement.widget != widget) {
      return null;
    }

    final hitTestResult = BoxHitTestResult();
    final renderBox = context.findRenderObject()! as RenderBox;

    renderBox.hitTest(hitTestResult, position: location);

    final targets = hitTestResult.path
        .where((e) => e.target is RenderBox)
        .map((e) => e.target)
        .toList();

    void visitor(Element visitedElement) {
      final renderObject = visitedElement.renderObject;

      if (renderObject == null) {
        return;
      }

      if (targets.contains(renderObject)) {
        final transform =
            renderObject.getTransformTo(_clickTrackerElement!.renderObject);

        final paintBounds =
            MatrixUtils.transformRect(transform, renderObject.paintBounds);

        if (paintBounds.contains(location)) {
          final widget = visitedElement.widget;
          if (isPrivate == false) {
            isPrivate = widget.runtimeType.toString() ==
                    'InstabugPrivateView' ||
                widget.runtimeType.toString() == 'InstabugSliverPrivateView';
          }
          if (_isTargetWidget(widget, type)) {
            tappedWidget = visitedElement.widget;
            return;
          }

          // if (_isSliderWidget(visitedElement.widget)) {
          //   tappedWidget = visitedElement.widget.runtimeType.toString();
          //   text =
          //       "A slider changed to ${_getSliderValue(visitedElement.widget)}";
          //   return;
          // }
          //
          // if (_isButtonWidget(visitedElement.widget)) {
          //   if (visitedElement.widget is InkWell) {
          //     final widget = visitedElement.widget as InkWell;
          //     tappedWidget = "${widget.child.runtimeType} Wrapped with InkWell";
          //   } else if (visitedElement.widget is GestureDetector) {
          //     final widget = visitedElement.widget as GestureDetector;
          //     tappedWidget =
          //         "${widget.child.runtimeType} Wrapped with GestureDetector";
          //   } else {
          //     tappedWidget = visitedElement.widget.runtimeType.toString();
          //   }
          //
          //   if (isPrivate == false) {
          //     text = _getLabelRecursively(visitedElement);
          //   }
          //   return;
          // } else if (_isTextWidget(visitedElement.widget)) {
          //   tappedWidget = visitedElement.widget.runtimeType.toString();
          //   if (isPrivate == false) {
          //     text = _getLabelRecursively(visitedElement);
          //   }
          //   return;
          // } else if (_isToggleableWidget(visitedElement.widget)) {
          //   tappedWidget = visitedElement.widget.runtimeType.toString();
          //   text = _getToggleValue(visitedElement.widget);
          //   return;
          // } else if (_isTextInputWidget(visitedElement.widget)) {
          //   tappedWidget = visitedElement.widget.runtimeType.toString();
          //   if (isPrivate == false) {
          //     text = _getTextInputValue(visitedElement.widget);
          //   }
          //
          //   return;
          // }
          // key = WidgetUtils.toStringValue(visitedElement.widget.key);
        }
      }
      if (tappedWidget == null ||
          (_isElementMounted(visitedElement) == false)) {
        visitedElement.visitChildElements(visitor);
      }
    }

    _clickTrackerElement?.visitChildElements(visitor);
    if (tappedWidget == null) return null;
    return WidgetDetails(widget: tappedWidget!, isPrivate: isPrivate);
  }

  bool _isTargetWidget(Widget? widget, GestureType gestureType) {
    if (widget == null) {
      return false;
    }
    switch (gestureType) {
      case GestureType.swipe:
        return WidgetUtils.isSwipedWidget(widget);
      case GestureType.scroll:
        return false;
      case GestureType.tap:
      case GestureType.longPress:
      case GestureType.doubleTap:
        return WidgetUtils.isTappedWidget(widget);
      case GestureType.pinch:
        return WidgetUtils.isPinchWidget(widget);
    }
  }

  bool _isElementMounted(Element? element) {
    if (element == null) {
      return false;
    }
    return element.mounted && element.owner != null;
  }
}
