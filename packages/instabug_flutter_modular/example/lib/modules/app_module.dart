part of '../modules.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [Bind.singleton((i) => Counter())];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const HomePage()),
    ChildRoute('/simplePage', child: (_, args) => const SimplePage()),
    ChildRoute('/complexPage', child: (_, args) => const ComplexPage()),
    ChildRoute('/bindsPage', child: (_, args) => const ThirdModuleHomePage()),
    WildcardRoute(
      child: (p0, p1) => const NotFoundPage(),
    ),
    RedirectRoute('/redirect', to: '/simplePage?name=redirected'),
    ModuleRoute('/secondModule', module: SecondModule()),
    ModuleRoute('/thirdModule', module: ThirdModule()),
  ];
}
