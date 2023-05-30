import 'package:flutter/material.dart';

class SeparatedListView extends ListView {
  final List<Widget> children;
  final Widget separator;

  SeparatedListView({
    super.key,
    super.padding,
    super.primary,
    super.shrinkWrap,
    super.physics = const ClampingScrollPhysics(),
    required this.children,
    required this.separator,
  }) : super.separated(
          itemBuilder: (_, index) => children[index],
          separatorBuilder: (_, __) => separator,
          itemCount: children.length,
        );
}
