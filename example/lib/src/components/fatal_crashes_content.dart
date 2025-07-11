part of '../../main.dart';

class FatalCrashesContent extends StatelessWidget {
  const FatalCrashesContent({Key? key}) : super(key: key);

  void throwUnhandledException(dynamic error) {
    if (error is! Error) {
      const appName = 'Flutter Test App';
      final errorMessage = error?.toString() ?? 'Unknown Error';
      error = Exception('Unhandled Error: $errorMessage from $appName');
    }
    throw error;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InstabugButton(
          text: 'Throw Exception',
          key: const Key('fatal_crash_exception'),
          onPressed: () => throwUnhandledException(
              Exception('This is a generic exception.')),
        ),
        InstabugButton(
          text: 'Throw StateError',
          key: const Key('fatal_crash_state_exception'),
          onPressed: () =>
              throwUnhandledException(StateError('This is a StateError.')),
        ),
        InstabugButton(
          text: 'Throw ArgumentError',
          key: const Key('fatal_crash_argument_exception'),
          onPressed: () => throwUnhandledException(
              ArgumentError('This is an ArgumentError.')),
        ),
        InstabugButton(
          text: 'Throw RangeError',
          key: const Key('fatal_crash_range_exception'),
          onPressed: () => throwUnhandledException(
              RangeError.range(5, 0, 3, 'Index out of range')),
        ),
        InstabugButton(
          text: 'Throw FormatException',
          key: const Key('fatal_crash_format_exception'),
          onPressed: () =>
              throwUnhandledException(UnsupportedError('Invalid format.')),
        ),
        InstabugButton(
          text: 'Throw NoSuchMethodError',
          key: const Key('fatal_crash_no_such_method_error_exception'),
          onPressed: () {
            // This intentionally triggers a NoSuchMethodError
            dynamic obj;
            throwUnhandledException(obj.methodThatDoesNotExist());
          },
        ),
        const InstabugButton(
          text: 'Throw Native Fatal Crash',
          key: const Key('fatal_crash_native_exception'),
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeFatalCrash,
        ),
        const InstabugButton(
          text: 'Send Native Fatal Hang',
          key: const Key('fatal_crash_native_hang'),
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeFatalHang,
        ),
        Platform.isAndroid
            ? const InstabugButton(
                text: 'Send Native ANR',
                key: const Key('fatal_crash_anr'),
                onPressed: InstabugFlutterExampleMethodChannel.sendAnr,
              )
            : const SizedBox.shrink(),
        const InstabugButton(
          text: 'Throw Unhandled Native OOM Exception',
          key: const Key('fatal_crash_oom'),
          onPressed: InstabugFlutterExampleMethodChannel.sendOom,
        ),
      ],
    );
  }
}
