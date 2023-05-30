import 'package:flutter/material.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class SurveysScreen extends StatefulWidget {
  const SurveysScreen({super.key});

  @override
  State<SurveysScreen> createState() => _SurveysScreenState();
}

class _SurveysScreenState extends State<SurveysScreen> {
  final surveyTokenController = TextEditingController();

  @override
  void dispose() {
    surveyTokenController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Surveys',
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
                  leading: const Icon(Icons.rate_review),
                  title: const Text('Show if available'),
                  onTap: () {
                    Surveys.showSurveyIfAvailable();
                  },
                ),
                FeatureTile(
                  leading: const Icon(Icons.generating_tokens),
                  title: const Text('Manual Survey'),
                  bottom: TextField(
                    controller: surveyTokenController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.left,
                    textAlignVertical: TextAlignVertical.top,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 8.0,
                        horizontal: 8.0,
                      ),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (String value) =>
                        Surveys.showSurvey(surveyTokenController.text),
                    enableInteractiveSelection: true,
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
