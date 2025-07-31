import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

import 'utils/utils.dart';

Future<void> assertOptionsPromptIsDisplayed(PatrolIntegrationTester $) async {
  final floatingButton = await getNativeView($,
      android: 'instabug_main_prompt_container',
      ios: 'IBGReportBugPromptOptionAccessibilityIdentifier');

  expect(
      isAndroid
          ? floatingButton.androidViews.length
          : floatingButton.iosViews.length,
      greaterThanOrEqualTo(1));
}

void main() {
  group('Bug reporting end-to-end test', () {
    patrolTest(
      'Report a bug',
      ($) async {
        await init($);

        await $.native2.tap(NativeSelector(
            ios: IOSSelector(
                identifier: 'IBGFloatingButtonAccessibilityIdentifier'),
            android: AndroidSelector(
                resourceName:
                    'com.instabug.flutter.example:id/instabug_floating_button')));

        await $.native2.tap(NativeSelector(
            ios: IOSSelector(labelContains: 'Report a bug'),
            android: AndroidSelector(textContains: 'Report a bug')));

        await $.native2.enterText(
          NativeSelector(
              ios: IOSSelector(
                  identifier:
                      'IBGBugInputViewEmailFieldAccessibilityIdentifier'),
              android: AndroidSelector(
                  resourceName:
                      'com.instabug.flutter.example:id/instabug_edit_text_email')),
          text: 'charlie@root.me',
        );

        await $.native2.tap(NativeSelector(
            ios: IOSSelector(
                identifier: 'IBGBugVCNextButtonAccessibilityIdentifier'),
            android: AndroidSelector(
                resourceName:
                    'com.instabug.flutter.example:id/instabug_bugreporting_send')));

        bool isAndroid = defaultTargetPlatform == TargetPlatform.android;
        if (isAndroid == false) {
          await Future.delayed(const Duration(milliseconds: 500));
        }
        final thankyou =
            await $.native.getNativeViews(Selector(textContains: "Thank you"));

        expect(thankyou.length, greaterThanOrEqualTo(1));
      },
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    );

    patrolTest(
      'Floating Button Invocation Event',
      ($) async {
        await init($);

        await $.native2.tap(NativeSelector(
            ios: IOSSelector(
                identifier: 'IBGFloatingButtonAccessibilityIdentifier'),
            android: AndroidSelector(
                resourceName:
                    'com.instabug.flutter.example:id/instabug_floating_button')));

        assertOptionsPromptIsDisplayed($);
      },
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    );

    patrolTest(
      'TwoFingers Swipe Left Invocation Event',
      ($) async {
        await init($);

        await $("Two Fingers Swipe Left").scrollTo().tap();
        await wait(second: 1);
        final gesture1 =
            await $.tester.startGesture(const Offset(300, 400)); // finger 1
        final gesture2 =
            await $.tester.startGesture(const Offset(300, 600)); // finger 2

// Swipe both fingers to the left (same direction)
        await gesture1.moveBy(const Offset(-150, 0));
        await gesture2.moveBy(const Offset(-150, 0));

// End gestures
        await gesture1.up();
        await gesture2.up();

        await wait(second: 1);
        assertOptionsPromptIsDisplayed($);
      },
      framePolicy: LiveTestWidgetsFlutterBindingFramePolicy.fullyLive,
    );
    patrolTest('None Invocation Event hides floating button', ($) async {
      await init($);

      await $('None').scrollTo().tap();

      await wait(second: 2);
      final floatingButton = await getFAB($, waitUntilVisible: false);

      expect(
          isAndroid
              ? floatingButton.androidViews.length
              : floatingButton.iosViews.length,
          equals(0));
    });

    patrolTest('Manual Invocation shows prompt options', ($) async {
      await init($);

      await $('Invoke').scrollTo().tap();

      await wait(second: 2);

      await assertOptionsPromptIsDisplayed($);
    });

    patrolTest('Multiple Screenshots in Repro Steps', ($) async {
      await init($);

      await $(#screen_name_input).scrollTo().enterText('My Screen');

      await wait(miliSeconds: 500);

      await $('Report Screen Change').scrollTo().tap();
      await wait(miliSeconds: 500);
      await $('Send Bug Report').scrollTo().tap();

      await $.native2.tap(NativeSelector(
        ios: IOSSelector(
            identifier: 'IBGBugVCReproStepsDisclaimerAccessibilityIdentifier'),
        android: AndroidSelector(
            resourceName:
                'com.instabug.flutter.example:id/instabug_text_view_repro_steps_disclaimer'),
      ));

      await wait(miliSeconds: 1000);

      final screenshots = await $.native2.getNativeViews(NativeSelector(
        ios: IOSSelector(
            identifier: 'IBGReproStepsTableCellViewAccessibilityIdentifier'),
        android: AndroidSelector(
            resourceName:
                'com.instabug.flutter.example:id/ib_bug_repro_step_screenshot'),
      ));

      final count = isAndroid
          ? screenshots.androidViews.length
          : screenshots.iosViews.length;

      expect(count, 2);
    });

    patrolTest('Floating Button moves to left edge', ($) async {
      await init($);

      await $('Move Floating Button to Left').scrollTo().tap();

      await wait(second: 5);

      final floatingButton = await getFAB($);

      await wait(second: 2);

      final size = $.tester.view.physicalSize / $.tester.view.devicePixelRatio;
      final width = size.width;
      $.log(floatingButton.androidViews.length.toString());

      bool isLeft = false;
      if (isAndroid && floatingButton.androidViews.isNotEmpty) {
        $.log(floatingButton.androidViews.first.visibleBounds.minX.toString());
        $.log(floatingButton.androidViews.first.visibleBounds.maxX.toString());
        $.log((width / 2).toString());

        isLeft =
            floatingButton.androidViews.first.visibleBounds.minX < (width / 2);
      } else if ((!isAndroid) && floatingButton.iosViews.isNotEmpty) {
        isLeft = floatingButton.iosViews.first.frame.minX < (width / 2);
      }

      expect(isLeft, true);
    });

    patrolTest('onDismiss callback triggers when prompt is cancelled',
        ($) async {
      await init($);

      await $('Set On Dismiss Callback').scrollTo().tap();
      await wait(second: 4);
      await $('Invoke').scrollTo().tap();

      await wait(second: 4);

      await tapNativeView($,
          nativeView: NativeSelector(
            android: AndroidSelector(text: 'Cancel'),
            ios: IOSSelector(label: 'Cancel'),
          ));

      await wait(second: 4);

      final callbackWidget = await $(#dismiss_callback_dialog_test)
          .waitUntilVisible(timeout: const Duration(seconds: 5));
      expect(callbackWidget, findsOneWidget);
    });
  });
}
