import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/user_steps/user_step_details.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

Element? _clickTrackerElement;

class InstabugUserSteps extends StatefulWidget {
  final Widget child;

  const InstabugUserSteps({Key? key, required this.child}) : super(key: key);

  @override
  InstabugUserStepsState createState() => InstabugUserStepsState();

  @override
  StatefulElement createElement() {
    final element = super.createElement();
    _clickTrackerElement = element;
    return element;
  }
}

class InstabugUserStepsState extends State<InstabugUserSteps> {
  static const double _doubleTapThreshold = 300.0; // milliseconds
  static const double _pinchSensitivity = 20.0;
  static const double _swipeSensitivity = 50.0;
  static const double _scrollSensitivity = 50.0;
  static const double _tapSensitivity = 20 * 20;

  Timer? _longPressTimer;
  Offset? _pointerDownLocation;
  GestureType? _gestureType;
  String? _gestureMetaData;
  DateTime? _lastTapTime;
  double _pinchDistance = 0.0;
  int _pointerCount = 0;
  double? _previousOffset;

  void _onPointerDown(PointerDownEvent event) {
    _resetGestureTracking();
    _pointerDownLocation = event.localPosition;
    _pointerCount += event.buttons;
    _longPressTimer = Timer(const Duration(milliseconds: 500), () {
      _gestureType = GestureType.longPress;
    });
  }

  void _onPointerUp(PointerUpEvent event, BuildContext context) {
    _longPressTimer?.cancel();

    final gestureType = _detectGestureType(event.localPosition);
    if (_gestureType != GestureType.longPress) {
      _gestureType = gestureType;
    }

    _pointerCount = 0;

    if (_gestureType == null) {
      return;
    }
    final tappedWidget =
        _getWidgetDetails(event.localPosition, context, _gestureType!);
    if (tappedWidget != null) {
      final userStepDetails = tappedWidget.copyWith(
        gestureType: _gestureType,
        gestureMetaData: _gestureMetaData,
      );
      if (userStepDetails.gestureType == null ||
          userStepDetails.message == null) {
        return;
      }

      Instabug.logUserSteps(
        userStepDetails.gestureType!,
        userStepDetails.message!,
        userStepDetails.widgetName,
      );
    }
  }

  GestureType? _detectGestureType(Offset upLocation) {
    final delta = upLocation - (_pointerDownLocation ?? Offset.zero);

    if (_pointerCount == 1) {
      if (_isTap(delta)) return _detectTapType();
      if (_isSwipe(delta)) return GestureType.swipe;
    } else if (_pointerCount == 2 && _isPinch()) {
      return GestureType.pinch;
    }

    return null;
  }

  bool _isTap(Offset delta) => delta.distanceSquared < _tapSensitivity;

  GestureType? _detectTapType() {
    final now = DateTime.now();
    final isDoubleTap = _lastTapTime != null &&
        now.difference(_lastTapTime!).inMilliseconds <= _doubleTapThreshold;

    _lastTapTime = now;
    return isDoubleTap ? GestureType.doubleTap : GestureType.tap;
  }

  bool _isSwipe(Offset delta) {
    final isHorizontal = delta.dx.abs() > delta.dy.abs();

    if (isHorizontal && delta.dx.abs() > _swipeSensitivity) {
      _gestureMetaData = delta.dx > 0 ? "Right" : "Left";
      return true;
    }

    if (!isHorizontal && delta.dy.abs() > _swipeSensitivity) {
      _gestureMetaData = delta.dy > 0 ? "Down" : "Up";
      return true;
    }

    return false;
  }

  bool _isPinch() => _pinchDistance.abs() > _pinchSensitivity;

  void _resetGestureTracking() {
    _gestureType = null;
    _gestureMetaData = null;
    _longPressTimer?.cancel();
  }

  UserStepDetails? _getWidgetDetails(
    Offset location,
    BuildContext context,
    GestureType gestureType,
  ) {
    Element? tappedElement;
    var isPrivate = false;

    final rootElement = _clickTrackerElement;
    if (rootElement == null || rootElement.widget != widget) return null;

    final hitTestResult = BoxHitTestResult();
    final renderBox = context.findRenderObject()! as RenderBox;

    renderBox.hitTest(hitTestResult, position: _pointerDownLocation!);

    final targets = hitTestResult.path
        .where((e) => e.target is RenderBox)
        .map((e) => e.target)
        .toList();

    void visitor(Element visitedElement) {
      final renderObject = visitedElement.renderObject;
      if (renderObject == null) return;

      if (targets.contains(renderObject)) {
        final transform = renderObject.getTransformTo(rootElement.renderObject);
        final paintBounds =
            MatrixUtils.transformRect(transform, renderObject.paintBounds);

        if (paintBounds.contains(_pointerDownLocation!)) {
          final widget = visitedElement.widget;
          if (!isPrivate) {
            isPrivate = widget.runtimeType.toString() ==
                    'InstabugPrivateView' ||
                widget.runtimeType.toString() == 'InstabugSliverPrivateView';
          }
          if (_isTargetWidget(widget, gestureType)) {
            tappedElement = visitedElement;
            return;
          }
        }
      }
      if (tappedElement == null) {
        visitedElement.visitChildElements(visitor);
      }
    }

    rootElement.visitChildElements(visitor);
    if (tappedElement == null) return null;
    return UserStepDetails(element: tappedElement, isPrivate: isPrivate);
  }

  bool _isTargetWidget(Widget? widget, GestureType type) {
    if (widget == null) return false;
    switch (type) {
      case GestureType.swipe:
        return isSwipedWidget(widget);
      case GestureType.tap:
      case GestureType.longPress:
      case GestureType.doubleTap:
        return isTappedWidget(widget);
      case GestureType.pinch:
        return isPinchWidget(widget);
      case GestureType.scroll:
        return false;
    }
  }

  void _detectScrollDirection(double currentOffset, Axis direction) {
    if (_previousOffset == null) return;

    final delta = (currentOffset - _previousOffset!).abs();
    if (delta < _scrollSensitivity) return;
    final String swipeDirection;
    if (direction == Axis.horizontal) {
      swipeDirection = currentOffset > _previousOffset! ? "Left" : "Right";
    } else {
      swipeDirection = currentOffset > _previousOffset! ? "Down" : "Up";
    }

    final userStepDetails = UserStepDetails(
      element: null,
      isPrivate: false,
      gestureMetaData: swipeDirection,
      gestureType: GestureType.scroll,
    );

    if (userStepDetails.gestureType == null ||
        userStepDetails.message == null) {
      return;
    }
    Instabug.logUserSteps(
      userStepDetails.gestureType!,
      userStepDetails.message!,
      "ListView",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerMove: (event) {
        if (_pointerCount == 2) {
          _pinchDistance =
              (event.localPosition - (_pointerDownLocation ?? Offset.zero))
                  .distance;
        }
      },
      onPointerUp: (event) => _onPointerUp(event, context),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification is ScrollStartNotification) {
            _previousOffset = notification.metrics.pixels;
          } else if (notification is ScrollEndNotification) {
            _detectScrollDirection(
              notification.metrics.pixels, // Vertical position
              notification.metrics.axis,
            );
          }

          return true;
        },
        child: widget.child,
      ),
    );
  }
}
