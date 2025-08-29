part of '../modules.dart';

class SecondModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  List<ModularRoute> get routes => [
        ChildRoute(
          '/',
          child: (context, args) => const SecondModuleHomePage(),
          children: [
            ChildRoute(
              '/page1',
              child: (context, args) =>
                  const InternalPage(title: 'page 1', color: Colors.red),
            ),
            ChildRoute(
              '/page2',
              child: (context, args) =>
                  const InternalPage(title: 'page 2', color: Colors.amber),
            ),
            ChildRoute(
              '/page3',
              child: (context, args) =>
                  const InternalPage(title: 'page 3', color: Colors.green),
            ),
          ],
        ),
      ];
}
