part of '../../main.dart';

class ApmPage extends StatefulWidget {
  static const screenName = 'apm';

  const ApmPage({Key? key}) : super(key: key);

  @override
  State<ApmPage> createState() => _ApmPageState();
}

class _ApmPageState extends State<ApmPage> {
  @override
  Widget build(BuildContext context) {
    return Page(
      title: 'APM',
      children: [
        const SectionTitle('Network'),
        const NetworkContent(),
        const SectionTitle('Traces'),
        const TracesContent(),
        const SectionTitle('Flows'),
        const FlowsContent(),
        const SectionTitle('Screen Loading'),
        SizedBox.fromSize(
          size: const Size.fromHeight(12),
        ),
      ],
    );
  }
}
