import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

Element? _clickTrackerElement;

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
        if (pinchDelta > 0) {
          print('Pinch Out (Zoom In)');
        } else {
          print('Pinch In (Zoom Out)');
        }
      }
    }
    final tappedWidget = _getTappedWidget(upEvent.localPosition, context);
    if (tappedWidget == null) {
      return;
    }

    if (tappedWidget["widget"] == null) {
      return;
    }

    print("Ahmed " +
        "${gestureType!.name} ${tappedWidget["widget"]} ${tappedWidget["description"]}");
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

  String? _getElementType(Element element) {
    final widget = element.widget;
    // Used by ElevatedButton, TextButton, OutlinedButton.
    if (widget is ButtonStyleButton) {
      if (widget.enabled) {
        return 'ButtonStyleButton';
      }
    } else if (widget is MaterialButton) {
      if (widget.enabled) {
        return 'MaterialButton';
      }
    } else if (widget is CupertinoButton) {
      if (widget.enabled) {
        return 'CupertinoButton';
      }
    } else if (widget is InkWell) {
      if (widget.onTap != null) {
        return 'InkWell';
      }
    } else if (widget is GestureDetector) {
      if (widget.onTap != null) {
        return 'GestureDetector';
      }
    } else if (widget is IconButton) {
      if (widget.onPressed != null) {
        return 'IconButton';
      }
    } else if (widget is PopupMenuButton) {
      if (widget.enabled) {
        return 'PopupMenuButton';
      }
    } else if (widget is PopupMenuItem) {
      if (widget.enabled) {
        return 'PopupMenuItem';
      }
    }

    return null;
  }

  Map<String, dynamic>? _getTappedWidget(
      Offset location, BuildContext context) {
    String? tappedWidget;
    String? text;
    String? key;

    final rootElement = _clickTrackerElement;
    if (rootElement == null || rootElement.widget != widget) {
      return null;
    }

    var isPrivate = false;
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
          if (isPrivate == false) {
            isPrivate = visitedElement.widget.runtimeType.toString() ==
                    'InstabugPrivateView' ||
                visitedElement.widget.runtimeType.toString() ==
                    'InstabugSliverPrivateView';
          }
          if (_isSliderWidget(visitedElement.widget)) {
            tappedWidget = visitedElement.widget.runtimeType.toString();
            text =
                "A slider changed to ${_getSliderValue(visitedElement.widget)}";
            return;
          }
          if (_isButtonWidget(visitedElement.widget)) {
            if (visitedElement.widget is InkWell) {
              final widget = visitedElement.widget as InkWell;
              tappedWidget = "${widget.child.runtimeType} Wrapped with InkWell";
            } else if (visitedElement.widget is GestureDetector) {
              final widget = visitedElement.widget as GestureDetector;
              tappedWidget =
                  "${widget.child.runtimeType} Wrapped with GestureDetector";
            } else {
              tappedWidget = visitedElement.widget.runtimeType.toString();
            }

            if (isPrivate == false) {
              text = _getLabelRecursively(visitedElement);
            }
            return;
          } else if (_isTextWidget(visitedElement.widget)) {
            tappedWidget = visitedElement.widget.runtimeType.toString();
            if (isPrivate == false) {
              text = _getLabelRecursively(visitedElement);
            }
            return;
          } else if (_isToggleableWidget(visitedElement.widget)) {
            tappedWidget = visitedElement.widget.runtimeType.toString();
            text = _getTaggleValue(visitedElement.widget);
            return;
          } else if (_isTextInputWidget(visitedElement.widget)) {
            tappedWidget = visitedElement.widget.runtimeType.toString();
            if (isPrivate == false) {
              text = _getTextInputValue(visitedElement.widget);
            }

            return;
          }
          key = WidgetUtils.toStringValue(visitedElement.widget.key);
        }
      }
      if (tappedWidget == null ||
          (_isElementMounted(visitedElement) == false)) {
        visitedElement.visitChildElements(visitor);
      }
    }

    _clickTrackerElement?.visitChildElements(visitor);

    return {'widget': tappedWidget, 'description': text, "key": key};
  }

  bool _isTargetWidget(Widget? parentWidget) {
    if (parentWidget == null) {
      return false;
    }
    return _isButtonWidget(parentWidget) || _isToggleableWidget(parentWidget);
  }

  bool _isButtonWidget(Widget clickedWidget) {
    if (clickedWidget is ButtonStyleButton ||
        clickedWidget is MaterialButton ||
        clickedWidget is CupertinoButton ||
        clickedWidget is PopupMenuButton ||
        clickedWidget is FloatingActionButton ||
        clickedWidget is BackButton ||
        clickedWidget is DropdownButton ||
        clickedWidget is IconButton ||
        clickedWidget is GestureDetector ||
        clickedWidget is InkWell) {
      return true;
    }
    return false;
  }

  bool _isTextWidget(Widget clickedWidget) {
    if (clickedWidget is Text ||
        clickedWidget is RichText ||
        clickedWidget is SelectableText ||
        clickedWidget is TextSpan ||
        clickedWidget is Placeholder ||
        clickedWidget is TextStyle) {
      return true;
    }
    return false;
  }

  bool _isSliderWidget(Widget clickedWidget) {
    if (clickedWidget is Slider ||
        clickedWidget is CupertinoSlider ||
        clickedWidget is Dismissible ||
        clickedWidget is RangeSlider) {
      return true;
    }
    return false;
  }

  bool _isImageWidget(Widget clickedWidget) {
    if (clickedWidget is Image ||
        clickedWidget is FadeInImage ||
        clickedWidget is NetworkImage ||
        clickedWidget is AssetImage ||
        clickedWidget is ImageProvider ||
        clickedWidget is FileImage ||
        clickedWidget is MemoryImage) {
      return true;
    }
    return false;
  }

  bool _isToggleableWidget(Widget clickedWidget) {
    if (clickedWidget is Checkbox ||
        clickedWidget is CheckboxListTile ||
        clickedWidget is Radio ||
        clickedWidget is RadioListTile ||
        clickedWidget is Switch ||
        clickedWidget is SwitchListTile ||
        clickedWidget is CupertinoSwitch ||
        clickedWidget is ToggleButtons) {
      return true;
    }
    return false;
  }

  bool _isTextInputWidget(Widget clickedWidget) {
    if (clickedWidget is TextField ||
        clickedWidget is CupertinoTextField ||
        clickedWidget is EditableText) {
      return true;
    }
    return false;
  }

  String? _getLabel(Widget widget) {
    String? label;

    if (widget is Text) {
      label = widget.data;
    } else if (widget is Semantics) {
      label = widget.properties.label;
    } else if (widget is Icon) {
      label = widget.semanticLabel;
    } else if (widget is Tooltip) {
      label = widget.message;
    }
    if (label?.isEmpty ?? true) {
      label = null;
    }
    return label;
  }

  String? _getTaggleValue(Widget widget) {
    String? value;

    if (widget is Checkbox) {
      value = widget.value.toString();
    }
    if (widget is Radio) {
      value = widget.groupValue.toString();
    }
    if (widget is RadioListTile) {
      value = widget.groupValue.toString();
    }
    if (widget is Switch) {
      value = widget.value.toString();
    }
    if (widget is SwitchListTile) {
      value = widget.selected.toString();
    }
    if (widget is CupertinoSwitch) {
      value = widget.value.toString();
    }
    if (widget is ToggleButtons) {
      value = widget.isSelected.toString();
    }

    return value;
  }

  String? _getTextInputValue(Widget widget) {
    String? label;
    String? hint;
    bool isSecret;

    if (widget is TextField) {
      isSecret = widget.obscureText;
      if (!isSecret) {
        label = widget.controller?.text;
        hint = widget.decoration?.hintText ?? widget.decoration?.labelText;
        if (hint == null) {
          if (widget.decoration?.label != null &&
              widget.decoration?.label is Text) {
            hint = (widget.decoration!.label! as Text).data;
          }
        }
      }
    }
    if (widget is CupertinoTextField) {
      isSecret = widget.obscureText;
      if (!isSecret) {
        label = widget.controller?.text;
        hint = widget.placeholder;
      }
    }
    if (widget is EditableText) {
      isSecret = widget.obscureText;
      if (!isSecret) {
        label = widget.controller.text;
      }
    }
    return label ?? hint;
  }

  String? _getSliderValue(Widget widget) {
    String? label;

    if (widget is Slider) {
      label = widget.value.toString();
    }
    if (widget is CupertinoSlider) {
      label = widget.value.toString();
    }
    if (widget is RangeSlider) {
      label = widget.values.toString();
    }

    return label;
  }

  String? _getLabelRecursively(Element element) {
    String? label;

    void descriptionFinder(Element element) {
      label ??= _getLabel(element.widget);

      if (label == null) {
        element.visitChildren(descriptionFinder);
      }
    }

    descriptionFinder(element);

    return label;
  }

  bool _isElementMounted(Element? element) {
    if (element == null) {
      return false;
    }
    return element.mounted && element.owner != null;
  }
}
