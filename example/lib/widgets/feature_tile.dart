import 'package:flutter/material.dart';

class FeatureTile extends StatelessWidget {
  final Widget leading;
  final Widget title;
  final Function? onTap;
  final Widget? right;
  final Widget? bottom;
  final int? leftFlex;
  final int? rightFlex;
  final Widget? trailing;

  const FeatureTile({
    super.key,
    required this.leading,
    required this.title,
    this.onTap,
    this.right,
    this.bottom,
    this.leftFlex,
    this.rightFlex,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: leftFlex ?? 1,
              child: ListTile(
                leading: IconTheme(
                  data: Theme.of(context).iconTheme,
                  child: leading,
                ),
                title: title,
                trailing: trailing,
                onTap: onTap != null ? () => onTap!() : null,
              ),
            ),
            if (right != null)
              Expanded(
                flex: rightFlex ?? 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: right!,
                ),
              ),
          ],
        ),
        if (bottom != null)
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
            child: bottom!,
          )
      ],
    );
  }
}
