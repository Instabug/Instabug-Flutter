import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../providers/core_state.dart';
import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class CoreScreen extends StatefulWidget {
  const CoreScreen({super.key});

  @override
  State<CoreScreen> createState() => _CoreScreenState();
}

class _CoreScreenState extends State<CoreScreen> {
  @override
  Widget build(BuildContext context) {
    final state = Provider.of<CoreState>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Core',
        ),
      ),
      body: MediaQuery.removePadding(
        context: context,
        removeBottom: true,
        removeTop: true,
        child: SeparatedListView(
          padding: const EdgeInsets.all(8.0),
          separator: const SizedBox(
            height: 8.0,
          ),
          children: <Widget>[
            SectionCard(
              children: [
                FeatureTile(
                  leading: const Icon(
                    Icons.disabled_by_default_outlined,
                  ),
                  title: const Text('Disable SDK'),
                  trailing: Switch(
                    value: state.isDisabled,
                    onChanged: (value) {
                      Instabug.setEnabled(!value);
                      state.isDisabled = value;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
