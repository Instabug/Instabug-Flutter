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
          onPressed: () => throwUnhandledException(
              Exception('This is a generic exception.')),
        ),
        InstabugButton(
          text: 'Throw StateError',
          onPressed: () =>
              throwUnhandledException(StateError('This is a StateError.')),
        ),
        InstabugButton(
          text: 'Throw ArgumentError',
          onPressed: () => throwUnhandledException(
              ArgumentError('This is an ArgumentError.')),
        ),
        InstabugButton(
          text: 'Throw RangeError',
          onPressed: () => throwUnhandledException(
              RangeError.range(5, 0, 3, 'Index out of range')),
        ),
        InstabugButton(
          text: 'Throw FormatException',
          onPressed: () =>
              throwUnhandledException(UnsupportedError('Invalid format.')),
        ),
        InstabugButton(
          text: 'Throw NoSuchMethodError',
          onPressed: () {
            // This intentionally triggers a NoSuchMethodError
            dynamic obj;
            throwUnhandledException(obj.methodThatDoesNotExist());
          },
        ),
        const InstabugButton(
          text: 'Throw Native Fatal Crash',
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeFatalCrash,
        ),
        const InstabugButton(
          text: 'Send Native Fatal Hang',
          onPressed: InstabugFlutterExampleMethodChannel.sendNativeFatalHang,
        ),
        Platform.isAndroid
            ? const InstabugButton(
                text: 'Send Native ANR',
                onPressed: InstabugFlutterExampleMethodChannel.sendAnr,
              )
            : const SizedBox.shrink(),
        const InstabugButton(
          text: 'Throw Unhandled Native OOM Exception',
          onPressed: InstabugFlutterExampleMethodChannel.sendOom,
        ),
      ],
    );
  }
}
