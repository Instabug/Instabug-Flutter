import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'utils/utils.dart';

void main() {
  group('instabug test', () {
    patrolTest(
      'ChangePrimaryColor',
      ($) async {
        await init($);

        var color = "#FF0000";
        await $(#enter_primary_color_input).scrollTo().enterText(color);
        await $('Change Primary Color').scrollTo().tap();

        await wait(second: 1);

        final floatingButton = await getFAB($);

        expect(
            isAndroid
                ? floatingButton.androidViews.length
                : floatingButton.iosViews.length,
            equals(1));
      },
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    );
  });
}
