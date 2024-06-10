part of '../../main.dart';

class NonFatalCrashesContent extends StatelessWidget {
  const NonFatalCrashesContent({Key? key}) : super(key: key);

  void throwHandledException(dynamic error) {
    try {
      if (error is! Error) {
        const appName = 'Flutter Test App';
        final errorMessage = error?.toString() ?? 'Unknown Error';
        error = Exception('Handled Error: $errorMessage from $appName');
      }
      throw error;
    } catch (err) {
      if (err is Error) {
        log('throwHandledException: Crash report for ${err.runtimeType} is Sent!',
            name: 'NonFatalCrashesWidget');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InstabugButton(
          text: 'Throw Exception',
          onPressed: () =>
              throwHandledException(Exception('This is a generic exception.')),
        ),
        InstabugButton(
          text: 'Throw StateError',
          onPressed: () =>
              throwHandledException(StateError('This is a StateError.')),
        ),
        InstabugButton(
          text: 'Throw ArgumentError',
          onPressed: () =>
              throwHandledException(ArgumentError('This is an ArgumentError.')),
        ),
        InstabugButton(
          text: 'Throw RangeError',
          onPressed: () => throwHandledException(
              RangeError.range(5, 0, 3, 'Index out of range')),
        ),
        InstabugButton(
          text: 'Throw FormatException',
          onPressed: () =>
              throwHandledException(UnsupportedError('Invalid format.')),
        ),
        InstabugButton(
          text: 'Throw NoSuchMethodError',
          onPressed: () {
            dynamic obj;
            throwHandledException(obj.methodThatDoesNotExist());
          },
        ),
        const InstabugButton(
          text: 'Throw Handled Native Exception',
          onPressed:
          InstabugFlutterExampleMethodChannel.sendNativeNonFatalCrash,
        ),
      ],
    );
  }
}