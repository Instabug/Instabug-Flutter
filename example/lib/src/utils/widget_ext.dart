import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget withSemanticsLabel(String label) {
    return Semantics(
      label: label,
      child: this,
    );
  }
}
