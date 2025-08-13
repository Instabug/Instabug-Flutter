import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'utils/utils.dart';

void main() {
  group('Surveys tests', () {
    patrolTest(
      'Show Surveys Screen',
      ($) async {
        await init($);

        await wait(second: 2);

        await $('Show Manual Survey').scrollTo().tap();

        await wait(second: 2);

        final title = await getNativeView($,
            ios: 'SurveyNavigationVC',
            android: 'instabug_survey_dialog_container');

        expect(isAndroid ? title.androidViews.length : title.iosViews.length,
            equals(1));
      },
    );
  });
}
