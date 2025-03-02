import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/utils/private_views/private_views_manager.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  group('PrivateViewsManager Tests', () {
    late PrivateViewsManager manager;

    setUp(() {
      manager = PrivateViewsManager.instance;
    });

    test('isPrivateWidget detects InstabugPrivateView', () {
      final widget = InstabugPrivateView(child: Container());
      expect(PrivateViewsManager.isPrivateWidget(widget), isTrue);
    });

    test('isPrivateWidget detects InstabugSliverPrivateView', () {
      final widget = InstabugSliverPrivateView(sliver: Container());
      expect(PrivateViewsManager.isPrivateWidget(widget), isTrue);
    });

    test('isPrivateWidget returns false for other widgets', () {
      expect(PrivateViewsManager.isPrivateWidget(Container()), isFalse);
      expect(PrivateViewsManager.isPrivateWidget(const Text('Hello')), isFalse);
    });

    testWidgets('getRectsOfPrivateViews detects masked views', (tester) async {
      await tester.pumpWidget(
        const InstabugWidget(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SizedBox(width: 100, height: 100),
                  InstabugPrivateView(child: TextField()),
                ],
              ),
            ),
          ),
        ),
      );

      final rects = manager.getRectsOfPrivateViews();
      expect(rects.length, 1);
    });

    testWidgets('getRectsOfPrivateViews detects masked labels', (tester) async {
      await tester.pumpWidget(
        const InstabugWidget(
          automasking: [AutoMasking.labels],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SizedBox(width: 100, height: 100),
                  Text("Test 1"),
                  Text("Test 2"),
                ],
              ),
            ),
          ),
        ),
      );

      final rects = manager.getRectsOfPrivateViews();
      expect(rects.length, 2);
    });

    testWidgets(
        'getPrivateViews returns correct list of masked view coordinates',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Column(
              children: [
                InstabugPrivateView(
                  child: SizedBox(width: 50, height: 50),
                ),
              ],
            ),
          ),
        ),
      );

      final privateViews = manager.getPrivateViews();
      expect(privateViews.length % 4,
          0,); // Ensure coordinates come in sets of four
    });

    testWidgets('getRectsOfPrivateViews detects masked Media', (tester) async {
      final fakeImage = Uint8List.fromList([
        0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG header
        0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
        0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01, // 1x1 size
        0x08, 0x06, 0x00, 0x00, 0x00, 0x1F, 0x15, 0xC4, // More PNG data
        0x89, 0x00, 0x00, 0x00, 0x0A, 0x49, 0x44, 0x41,
        0x54, 0x78, 0xDA, 0x63, 0x00, 0x01, 0x00, 0x00,
        0x05, 0x00, 0x01, 0x0D, 0x0A, 0x2D, 0xB4, 0x00,
        0x00, 0x00, 0x00, 0x49, 0x45, 0x4E, 0x44, 0xAE,
      ]);
      await tester.pumpWidget(
        InstabugWidget(
          automasking: const [AutoMasking.media],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  const SizedBox(width: 100, height: 100),
                  Image.memory(
                    fakeImage,
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final rects = manager.getRectsOfPrivateViews();
      expect(rects.length, 1);
    });

    testWidgets('getRectsOfPrivateViews detects masked textInputs',
        (tester) async {
      await tester.pumpWidget(
        const InstabugWidget(
          automasking: [AutoMasking.textInputs],
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  SizedBox(width: 100, height: 100),
                  TextField(),
                ],
              ),
            ),
          ),
        ),
      );

      final rects = manager.getRectsOfPrivateViews();
      expect(rects.length, 1);
    });
  });
}
