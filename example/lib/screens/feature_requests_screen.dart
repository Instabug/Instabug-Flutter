import 'package:flutter/material.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class FeatureRequestsScreen extends StatelessWidget {
  const FeatureRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Feature Requests',
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
          children: const <Widget>[
            SectionCard(
              children: [
                FeatureTile(
                  leading: Icon(Icons.lightbulb),
                  title: Text('Show Feature Requests'),
                  onTap: FeatureRequests.show,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
