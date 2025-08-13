import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'utils/utils.dart';

void main() {
  group('Feature Requests tests', () {
    patrolTest(
      'Show Feature Requests Screen',
      ($) async {
        await init($);

        await $('Show Feature Requests').scrollTo().tap();

        await wait(second: 1);

        final title = await getNativeView($,
            ios: 'IBGFeatureListTableView', android: 'ib_fr_toolbar_main');

        expect(isAndroid ? title.androidViews.length : title.iosViews.length,
            equals(1));
      },
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    );
  });
}
