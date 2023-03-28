import 'package:flutter/material.dart';

import '../widgets/separated_list_view.dart';

class SectionCard extends StatelessWidget {
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Theme.of(context).cardColor,
      ),
      child: SeparatedListView(
        separator: const Divider(
          height: 4.0,
          thickness: 1.0,
        ),
        primary: false,
        shrinkWrap: true,
        children: children,
      ),
    );
  }
}
