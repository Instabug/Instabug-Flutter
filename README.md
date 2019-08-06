# Instabug for Flutter

[![pub package](https://img.shields.io/pub/v/instabug_flutter.svg)](https://pub.dev/packages/instabug_flutter)

A Flutter plugin for [Instabug](https://instabug.com/).

⚠️ While this plugin is currently in beta, it's safe to start using it and ship apps with it to production. If you'd like to give us [feedback](https://github.com/Instabug/Instabug-Flutter/issues) or create a [pull request](https://github.com/Instabug/Instabug-Flutter/pulls), we would highly appreciate it!

## Available Features

|      Feature                                              | Status  |
|:---------------------------------------------------------:|:-------:|
| [Bug Reporting](https://instabug.com/bug-reporting)       |    ✅   |
| [Crash Reporting](https://instabug.com/crash-reporting)   |    ⚠    |
| [In-App Chat](https://instabug.com/in-app-chat)           |    ✅   |
| [In-App Surveys](https://instabug.com/in-app-surveys)     |    ✅   |
| [Feature Requests](https://instabug.com/feature-requests) |    ✅   |

* ✅ Stable
* ⚙️ Under active development
* ⚠ Not available yet

## Integration

Creating a Flutter app on the Instabug dashboard isn't possible yet. Create a React Native app instead.


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

### Using Instabug

1. To start using Instabug, import it into your Flutter app. 

```dart
import 'package:instabug_flutter/Instabug.dart';
```

2. Initialize the SDK in `initState()`. This line enables the SDK with the default behavior and sets it to be shown when the device is shaken.

```dart
Instabug.start('APP_TOKEN', [InvocationEvent.shake]);
```
Make sure to replace `app_APP_TOKEN` with your application token.

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




## Microphone and Photo Library Usage Description (iOS Only)

Instabug needs access to the microphone and photo library to be able to let users add audio and video attachments. Starting from iOS 10, apps that don’t provide a usage description for those 2 permissions would be rejected when submitted to the App Store.

For your app not to be rejected, you’ll need to add the following 2 keys to your app’s info.plist file with text explaining to the user why those permissions are needed:

* `NSMicrophoneUsageDescription`
* `NSPhotoLibraryUsageDescription`

If your app doesn’t already access the microphone or photo library, we recommend using a usage description like:

* "`<app name>` needs access to the microphone to be able to attach voice notes."
* "`<app name>` needs access to your photo library for you to be able to attach images."

**The permission alert for accessing the microphone/photo library will NOT appear unless users attempt to attach a voice note/photo while using Instabug.**

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
