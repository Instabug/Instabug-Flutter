# instabug_private_views

An add-on for the Instabug Flutter SDK that provides private views support in screen.

[![Twitter](https://img.shields.io/badge/twitter-@Instabug-blue.svg)](https://twitter.com/Instabug)

An add-on for the [Instabug Flutter SDK](https://github.com/Instabug/Instabug-Flutter) hat provides private views support in screenshot capturing [Flutter Private views](https://pub.dev/packages/).

## Installation

1. Add `instabug_private_views` to your `pubspec.yaml` file.

```yaml
dependencies:
  instabug_private_views:
```

2. Install the package by running the following command.

```sh
flutter pub get
```

## Usage

1. enable `PrivateViews` after `init` the SDK:


```dart

void main() {
  
  Instabug.init(
    token: 'App token',
    invocationEvents: [InvocationEvent.floatingButton],
  );

  ReproSteps.enablePrivateViews();
  
  runApp(MyApp());
  
}
```

2. Wrap  the view you want to mask with `InstabugPrivateView`:

```dart
 InstabugPrivateView(
child: const Text(
'Private TextView',
style: TextStyle(fontSize: 18),
textAlign: TextAlign.center,
),
),
```

you can use `InstabugSliverPrivateView` if you want to wrap Sliver widget 
```dart
  InstabugSliverPrivateView(
sliver: SliverToBoxAdapter(
child: /// child
)),
```