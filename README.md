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
* ❌ Unavailable

### APIs

The table below contains a list of APIs we're planning to implement for our 1.0 release. We'll add the Dart API methods as we implement them.



| API Method | Native Equivalent (Android/iOS)                                                                                                                       |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| `start(String token, List<InvocationEvent> invocationEvents)` | `new Instabug.Builder(this, "APP_TOKEN").build()`<br>`+ [Instabug startWithToken:invocationEvents:]`                         |
|`showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode)`| `Instabug.showWelcomeMessage(WelcomeMessage.State state)`<br>`+ [Instabug showWelcomeMessageWithMode:]`                      |
|`identifyUserWithEmail(String email, [String name])`| `Instabug.identifyUser(String username, String email)`<br>`+ [Instabug identifyUserWithEmail:name:]`                         |
|`logOut()`| `Instabug.logoutUser()`<br>`+ [Instabug logOut]`                                                                             |
|`setLocale(Locale locale)`| `Instabug.setLocale(Locale locale)`<br>`+ [Instabug setLocale:]`                                                             |
|            |  `Instabug.setColorTheme(InstabugColorTheme theme)`<br>`+ [Instabug setColorTheme:]`                                         |
|            | `Instabug.addTags(String... tags)`<br>`+ [Instabug appendTags:]`                                                             |
|            | `Instabug.resetTags()`<br>`+ [Instabug resetTags]`                                                                           |
|            | `Instabug.getTags()`<br>`+ [Instabug getTags]`                                                                               |
|            | `Instabug.setCustomTextPlaceHolders(InstabugCustomTextPlaceHolder placeholder)`<br>`+ [Instabug setValue:forStringWithKey:]` |
|            | `Instabug.setUserAttribute(String key, String value)`<br>`+ [Instabug setUserAttribute:withKey:]`                            |
|            | `Instabug.getUserAttribute(String key)`<br>`+ [Instabug userAttributeForKey:]`                                               |
|            | `Instabug.removeUserAttribute(String key)`<br>`+ [Instabug removeUserAttributeForKey:]`                                      |
|            | `Instabug.getAllUserAttributes()`<br>`+ [Instabug userAttributes:]`                                                          |
|            | `Instabug.logUserEvent(String name)`<br>`+ [Instabug logUserEventWithName:]`                                                 |
|            | `BugReporting.invoke()`<br>`+ [IBGBugReporting invoke]`                                                                      |
|            | `BugReporting.invoke(InvocationMode mode, @InvocationOption int... options)`<br>`+ [IBGBugReporting invokeWithMode:options:]`  |
|            | `InstabugLog.d(String message)`<br>`+ [IBGLog log:]`                                                                         |
|            | `InstabugLog.v(String message)`<br>`+ [IBGLog logVerbose:]`                                                                  |
|            | `InstabugLog.d(String message)`<br>`+ [IBGLog logDebug:]`                                                                    |
|            | `InstabugLog.i(String message)`<br>`+ [IBGLog logInfo:]`                                                                     |
|            | `InstabugLog.w(String message)`<br>`+ [IBGLog logWarn:]`                                                                     |
|            | `InstabugLog.e(String message)`<br>`+ [IBGLog logError:]`                                                                    |
|            | `Instabug.clearLogs()`<br>`+ [IBGLog clearAllLogs:]`                                                                         |

## Integration

Creating a Flutter app on the Instabug dashboard isn't possible yet. Create a React Native app instead.


## Using Instabug
1. To start using Instabug, import it into your file as follows: 

```dart
import 'package:instabug_flutter/instabug_flutter.dart';
```
2. Then initialize it in the `initState`. This line will let the Instabug SDK work with the default behavior. The SDK will be invoked when the device is shaken. You can customize this behavior through the APIs (You can skip this step if you are building an Android app only).

```dart
InstabugFlutter.start('IOS_APP_TOKEN', [InvocationEvent.shake]);
```
3. Open `android/app/src/main/java/[...]/CustomFlutterApplication.java`
   In the `onCreate` initialize the SDK like the following snippet. You just need to add your Android app token (You can skip this step if you are building an iOS app only). You can change the invocation event simply by replacing the `INVOCATION_EVENT_SHAKE` with any of the following `INVOCATION_EVENT_FLOATING_BUTTON`, `INVOCATION_EVENT_SCREENSHOT`, `INVOCATION_EVENT_TWO_FINGER_SWIPE_LEFT`, or `INVOCATION_EVENT_NONE`.
```javascript
ArrayList<String> invocationEvents = new ArrayList<>();
invocationEvents.add(InstabugFlutterPlugin.INVOCATION_EVENT_SHAKE);
new InstabugFlutterPlugin().start(CustomFlutterApplication.this, "ANDROID_APP_TOKEN", invocationEvents);
```
You can find your app token by selecting the SDK tab from your [**Instabug dashboard**](https://dashboard.instabug.com/app/sdk/).
 No newline at end of file
