# Instabug for Flutter

[![pub package](https://img.shields.io/pub/v/instabug_flutter.svg)](https://pub.dev/packages/instabug_flutter)

A Flutter plugin for [Instabug](https://instabug.com/).

## Available Features

|      Feature                                              | Status  |
|:---------------------------------------------------------:|:-------:|
| [Bug Reporting](https://instabug.com/bug-reporting)       |    ✅   |
| [Crash Reporting](https://instabug.com/crash-reporting)   |    ✅    |
| [In-App Chat](https://instabug.com/in-app-chat)           |    ✅   |
| [In-App Surveys](https://instabug.com/in-app-surveys)     |    ✅   |
| [Feature Requests](https://instabug.com/feature-requests) |    ✅   |

* ✅ Stable
* ⚙️ Under active development

## Integration

### Installation


1. Add Instabug to your `pubspec.yaml` file.

```yaml
dependencies:
      instabug_flutter:
        git:
          url: https://github.com/Instabug/instabug-flutter.git
          ref: crash-reporting
```

2. Install the package by running the following command.

```bash
flutter packages get
```

### Using Instabug

1. To start using Instabug, import it into your Flutter app. 

```dart
import 'package:instabug_flutter/Instabug.dart';
```

2. Initialize the SDK in `initState()`. This line enables the SDK with the default behavior and sets it to be shown when the device is shaken. Ignore this if you're building for Android only.

```dart
Instabug.start('APP_TOKEN', [InvocationEvent.shake]);
```

3. Add the following Maven repository to your project level `build.gradle`

```dart
allprojects {
	repositories {
	    maven {
	        url "https://sdks.instabug.com/nexus/repository/instabug-cp"
	    }
	}
}
```

Make sure to replace `app_token` with your application token.

4. If your app supports Android, create a new Java class that extends `FlutterApplication` and add it to your `AndroidManifest.xml`.

```xml
<application
    android:name=".CustomFlutterApplication"
    ...
</application>
````

5. In your newly created `CustomFlutterApplication` class, override `onCreate()` and add the following code.

```java
ArrayList<String> invocationEvents = new ArrayList<>();
invocationEvents.add(InstabugFlutterPlugin.INVOCATION_EVENT_SHAKE);
new InstabugFlutterPlugin().start(CustomFlutterApplication.this, "APP_TOKEN", invocationEvents);
```

## Crash reporting

Instabug automatically captures every crash of your app and sends relevant details to the crashes page of your dashboard. Crashes are reported only when the app is running in release mode

1. To start using Crash reporting, import the following into your `main.dart`. 

```dart
import 'package:instabug_flutter/CrashReporting.dart';
```

2. Replace `void main() => runApp(MyApp());` with the following snippet:
```dart
void main() async {
  FlutterError.onError = (FlutterErrorDetails details) {
    Zone.current.handleUncaughtError(details.exception, details.stack);
  };
  runZoned<Future<void>>(() async {
    runApp(MyApp());
  }, onError: (dynamic error, StackTrace stackTrace) {
    CrashReporting.reportCrash(error, stackTrace);
  });
}
```

## Network Logging
You can choose to attach all your network requests to the reports being sent to the dashboard. To enable the feature when using the `dart:io` package `HttpClient`, use the custom Instabug client:
```
InstabugCustomHttpClient client = InstabugCustomHttpClient();
```

and continue to use the package normally to make your network requests:

```
client.getUrl(Uri.parse(URL)).then((request) async {
      var response = await request.close();
});
```

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
