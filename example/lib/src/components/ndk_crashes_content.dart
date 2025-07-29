part of '../../main.dart';

class NdkCrashesContent extends StatelessWidget {
  const NdkCrashesContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Platform.isAndroid
            ? const Column(
                children: [
                  InstabugButton(
                    text: 'Trigger NDK Crash',
                    onPressed: InstabugFlutterExampleMethodChannel.causeNdkCrash,
                  ),
                  InstabugButton(
                    text: 'Trigger NDK SIGSEGV Crash',
                    onPressed:
                        InstabugFlutterExampleMethodChannel.causeNdkSigsegv,
                  ),
                  InstabugButton(
                    text: 'Trigger NDK SIGABRT Crash',
                    onPressed:
                        InstabugFlutterExampleMethodChannel.causeNdkSigabrt,
                  ),
                  InstabugButton(
                    text: 'Trigger NDK SIGFPE Crash',
                    onPressed:
                        InstabugFlutterExampleMethodChannel.causeNdkSigfpe,
                  ),
                  InstabugButton(
                    text: 'Trigger NDK SIGILL Crash',
                    onPressed:
                        InstabugFlutterExampleMethodChannel.causeNdkSigill,
                  ),
                  InstabugButton(
                    text: 'Trigger NDK SIGBUS Crash',
                    onPressed:
                        InstabugFlutterExampleMethodChannel.causeNdkSigbus,
                  ),
                  InstabugButton(
                    text: 'Trigger NDK SIGTRAP Crash',
                    onPressed:
                        InstabugFlutterExampleMethodChannel.causeNdkSigtrap,
                  ),
                ],
              )
            : const Text(
                'NDK crashes are only available on Android',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
      ],
    );
  }
}
