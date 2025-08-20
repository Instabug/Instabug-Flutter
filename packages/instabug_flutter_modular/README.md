# Instabug Flutter Modular

[![Pub](https://img.shields.io/pub/v/instabug_flutter_modular.svg)](https://pub.dev/packages/instabug_flutter_modular)
[![Twitter](https://img.shields.io/badge/twitter-@Instabug-blue.svg)](https://twitter.com/Instabug)

An add-on for the [Instabug Flutter SDK](https://github.com/Instabug/Instabug-Flutter) that provides screen loading support for [Flutter Modular](https://pub.dev/packages/flutter_modular) v5.

## Installation

1. Add `instabug_flutter_modular` to your `pubspec.yaml` file.

```yaml
dependencies:
  instabug_flutter_modular:
```

2. Install the package by running the following command.

```sh
flutter pub get
```

## Usage

1. Wrap your `AppParentModule` inside `InstabugModule`:


```dart

void main() {
  //...
  
  runApp(
    ModularApp(
      module: InstabugModule(AppModule()),
      child: const MyApp(),
    ),
  );
}
```

2. Add `InstabugNavigatorObserver` to your navigation observers list:

```dart
@override
Widget build(BuildContext context) {
  return MaterialApp.router(
    routeInformationParser: Modular.routeInformationParser,
    routerDelegate: Modular.routerDelegate
      ..setObservers([InstabugNavigatorObserver()]),

    // ...
  );
}
```