import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_private_views/src/instabug_sliver_private_view.dart';
import 'package:instabug_private_views/src/private_views_manager.dart';
import 'package:instabug_private_views/src/visibility_detector/base_render_visibility_detector.dart';
import 'package:mockito/mockito.dart';

import 'instabug_private_view_test.mocks.dart';

void main() {
  testWidgets('should mask sliver view when it is visible', (tester) async {
    await tester.runAsync(() async {
      final mock = MockPrivateViewsManager();
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      PrivateViewsManager.setInstance(mock);

      await tester.pumpWidget(
        MaterialApp(
          home: CustomScrollView(
            slivers: [
              InstabugSliverPrivateView(
                sliver: const SliverToBoxAdapter(
                  child: SizedBox(
                    width: 20,
                    height: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      );

      verify(
        mock.mask(any),
      ).called(
        2,
      ); // one for initState and the other for visibility is shown is true
    });
  });

  testWidgets('should un-mask the sliver view when it is invisible',
      (tester) async {
    await tester.runAsync(() async {
      final mock = MockPrivateViewsManager();
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      PrivateViewsManager.setInstance(mock);
      var isVisible = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SafeArea(
              child: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return CustomScrollView(
                    slivers: [
                      SliverToBoxAdapter(
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              isVisible = false; // make the widget invisible
                            });
                          },
                          child: const Text('Make invisible'),
                        ),
                      ),
                      SliverVisibility(
                        visible: isVisible,
                        maintainState: true,
                        sliver: InstabugSliverPrivateView(
                          sliver: const SliverToBoxAdapter(
                            child: SizedBox(
                              width: 40,
                              height: 40,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Make invisible'));
      await tester.pump(const Duration(milliseconds: 300));

      verify(
        mock.unMask(any),
      ).called(
        1,
      );
    });
  });
}
