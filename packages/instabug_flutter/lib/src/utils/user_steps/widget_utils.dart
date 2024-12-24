import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// Converts a [Key] into a string representation, supporting various key types.
String? keyToStringValue(Key? key) {
  if (key == null) return null;

  if (key is ValueKey) {
    return key.value?.toString();
  } else if (key is GlobalObjectKey) {
    return key.value.toString();
  } else if (key is ObjectKey) {
    return key.value?.toString();
  }

  return key.toString();
}

/// Checks if a widget is a button or button-like component.
bool isButtonWidget(Widget widget) {
  if (widget is ButtonStyleButton) return widget.enabled;
  if (widget is MaterialButton) return widget.enabled;
  if (widget is CupertinoButton) return widget.enabled;
  if (widget is IconButton) return widget.onPressed != null;
  if (widget is FloatingActionButton) return widget.onPressed != null;
  if (widget is BackButton) return widget.onPressed != null;
  if (widget is PopupMenuButton) return widget.enabled;
  if (widget is DropdownButton) return widget.onTap != null;

  if (widget is GestureDetector) {
    return widget.onTap != null ||
        widget.onLongPress != null ||
        widget.onDoubleTap != null ||
        widget.onTapDown != null;
  }

  if (widget is InkWell) {
    return widget.onTap != null ||
        widget.onLongPress != null ||
        widget.onDoubleTap != null ||
        widget.onTapDown != null;
  }

  return false;
}

/// Checks if a widget can respond to tap-related gestures.
bool isTappedWidget(Widget? widget) {
  if (widget == null) return false;

  return isButtonWidget(widget) ||
      isToggleableWidget(widget) ||
      isSliderWidget(widget) ||
      isTextInputWidget(widget);
}

/// Checks if a widget supports swipe gestures.
bool isSwipedWidget(Widget? widget) {
  return widget is Slider ||
      widget is CupertinoSlider ||
      widget is RangeSlider ||
      widget is Dismissible;
}

/// Determines if a widget supports pinch gestures (defaulting to those not tappable or swipeable).
bool isPinchWidget(Widget? widget) {
  return (!isSwipedWidget(widget)) && widget is GestureDetector || widget is Transform  || isImageWidget(widget);
}

/// Checks if a widget is primarily for displaying text.
bool isTextWidget(Widget widget) {
  return widget is Text ||
      widget is RichText ||
      widget is SelectableText ||
      widget is TextSpan ||
      widget is Placeholder ||
      widget is TextStyle;
}

/// Checks if a widget is a slider.
bool isSliderWidget(Widget widget) {
  return widget is Slider || widget is CupertinoSlider || widget is RangeSlider;
}

/// Checks if a widget is an image or image-like.
bool isImageWidget(Widget? widget) {
  if(widget==null) {
    return false;
  }
  return widget is Image ||
      widget is FadeInImage ||
      widget is NetworkImage ||
      widget is AssetImage ||
      widget is Icon ||
      widget is FileImage ||
      widget is MemoryImage ||
      widget is ImageProvider;
}

/// Checks if a widget is toggleable (e.g., switch, checkbox, etc.).
bool isToggleableWidget(Widget widget) {
  return widget is Checkbox ||
      widget is CheckboxListTile ||
      widget is Radio ||
      widget is RadioListTile ||
      widget is Switch ||
      widget is SwitchListTile ||
      widget is CupertinoSwitch ||
      widget is ToggleButtons;
}

/// Checks if a widget is a text input field.
bool isTextInputWidget(Widget widget) {
  return widget is TextField ||
      widget is CupertinoTextField ||
      widget is EditableText;
}

/// Retrieves the label of a widget if available.
String? getLabel(Widget widget) {
  if (widget is Text) return widget.data;
  if (widget is Semantics) return widget.properties.label;
  if (widget is Icon) return widget.semanticLabel;
  if (widget is Tooltip) return widget.message;

  return null;
}

/// Retrieves the value of a toggleable widget.
String? getToggleValue(Widget widget) {
  if (widget is Checkbox) return widget.value.toString();
  if (widget is Radio) return widget.groupValue.toString();
  if (widget is RadioListTile) return widget.groupValue.toString();
  if (widget is Switch) return widget.value.toString();
  if (widget is SwitchListTile) return widget.value.toString();
  if (widget is CupertinoSwitch) return widget.value.toString();
  if (widget is ToggleButtons) return widget.isSelected.toString();

  return null;
}

/// Retrieves the value entered in a text input field.
String? getTextInputValue(Widget widget) {
  if (widget is TextField && !widget.obscureText) {
    return widget.controller?.text;
  } else if (widget is CupertinoTextField && !widget.obscureText) {
    return widget.controller?.text;
  } else if (widget is EditableText && !widget.obscureText) {
    return widget.controller.text;
  }

  return null;
}

/// Retrieves the hint value of a text input widget.
String? getTextHintValue(Widget widget) {
  if (widget is TextField && !widget.obscureText) {
    return widget.decoration?.hintText ?? widget.decoration?.labelText;
  } else if (widget is CupertinoTextField && !widget.obscureText) {
    return widget.placeholder;
  }

  return null;
}

/// Retrieves the current value of a slider widget.
String? getSliderValue(Widget widget) {
  if (widget is Slider) return widget.value.toString();
  if (widget is CupertinoSlider) return widget.value.toString();
  if (widget is RangeSlider) return "(${widget.values.start},${widget.values.end})";

  return null;
}

/// Recursively searches for a label within a widget hierarchy.
String? getLabelRecursively(Element element) {
  String? label;

  void visitor(Element e) {
    label ??= getLabel(e.widget);
    if (label == null) e.visitChildren(visitor);
  }

  visitor(element);

  return label;
}
