part of '../screens.dart';

class ThirdModuleHomePage extends StatefulWidget {
  const ThirdModuleHomePage({super.key});

  @override
  State<ThirdModuleHomePage> createState() => _ThirdModuleHomePageState();
}

class _ThirdModuleHomePageState extends State<ThirdModuleHomePage> {
  final counter = Modular.get<Counter>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third Module (Binds)')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () => setState(() => counter.increment()),
                    icon: const Icon(Icons.add_circle_outline_rounded)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Counter: ${counter.number}",
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                    onPressed: () => setState(() => counter.decrement()),
                    icon: const Icon(Icons.remove_circle_outline_rounded)),
              ],
            ),
            CustomButton(
              onPressed: () => Modular.to.navigate('/'),
              title: 'Back To Home',
            ),
          ],
        ),
      ),
    );
  }
}
