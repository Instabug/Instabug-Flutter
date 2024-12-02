import 'dart:async';

// import 'dart:nativewrappers/_internal/vm/lib/internal_patch.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _tapDeltaArea = 20 * 20;
Element? _clickTrackerElement;

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
  List<PointerEvent> _pointers = [];
  double _initialPinchDistance = 0.0;
  DateTime? currentTime;
  String? _gestureEvent;

  static const double _doubleTapThreshold = 300;

  void _onPointerDown(PointerDownEvent downEvent) {
    _isLongPressed = false;
    _pointerDownLocation = downEvent.localPosition;
    _lastTapTime = currentTime;

    _pointers.add(downEvent);
    _checkPinchStart();

    _timer = Timer(const Duration(milliseconds: 500), () {
      _isLongPressed = true;
    });
  }

  void _onPointerMove(PointerMoveEvent moveEvent) {
    if (_pointers.length == 2) {
      _updatePinchDistance(moveEvent);
    } else {
      _getSwipeDirection(moveEvent);
    }
  }

  void _onPointerUp(PointerUpEvent upEvent) {
    _timer?.cancel();
    currentTime = DateTime.now();

    final deltaX = upEvent.localPosition.dx - _pointerDownLocation!.dx;
    final deltaY = upEvent.localPosition.dy - _pointerDownLocation!.dy;
    const tapSensitivity = 20;
    if (deltaX.abs() < tapSensitivity && deltaY.abs() < tapSensitivity) {
      if (_isLongPressed!) {
        _gestureEvent = 'long press';
      } else if (_lastTapTime != null &&
          currentTime!.difference(_lastTapTime!).inMilliseconds <=
              _doubleTapThreshold) {
        _gestureEvent = 'Double Tap';
      } else {
        _gestureEvent = 'Tap';
      }
    }
    _pointers.removeWhere((pointer) => pointer.pointer == upEvent.pointer);

    if (_pointers.length == 1) {
      _initialPinchDistance = 0.0;
      _gestureEvent = 'Pinched';
    }
    final tappedWidget = _getTappedWidget(upEvent.localPosition);

    if (tappedWidget["widget"] == null) {
      tappedWidget["widget"] = "View";
    }
    print(
        "$_gestureEvent ${tappedWidget["widget"]} ${tappedWidget["description"]}");
  }

  void _checkPinchStart() {
    if (_pointers.length == 2) {
      final firstPointer = _pointers[0].localPosition;
      final secondPointer = _pointers[1].localPosition;
      _initialPinchDistance = (firstPointer - secondPointer).distance;
    }
  }

  void _updatePinchDistance(PointerMoveEvent moveEvent) {
    if (_pointers.length == 2) {
      final firstPointer = _pointers[0].localPosition;
      final secondPointer = _pointers[1].localPosition;
      final currentPinchDistance = (firstPointer - secondPointer).distance;

      // If there's a significant change in pinch distance, detect zoom (in/out)
      if ((currentPinchDistance - _initialPinchDistance).abs() > 10) {
        if (currentPinchDistance > _initialPinchDistance) {
          print('pinch zooming in');
        } else {
          print('pinch zooming out');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerDown: _onPointerDown,
      onPointerUp: _onPointerUp,
      onPointerMove: _onPointerMove,
      child: widget.child,
    );
  }

  void _getSwipeDirection(PointerMoveEvent moveEvent) {
    const swipeSensitivity = 8;
    if (moveEvent.delta.dx > swipeSensitivity) {
      _swipeDirection = 'Right';
    }
    if (moveEvent.delta.dx < -swipeSensitivity) {
      _swipeDirection = 'Left';
    }
    if (moveEvent.delta.dy > swipeSensitivity) {
      _swipeDirection = 'Up';
    }
    if (moveEvent.delta.dy < -swipeSensitivity) {
      _swipeDirection = 'Down';
    }
  }

  Map<String, dynamic> _getTappedWidget(Offset location) {
    String? tappedWidget;
    String? text;

    void visitor(Element visitedElement) {
      final renderObject = visitedElement.renderObject;

      if (renderObject == null) {
        return;
      }

      final transform =
          renderObject.getTransformTo(_clickTrackerElement!.renderObject);

      if (_isAlertSheet(visitedElement.widget)) {
        tappedWidget = "AlertSheetWidget";
        return;
      }

      final paintBounds =
          MatrixUtils.transformRect(transform, renderObject.paintBounds);

      if (paintBounds.contains(location)) {
        if (_isSliderWidget(visitedElement.widget)) {
          _gestureEvent = 'Swipe';

          tappedWidget = "SliderWidget";
          text =
              "A slider changed to ${_getSliderValue(visitedElement.widget)}";
          _swipeDirection = null;
          return;
        }
        if (_isScrollableWidget(visitedElement.widget) == true &&
            _swipeDirection is String) {
          tappedWidget = "ListWidget";
          _gestureEvent = 'Scroll';
          _swipeDirection = null;
          return;
        }
        if (_isImageWidget(visitedElement.widget)) {
          tappedWidget = "ImageWidget";
          text = "Image";
          return;
        }
        if (_isButtonWidget(visitedElement.widget)) {
          tappedWidget = "ButtonWidget";
          text = _getLabelRecursively(visitedElement);
          return;
        }
        if (_isTextWidget(visitedElement.widget)) {
          tappedWidget = "TextWidget";
          text = _getLabelRecursively(visitedElement);
          return;
        }
        if (_isToggleableWidget(visitedElement.widget)) {
          tappedWidget = "ToggleableWidget";
          text = _getTaggleValue(visitedElement.widget);
          return;
        }
        if (_isTextInputWidget(visitedElement.widget)) {
          tappedWidget = "TextInputWidget";
          text = _getTextInputValue(visitedElement.widget);
          return;
        }
      }

      if (tappedWidget == null) {
        visitedElement.visitChildElements(visitor);
      }
    }

    _clickTrackerElement?.visitChildElements(visitor);

    return {'widget': tappedWidget, 'description': text};
  }

  bool _isScrollableWidget(Widget clickedWidget) {
    if (clickedWidget is ScrollView ||
        clickedWidget is SingleChildScrollView ||
        clickedWidget is PageView ||
        clickedWidget is SliverMultiBoxAdaptorWidget ||
        clickedWidget is Scrollable ||
        clickedWidget is NestedScrollView ||
        clickedWidget is SliverAppBar ||
        clickedWidget is DraggableScrollableSheet) {
      return true;
    }
    return false;
  }

  bool _isButtonWidget(Widget clickedWidget) {
    if (clickedWidget is ButtonStyleButton ||
        clickedWidget is MaterialButton ||
        clickedWidget is CupertinoButton ||
        clickedWidget is InkWell ||
        clickedWidget is IconButton ||
        clickedWidget is PopupMenuButton ||
        clickedWidget is FloatingActionButton ||
        clickedWidget is BackButton ||
        clickedWidget is DropdownButton ||
        clickedWidget is IconButton) {
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

  bool _isAlertSheet(Widget clickedWidget) {
    if (clickedWidget is AlertDialog ||
        clickedWidget is SimpleDialog ||
        clickedWidget is CupertinoAlertDialog ||
        clickedWidget is CupertinoActionSheet ||
        clickedWidget is BottomSheet ||
        clickedWidget is SnackBar ||
        clickedWidget is Dialog ||
        clickedWidget is CupertinoActionSheet) {
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
    bool isSecret;

    if (widget is TextField) {
      isSecret = widget.obscureText;
      if (!isSecret) {
        label = widget.controller?.text;
      }
    }
    if (widget is CupertinoTextField) {
      isSecret = widget.obscureText;
      if (!isSecret) {
        label = widget.controller?.text;
      }
    }
    if (widget is EditableText) {
      isSecret = widget.obscureText;
      if (!isSecret) {
        label = widget.controller?.text;
      }
    }
    return label;
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
}
