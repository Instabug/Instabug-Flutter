import 'package:flutter_modular/flutter_modular.dart';
import 'package:instabug_flutter_modular/src/instabug_modular_manager.dart';

class InstabugModule extends Module {
  final Module module;
  final String path;
  final List<ModularRoute> _routes;

  InstabugModule(this.module, {this.path = '/'})
      : _routes = InstabugModularManager.I.wrapRoutes(
          module.routes,
          parent: path,
        );

  @override
  List<Module> get imports => module.imports;

  @override
  List<Bind> get binds => module.binds;

  @override
  List<ModularRoute> get routes => _routes;

  // Override the runtime type to return the module's runtime type as Flutter
  // Modular maps context bindings by their runtime type.
  @override
  Type get runtimeType => module.runtimeType;
}
