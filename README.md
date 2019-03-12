# Instabug for Flutter

A Flutter plugin for [Instabug](https://instabug.com/).

⚠️ This plugin is currently under active development and is not ready for production use yet. If you'd like to give us [feedback](https://github.com/Instabug/Instabug-Flutter/issues) or create a [pull request](https://github.com/Instabug/Instabug-Flutter/pulls), we would highly appreciate it!

## Available Features

|      Feature     | Status |
|:----------------:|:------:|
| [Bug Reporting](https://instabug.com/bug-reporting)    |    ⚙️   |
| [Crash Reporting](https://instabug.com/crash-reporting)  |    ❌   |
| [In-App Chat](https://instabug.com/in-app-chat)      |    ❌   |
| [In-App Surveys](https://instabug.com/in-app-surveys)   |    ❌   |
| [Feature Requests](https://instabug.com/feature-requests) |    ❌   |

* ✅ Stable
* ⚙️ Under active development
* ❌ Not available yet

### APIs

The table below contains a list of APIs we're planning to implement for our 1.0 release. We'll add the Dart API methods as we implement them.



| API Method | Native Equivalent (Android/iOS)                                                                                                                       |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `start(String token, List<InvocationEvent> invocationEvents)` | `new Instabug.Builder(this, "APP_TOKEN").build()`<br>`+ [Instabug startWithToken:invocationEvents:]`                         |
|`showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode)`| `Instabug.showWelcomeMessage(WelcomeMessage.State state)`<br>`+ [Instabug showWelcomeMessageWithMode:]`                      |
|`identifyUserWithEmail(String email, [String name])`| `Instabug.identifyUser(String username, String email)`<br>`+ [Instabug identifyUserWithEmail:name:]`                         |
|`logOut()`| `Instabug.logoutUser()`<br>`+ [Instabug logOut]`                                                                             |
|`setLocale(Locale locale)`| `Instabug.setLocale(Locale locale)`<br>`+ [Instabug setLocale:]`                                                             |
|`InstabugFlutter.setColorTheme(ColorTheme colorTheme)`|  `Instabug.setColorTheme(InstabugColorTheme theme)`<br>`+ [Instabug setColorTheme:]`                                         |
|`InstabugFlutter.appendTags(List<String> tags)`| `Instabug.addTags(String... tags)`<br>`+ [Instabug appendTags:]`                                                             |
|`InstabugFlutter.resetTags()`| `Instabug.resetTags()`<br>`+ [Instabug resetTags]`                                                                           |
|`InstabugFlutter.getTags()`| `Instabug.getTags()`<br>`+ [Instabug getTags]`                                                                               |
|            | `Instabug.setCustomTextPlaceHolders(InstabugCustomTextPlaceHolder placeholder)`<br>`+ [Instabug setValue:forStringWithKey:]` |
|            | `Instabug.setUserAttribute(String key, String value)`<br>`+ [Instabug setUserAttribute:withKey:]`                            |
|            | `Instabug.getUserAttribute(String key)`<br>`+ [Instabug userAttributeForKey:]`                                               |
|InstabugFlutter.removeUserAttributeForKey(String key)| `Instabug.removeUserAttribute(String key)`<br>`+ [Instabug removeUserAttributeForKey:]`                                      |
|            | `Instabug.getAllUserAttributes()`<br>`+ [Instabug userAttributes:]`                                                          |
|            | `Instabug.logUserEvent(String name)`<br>`+ [Instabug logUserEventWithName:]`                                                 |
|            | `BugReporting.invoke()`<br>`+ [IBGBugReporting invoke]`                                                                      |
|            | `BugReporting.invoke(InvocationMode mode, @InvocationOption int... options)`<br>`+ [IBGBugReporting invokeWithMode:options:]`  |
|`logDebug(String message)`| `InstabugLog.d(String message)`<br>`+ [IBGLog logDebug:]`                                                                    |
|`logVerbose(String message)`| `InstabugLog.v(String message)`<br>`+ [IBGLog logVerbose:]`                                                                  |
|`logInfo(String message)`| `InstabugLog.i(String message)`<br>`+ [IBGLog logInfo:]`                                                                     |
|`logWarn(String message)`| `InstabugLog.w(String message)`<br>`+ [IBGLog logWarn:]`                                                                     |
|`logError(String message)`| `InstabugLog.e(String message)`<br>`+ [IBGLog logError:]`                                                                    |
|`clearAllLogs(String message)`| `Instabug.clearLogs()`<br>`+ [IBGLog clearAllLogs:]`                                                                         |

## Integration

Creating a Flutter app on the Instabug dashboard isn't possible yet. Create a React Native app instead.


### Installation


1. Add Instabug to your `pubspec.yaml` file.

```yaml
instabug_flutter: ^0.0.1-alpha.1
```

2. Get the newly added dependency.

```bash
pub get
```

### Using Instabug

1. To start using Instabug, import it into your Flutter app. 

```dart
import 'package:instabug_flutter/instabug_flutter.dart';
```

2. Initialize the SDK in `initState()`. This line enables the SDK with the default behavior and sets it to be shown when the devices is shaken.

```dart
InstabugFlutter.start('APP_TOKEN', [InvocationEvent.shake]);
```

Make sure to replace `app_token` with your application token.

3. If your app supports Android, create a new Java class that extends `FlutterApplication` and add it to your `AndroidManifest.xml`.

```xml
<application
    android:name=".CustomFlutterApplication"
    ...
</application>
````

4. In your newly created `CustomFlutterApplication` class, override `onCreate()` and add the following code.

```java
ArrayList<String> invocationEvents = new ArrayList<>();
invocationEvents.add(InstabugFlutterPlugin.INVOCATION_EVENT_SHAKE);
new InstabugFlutterPlugin().start(CustomFlutterApplication.this, "APP_TOKEN", invocationEvents);
```

5. For iOS apps, Instabug needs access to the microphone and photo library to be able to let users add audio and video attachments. Add the following 2 keys to your app’s `Info.plist` file with text explaining to the user why those permissions are needed:

* `NSMicrophoneUsageDescription`
* `NSPhotoLibraryUsageDescription`

If your app doesn’t already access the microphone or photo library, we recommend using a usage description like:

* "`<app name>` needs access to the microphone to be able to attach voice notes."
* "`<app name>` needs access to your photo library for you to be able to attach images."

**The permission alert for accessing the microphone/photo library will NOT appear unless users attempt to attach a voice note/photo while using Instabug.**
