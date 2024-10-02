import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';
import 'package:instabug_flutter/src/utils/private_views/visibility_detector/base_render_visibility_detector.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  testWidgets(
      '[getPrivateViews] should return rect bounds data when there is a masked widget',
      (tester) async {
    await tester.runAsync(() async {
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: InstabugPrivateView(
                child: Text(
                  'Text invisible',
                  key: key,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(seconds: 1));

      expect(PrivateViewsManager.I.getPrivateViews().length, 4);
      final rect = PrivateViewsManager.I.getLayoutRectInfoFromKey(key);
      expect(PrivateViewsManager.I.getPrivateViews(), [
        rect?.left,
        rect?.top,
        rect?.right,
        rect?.bottom,
      ]);
    });
  });
  testWidgets(
      '[getPrivateViews] should return rect bounds data when there is a masked widget (Sliver)',
      (tester) async {
    await tester.runAsync(() async {
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      final key = GlobalKey();
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomScrollView(
              slivers: [
                InstabugSliverPrivateView(
                  sliver: SliverToBoxAdapter(
                    child: Text(
                      'Text invisible',
                      key: key,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));
      expect(PrivateViewsManager.I.getPrivateViews().length, 4);
      final rect = PrivateViewsManager.I.getLayoutRectInfoFromKey(key);
      expect(PrivateViewsManager.I.getPrivateViews(), [
        rect?.left,
        rect?.top,
        rect?.right,
        rect?.bottom,
      ]);
    });
  });

  testWidgets(
      "[getPrivateViews] should return empty rect bounds data when there is no masked widget",
      (tester) async {
    await tester.runAsync(() async {
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      var isVisible = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
                return ListView(
                  shrinkWrap: true,
                  children: [
                    Visibility(
                      visible: isVisible,
                      child:
                          InstabugPrivateView(child: const Text("masked text")),
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
      await tester.pump(const Duration(seconds: 2));
      expect(PrivateViewsManager.I.getPrivateViews().length, 0);
    });
  });
  testWidgets(
      "[getPrivateViews] should return empty rect bounds data when there is no  masked widget (Sliver)",
      (tester) async {
    await tester.runAsync(() async {
      RenderVisibilityDetectorBase.updateInterval = Duration.zero;
      var isVisible = true;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
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
      );
      await tester.tap(find.text('Make invisible'));
      await tester.pump(const Duration(seconds: 2));
      expect(PrivateViewsManager.I.getPrivateViews().length, 0);
    });
  });
}
