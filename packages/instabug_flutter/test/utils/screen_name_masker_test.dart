import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:instabug_flutter/src/utils/screen_name_masker.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    ScreenNameMasker.I.setMaskingCallback(null);
  });

  test('[mask] should return same screen name when no masking callback is set',
      () {
    const screen = 'home';

    final result = ScreenNameMasker.I.mask(screen);

    expect(result, equals(screen));
  });

  test(
      '[mask] should mask screen name when [setMaskingCallback] has set a callback',
      () {
    const screen = '/documents/314159265';
    const masked = '/documents/REDACTED';

    ScreenNameMasker.I.setMaskingCallback((screen) {
      if (screen.startsWith('/documents/')) {
        return masked;
      }

      return screen;
    });

    final result = ScreenNameMasker.I.mask(screen);

    expect(result, equals(masked));
  });

  test('[mask] should fallback to "N/A" when callback returns an empty string',
      () {
    const fallback = 'N/A';
    const screen = '/documents/314159265';
    const masked = '';

    ScreenNameMasker.I.setMaskingCallback((screen) {
      if (screen.startsWith('/documents/')) {
        return masked;
      }

      return screen;
    });

    final result = ScreenNameMasker.I.mask(screen);

    expect(result, equals(fallback));
  });

  test('[mask] should trim masked screen name', () {
    const screen = '/documents/314159265';
    const masked = '  /documents/REDACTED   ';
    const expected = '/documents/REDACTED';

    ScreenNameMasker.I.setMaskingCallback((screen) {
      if (screen.startsWith('/documents/')) {
        return masked;
      }

      return screen;
    });

    final result = ScreenNameMasker.I.mask(screen);

    expect(result, equals(expected));
  });
}
