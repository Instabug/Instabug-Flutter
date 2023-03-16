import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/settings_state.dart';
import '../widgets/separated_list_view.dart';

class SectionCard extends StatelessWidget {
  final List<Widget> children;

  const SectionCard({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final state = Provider.of<SettingsState>(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: state.getThemeData().cardColor,
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
