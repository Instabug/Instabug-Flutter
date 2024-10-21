part of '../modules.dart';

class ThirdModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute('/', child: (_, args) => const ThirdModuleHomePage()),
  ];
}

class Counter {
  int _number = 0;

  int get number => _number;

  void increment() => _number++;

  void decrement() => _number--;
}
