part of '../../main.dart';

class CrashesPage extends StatelessWidget {
  static const screenName = 'crashes';

  const CrashesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Page(
      title: 'Crashes',
      children: [
        SectionTitle('Non-Fatal Crashes'),
        NonFatalCrashesContent(),
        SectionTitle('Fatal Crashes'),
        Text('Fatal Crashes can only be tested in release mode'),
        Text('Most of these buttons will crash the application'),
        FatalCrashesContent(),
        SectionTitle('NDK Crashes'),
        Text(
            'NDK crashes are native C/C++ crashes that occur in Android applications.'),
        Text(
            'These crashes can only be tested on Android devices with NDK support.',
            style: TextStyle(color: Colors.orange)),
        NdkCrashesContent(),
        SectionTitle('Crash section'),
      ], // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
