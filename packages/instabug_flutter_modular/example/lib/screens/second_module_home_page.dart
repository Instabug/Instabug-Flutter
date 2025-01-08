part of '../screens.dart';

class SecondModuleHomePage extends StatelessWidget {
  const SecondModuleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final leading = SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: NavigationListener(
        builder: (context, child) => Column(
          children: [
            ListTile(
              title: const Text('Page 1'),
              onTap: () => Modular.to.navigate('/secondModule/page1'),
              selected: Modular.to.path.endsWith('/secondModule/page1'),
            ),
            ListTile(
              title: const Text('Page 2'),
              onTap: () => Modular.to.navigate('/secondModule/page2'),
              selected: Modular.to.path.endsWith('/secondModule/page2'),
            ),
            ListTile(
              title: const Text('Page 3'),
              onTap: () => Modular.to.navigate('/secondModule/page3'),
              selected: Modular.to.path.endsWith('/secondModule/page3'),
            ),
            const Spacer(),
            ListTile(
              title: const Text('Back To Home'),
              onTap: () => Modular.to.navigate('/'),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Second Module (Nested Routes)')),
      body: SafeArea(
        child: Row(
          children: [
            leading,
            Container(width: 1, color: Colors.black26),
            const Expanded(child: RouterOutlet()),
          ],
        ),
      ),
    );
  }
}

class InternalPage extends StatelessWidget {
  final String title;
  final Color color;

  const InternalPage({super.key, required this.title, required this.color});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      child: Center(child: Text(title)),
    );
  }
}
