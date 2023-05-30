import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:instabug_flutter/instabug_flutter.dart';

import '../widgets/feature_tile.dart';
import '../widgets/section_card.dart';
import '../widgets/separated_list_view.dart';

class CrashReportingScreen extends StatelessWidget {
  const CrashReportingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Crash Reporting',
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
          children: [
            SectionCard(
              children: [
                FeatureTile(
                  leading: const Icon(Icons.warning_amber_outlined),
                  title: const Text('Handled Crash'),
                  onTap: () {
                    try {
                      throw Exception(
                        'This is a handled crash from Instabug Example App',
                      );
                    } catch (error, stacktrace) {
                      CrashReporting.reportHandledCrash(error, stacktrace);
                      const snackBar = SnackBar(
                        content: Text(
                          'A handled crash has been successfully reported!',
                        ),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
                FeatureTile(
                  leading: const Icon(Icons.warning),
                  title: const Text('Unhandled Crash'),
                  onTap: () {
                    try {
                      final arr = [1, 2];
                      arr[2];
                    } finally {
                      const snackBarText = kDebugMode
                          ? 'Unhandled Crashes will only be reported in release mode and not in debug mode.'
                          : 'An unhandled crash has been successfully reported!';
                      const snackBar = SnackBar(
                        content: Text(snackBarText),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
