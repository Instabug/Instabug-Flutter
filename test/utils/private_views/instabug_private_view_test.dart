import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/base_render_visibility_detector.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'instabug_private_view_test.mocks.dart';

@GenerateMocks([PrivateViewsManager])
void main() {
  testWidgets('should mask the view when it is visible', (tester) async {
    await tester.runAsync(() async {
      final mock = MockPrivateViewsManager();
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      PrivateViewsManager.setInstance(mock);
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: InstabugPrivateView(
              child: const Text('Text invisible'),
            ),
          ),
        ),
      );

      verify(
        mock.mask(any),
      ).called(
        1,
      ); // one for initState and the other for visibility is shown is true
    });
  });

  testWidgets("should un-mask the view when it is invisible", (tester) async {
    await tester.runAsync(() async {
      final mock = MockPrivateViewsManager();
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      PrivateViewsManager.setInstance(mock);
      var isVisible = true;
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ListView(
                  children: [
                    Visibility(
                      visible: isVisible,
                      maintainState: true,
                      child: InstabugPrivateView(
                        child: const SizedBox(
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          isVisible = false; // make the widget invisible
                        });
                      },
                      child: const Text('Make invisible'),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      );
      await tester.tap(find.text('Make invisible'));
      await tester.pump(const Duration(seconds: 1));
      verify(
        mock.unMask(any),
      ).called(
        1,
      );
    });
  });
}
