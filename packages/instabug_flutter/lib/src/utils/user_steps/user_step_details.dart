import 'package:flutter/material.dart';
import 'package:instabug_flutter/src/utils/user_steps/widget_utils.dart';

enum GestureType { swipe, scroll, tap, pinch, longPress, doubleTap }

extension GestureTypeText on GestureType {
  String get text {
    switch (this) {
      case GestureType.swipe:
        return "Swiped";
      case GestureType.scroll:
        return "Scrolled";
      case GestureType.tap:
        return "Tapped";
      case GestureType.pinch:
        return "Pinched";
      case GestureType.longPress:
        return "Long Pressed";
      case GestureType.doubleTap:
        return "Double Tapped";
    }
  }
}

class UserStepDetails {
  final Element? element;
  final bool isPrivate;
  final GestureType? gestureType;
  final String? gestureMetaData;
  final Widget? widget;

  UserStepDetails({
    required this.element,
    required this.isPrivate,
    this.gestureType,
    this.gestureMetaData,
  }) : widget = element?.widget;

  String? get key => widget == null ? null : keyToStringValue(widget!.key);

  String? get widgetName {
    if (widget == null) return null;
    if (widget is InkWell) {
      final inkWell = widget! as InkWell;
      if (inkWell.child == null) {
        return widget.runtimeType.toString();
      }
      return "${inkWell.child.runtimeType} Wrapped with ${widget.runtimeType}";
    } else if (widget is GestureDetector) {
      final gestureDetector = widget! as GestureDetector;

      if (gestureDetector.child == null) {
        return widget.runtimeType.toString();
      }
      return "${gestureDetector.child.runtimeType} Wrapped with ${widget.runtimeType}";
    }
    return widget.runtimeType.toString();
  }

  String? get message {
    if (gestureType == null) return null;
    if (gestureType == GestureType.pinch) {
      return gestureType?.text;
    }
    var baseMessage =
        "${gestureType!.text} ${gestureMetaData?.isNotEmpty == true ? '$gestureMetaData ' : ''}";
    if (widgetName != null) baseMessage += "on $widgetName";
    if (key != null) baseMessage += " with key '$key'";

    if (!isPrivate && widget != null) {
      final additionalInfo = _getWidgetSpecificDetails();
      if (additionalInfo != null) baseMessage += additionalInfo;
    }

    return baseMessage;
  }

  String? _getWidgetSpecificDetails() {
    if (isSliderWidget(widget!)) {
      final value = getSliderValue(widget!);
      if (value?.isNotEmpty == true) {
        return " and it's value is changed to '$value'";
      }
    } else if (isTextWidget(widget!) || isButtonWidget(widget!)) {
      final label = getLabelRecursively(element!);
      if (label?.isNotEmpty == true) {
        return " and it's label is '$label'";
      }
    } else if (isToggleableWidget(widget!)) {
      final value = getToggleValue(widget!);
      if (value?.isNotEmpty == true) {
        return " and it's value is '$value'";
      }
    } else if (isTextInputWidget(widget!)) {
      final value = getTextInputValue(widget!);
      final hint = getTextHintValue(widget!);
      return [
        if (value?.isNotEmpty == true) " and it's value is '$value'",
        if (hint?.isNotEmpty == true) " and it's placeholder is '$hint'",
      ].join();
    }
    return null;
  }

  UserStepDetails copyWith({
    Element? element,
    bool? isPrivate,
    GestureType? gestureType,
    String? gestureMetaData,
  }) {
    return UserStepDetails(
      element: element ?? this.element,
      isPrivate: isPrivate ?? this.isPrivate,
      gestureType: gestureType ?? this.gestureType,
      gestureMetaData: gestureMetaData ?? this.gestureMetaData,
    );
  }
}
