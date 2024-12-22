import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetUtils {
  static String? toStringValue(Key? key) {
    if (key == null) {
      return null;
    }
    if (key is ValueKey<String>) {
      return key.value;
    } else if (key is ValueKey) {
      return key.value?.toString();
    } else if (key is GlobalObjectKey) {
      return key.value.toString();
    } else if (key is ObjectKey) {
      return key.value?.toString();
    }
    return key.toString();
  }

  static bool isButtonWidget(Widget widget) {
    if (widget is ButtonStyleButton) {
      return widget.enabled;
    } else if (widget is MaterialButton) {
      return widget.enabled;
    } else if (widget is CupertinoButton) {
      return widget.enabled;
    } else if (widget is InkWell) {
      return widget.onTap != null ||
          widget.onLongPress != null ||
          widget.onDoubleTap != null ||
          widget.onTapDown != null;
    } else if (widget is GestureDetector) {
      return widget.onTap != null ||
          widget.onLongPress != null ||
          widget.onDoubleTap != null ||
          widget.onTapDown != null;
    } else if (widget is IconButton) {
      return widget.onPressed != null;
    } else if (widget is PopupMenuButton) {
      return widget.enabled;
    } else if (widget is PopupMenuItem) {
      return widget.enabled;
    } else if (widget is FloatingActionButton) {
      return widget.onPressed != null;
    } else if (widget is BackButton) {
      return widget.onPressed != null;
    } else if (widget is DropdownButton) {
      return widget.onTap != null;
    }
    return false;
  }

  static bool isTappedWidget(Widget? widget) {
    if (widget == null) {
      return false;
    }
    return isButtonWidget(widget) ||
        isToggleableWidget(widget) ||
        isSliderWidget(widget) ||
        isTextInputWidget(widget);
  }

  static bool isSwipedWidget(Widget? widget) {
    if (widget == null) {
      return false;
    }
    return isSwipedWidget(widget) || widget is Dismissible;
  }

  static bool isPinchWidget(Widget? widget) {
    return isTappedWidget(widget) == false && isSwipedWidget(widget) == false;
  }

  static bool isTextWidget(Widget clickedWidget) {
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

  static bool isSliderWidget(Widget clickedWidget) {
    if (clickedWidget is Slider ||
        clickedWidget is CupertinoSlider ||
        clickedWidget is RangeSlider) {
      return true;
    }
    return false;
  }

  static bool isImageWidget(Widget clickedWidget) {
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

  static bool isToggleableWidget(Widget clickedWidget) {
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

  static bool isTextInputWidget(Widget clickedWidget) {
    if (clickedWidget is TextField ||
        clickedWidget is CupertinoTextField ||
        clickedWidget is EditableText) {
      return true;
    }
    return false;
  }

  static  String? getLabel(Widget widget) {
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

  static  String? getToggleValue(Widget widget) {
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

  static  String? getTextInputValue(Widget widget) {
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

  static String? getSliderValue(Widget widget) {
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

  static String? getLabelRecursively(Element element) {
    String? label;

    void descriptionFinder(Element element) {
      label ??= getLabel(element.widget);

      if (label == null) {
        element.visitChildren(descriptionFinder);
      }
    }

    descriptionFinder(element);

    return label;
  }
}
