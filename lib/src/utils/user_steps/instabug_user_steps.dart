import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

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
  bool? _isLongPressed;

  Offset? _pointerDownLocation;

  Timer? _timer;

  String? _swipeDirection;

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification notification) {
        if (notification is ScrollStartNotification) {
          print("Scroll started");
        } else if (notification is ScrollUpdateNotification) {
          print("Scrolling... Current Offset: ${notification.metrics.pixels}");
        } else if (notification is ScrollEndNotification) {
          print("Scroll ended");
        }
        return true;
      },
      child: Listener(
        behavior: HitTestBehavior.translucent,
        onPointerDown: _onPointerDown,
        onPointerUp: _onPointerUp,
        onPointerMove: _onPointerMove,
        child: widget.child,
      ),
    );
  }

  void _onPointerDown(PointerDownEvent downEvent) {
    _isLongPressed = false;
    _pointerDownLocation = downEvent.localPosition;
    _timer = Timer(const Duration(milliseconds: 500), () {
      _isLongPressed = true;
    });
  }
  void _onPointerMove(PointerMoveEvent moveEvent) {
    const swipeSensitivity = 8;
    if (moveEvent.delta.dx > swipeSensitivity) {
      _swipeDirection = 'right';
    }
    if (moveEvent.delta.dx < -swipeSensitivity) {
      _swipeDirection = 'left';
    }
    if (moveEvent.delta.dy > swipeSensitivity) {
      _swipeDirection = 'down';
    }
    if (moveEvent.delta.dy < -swipeSensitivity) {
      _swipeDirection = 'up';
    }
  }
  void _onPointerUp(PointerUpEvent upEvent) {
    _timer!.cancel();
    final deltaX = upEvent.localPosition.dx - _pointerDownLocation!.dx;
    final deltaY = upEvent.localPosition.dy - _pointerDownLocation!.dy;
    const tapSensitivity = 20;
    if (deltaX.abs() < tapSensitivity && deltaY.abs() < tapSensitivity) {
      if (_isLongPressed!) {
        print('long press');
      } else {
        print('tap');
      }
      final tappedWidget = _getTappedWidget(upEvent.localPosition);
      print(tappedWidget['widget']);
      print(tappedWidget['description']);
    } else {
      switch (_swipeDirection) {
        case 'right':
          print('swipe right');
          break;
        case 'left':
          print('swipe left');
          break;
        case 'up':
          print('swipe up');
          break;
        case 'down':
          print('swipe down');
          break;
      }
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
      final paintBounds =
          MatrixUtils.transformRect(transform, renderObject.paintBounds);
      if (paintBounds.contains(location)) {
        if (visitedElement.widget is ButtonStyleButton ||
            visitedElement.widget is TextField) {
          tappedWidget = _getElementType(visitedElement);
          text = _getLabelRecursively(
              visitedElement); //gets the text/label rendered inside the widget
        }
      }
      if (tappedWidget == null) {
        visitedElement.visitChildElements(visitor);
      }
    }

    _clickTrackerElement?.visitChildElements(visitor);
    return {'widget': tappedWidget, 'description': text};
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

  String? _getWidgetMetadata(Element visitedElement) {
    Text? textWidget;
    void visitor(Element visitedElement) {
      if (visitedElement.widget is Text) {
        textWidget = visitedElement.widget as Text?;
        return;
      } else {
        visitedElement.visitChildElements(visitor);
      }
    }

    visitedElement.visitChildElements(visitor);
    return textWidget!.data;
  }

  String? _getLabel(Element element, bool allowText) {
    String? label;

    final widget = element.widget;
    if (allowText && widget is Text) {
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

  String? _getLabelRecursively(Element element) {
    String? label;

    final widget = element.widget;
    final allowText = widget is ButtonStyleButton ||
        widget is MaterialButton ||
        widget is CupertinoButton;

    // traverse tree to find a suiting element
    void descriptionFinder(Element element) {
      label ??= _getLabel(element, allowText);
      if (label == null) {
        element.visitChildren(descriptionFinder);
      }
    }

    descriptionFinder(element);

    return label;
  }
}
