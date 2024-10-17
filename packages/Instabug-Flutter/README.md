# Instabug for Flutter

[![pub package](https://img.shields.io/pub/v/instabug_flutter.svg)](https://pub.dev/packages/instabug_flutter)

A Flutter plugin for [Instabug](https://instabug.com/).

## Available Features

|      Feature                                              | Status  |
|:---------------------------------------------------------:|:-------:|
| [Bug Reporting](https://docs.instabug.com/docs/flutter-bug-reporting)               |    ✅   |
| [Crash Reporting](https://docs.instabug.com/docs/flutter-crash-reporting)           |    ✅   |
| [App Performance Monitoring](https://docs.instabug.com/docs/flutter-apm)            |    ✅   |
| [In-App Replies](https://docs.instabug.com/docs/flutter-in-app-replies)             |    ✅   |
| [In-App Surveys](https://docs.instabug.com/docs/flutter-in-app-surveys)             |    ✅   |
| [Feature Requests](https://docs.instabug.com/docs/flutter-in-app-feature-requests)  |    ✅   |

* ✅ Stable
* ⚙️ Under active development

## Integration

### Installation

1. Add Instabug to your `pubspec.yaml` file.

```yaml
dependencies:
      instabug_flutter:
```

2. Install the package by running the following command.

```bash
flutter packages get
```

### Initializing Instabug

Initialize the SDK in your `main` function. This starts the SDK with the default behavior and sets it to be shown when the device is shaken.

```dart
import 'package:instabug_flutter/instabug_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Instabug.init(
    token: 'APP_TOKEN',
    invocationEvents: [InvocationEvent.shake],
  );

  runApp(MyApp());
}
```

> :warning:  If you're updating the SDK from versions prior to v11, please check our [migration guide](https://docs.instabug.com/docs/flutter-migration-guide).

## Crash reporting

Instabug automatically captures every crash of your app and sends relevant details to the crashes page of your dashboard. 

⚠️ **Crashes will only be reported in release mode and not in debug mode.**

```dart
void main() {
  runZonedGuarded(
    () {
      WidgetsFlutterBinding.ensureInitialized();

      Instabug.init(
        token: 'APP_TOKEN',
        invocationEvents: [InvocationEvent.shake],
      );

      FlutterError.onError = (FlutterErrorDetails details) {
        Zone.current.handleUncaughtError(details.exception, details.stack!);
      };

      runApp(MyApp());
    },
    CrashReporting.reportCrash,
  );
}
```

## Repro Steps
Repro Steps list all of the actions an app user took before reporting a bug or crash, grouped by the screens they visited in your app.
 
 To enable this feature, you need to add `InstabugNavigatorObserver` to the `navigatorObservers` :
 ```
  runApp(MaterialApp(
    navigatorObservers: [InstabugNavigatorObserver()],
  ));
  ```

## Network Logging
You can choose to attach all your network requests to the reports being sent to the dashboard. To enable the feature when using the `dart:io` package `HttpClient`, please refer to the [Instabug Dart IO Http Client](https://github.com/Instabug/instabug-dart-io-http-client) repository.

We also support the packages `http` and `dio`. For details on how to enable network logging for these external packages, refer to the [Instabug Dart Http Adapter](https://github.com/Instabug/Instabug-Dart-http-Adapter) and the [Instabug Dio Interceptor](https://github.com/Instabug/Instabug-Dio-Interceptor) repositories.

## Microphone and Photo Library Usage Description (iOS Only)

Instabug needs access to the microphone and photo library to be able to let users add audio and video attachments. Starting from iOS 10, apps that don’t provide a usage description for those 2 permissions would be rejected when submitted to the App Store.

For your app not to be rejected, you’ll need to add the following 2 keys to your app’s info.plist file with text explaining to the user why those permissions are needed:

* `NSMicrophoneUsageDescription`
* `NSPhotoLibraryUsageDescription`

If your app doesn’t already access the microphone or photo library, we recommend using a usage description like:

* "`<app name>` needs access to the microphone to be able to attach voice notes."
* "`<app name>` needs access to your photo library for you to be able to attach images."

**The permission alert for accessing the microphone/photo library will NOT appear unless users attempt to attach a voice note/photo while using Instabug.**
