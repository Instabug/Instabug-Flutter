# Instabug for Flutter

A Flutter plugin for [Instabug](https://instabug.com/).

⚠️ This plugin is currently under active development and is not ready for production use yet. If you'd like to give us [feedback](https://github.com/Instabug/Instabug-Flutter/issues) or create a [pull request](https://github.com/Instabug/Instabug-Flutter/pulls), we would highly appreciate it!

## Available Features

|      Feature                                              | Status  |
|:---------------------------------------------------------:|:-------:|
| [Bug Reporting](https://instabug.com/bug-reporting)       |    ⚙️   |
| [Crash Reporting](https://instabug.com/crash-reporting)   |    ❌   |
| [In-App Chat](https://instabug.com/in-app-chat)           |    ❌   |
| [In-App Surveys](https://instabug.com/in-app-surveys)     |    ⚙️   |
| [Feature Requests](https://instabug.com/feature-requests) |    ❌   |

* ✅ Stable
* ⚙️ Under active development
* ❌ Not available yet

### APIs

The section below contains the APIs we're planning to implement for our 1.0 release across different classes. We'll add the Dart API methods as we implement them.

#### `Instabug`

| API Method                                                           | Native Equivalent (Android/iOS)                                                                           |
|----------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `start(String token, List<InvocationEvent> invocationEvents)`        | `new Instabug.Builder(this, "APP_TOKEN").build()`<br>`+ startWithToken:invocationEvents:`                 |
| `showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode)`  | `showWelcomeMessage(WelcomeMessage.State state)`<br>`+ showWelcomeMessageWithMode:`                       |
| `identifyUserWithEmail(String email, [String name])`                 | `identifyUser(String username, String email)`<br>`+ identifyUserWithEmail:name:`                          |
| `logOut()`                                                           | `logoutUser()`<br>`+ logOut`                                                                              |
| `setLocale(Locale locale)`                                           | `setLocale(Locale locale)`<br>`+ setLocale:`                                                              |
| `setColorTheme(ColorTheme colorTheme)`                               | `setColorTheme(InstabugColorTheme theme)`<br>`+ setColorTheme:`                                           |
| `appendTags(List<String> tags)`                                      | `addTags(String... tags)`<br>`+ appendTags:`                                                              |
| `resetTags()`                                                        | `resetTags()`<br>`+ resetTags`                                                                            |
| `getTags()`                                                          | `getTags()`<br>`+ getTags`                                                                                |
| `setStringForKey(String value, String key)`                          | `setCustomTextPlaceHolders(InstabugCustomTextPlaceHolder placeholder)`<br>`+ setValue:forStringWithKey:`  |
| `setUserAttributeWithKey(String value, String key)`                  | `setUserAttribute(String key, String value)`<br>`+ setUserAttribute:withKey:`                             |
| `getUserAttributeForKey(Sring Key)`                                  | `getUserAttribute(String key)`<br>`+ userAttributeForKey:`                                                |
| `removeUserAttributeForKey(String key)`                              | `removeUserAttribute(String key)`<br>`+ removeUserAttributeForKey:`                                       |
| `getUserAttributes()`                                                | `getAllUserAttributes()`<br>`+ userAttributes:`                                                           |
| `logUserEventWithName(String name)`                                  | `logUserEvent(String name)`<br>`+ logUserEventWithName:`                                                  |
| `show()`                                                             | `show()`<br>`+ show`                                                                                      |
|                                                                      | `setSessionProfilerState(Feature.State state)`<br>`sessionProfilerEnabled`                                |
|                                                                      | `setPrimaryColor(@ColorInt int primaryColorValue)`<br>`tintColor`                                         |
|                                                                      | `onReportSubmitHandler(Report.OnReportCreatedListener listener)`<br>`willSendReportHandler`.              |
|                                                                      | `setUserData(String userData)`<br>`userData`                                                              |
|                                                                      | `show()`<br>`+ show`                                                                                      |
|                                                                      | `addFileAttachment(Uri fileUri, String fileNameWithExtension)`<br>`+ addFileAttachmentWithURL:`           |
|                                                                      | `addFileAttachment(byte[] data, String fileNameWithExtension)` `+ addFileAttachmentWithData:`             |
|                                                                      | `clearFileAttachment()`<br>`+ clearFileAttachments`                                                       |
|                                                                      | `setWelcomeMessageState(WelcomeMessage.State welcomeMessageState)`<br>`welcomeMessageMode`                |

#### `BugReporting`

| API Method                                                                                  | Native Equivalent (Android/iOS)                                                                                             |
|---------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `invokeWithMode(InvocationMode invocationMode, [List<InvocationOption> invocationOptions])` | `invoke(InvocationMode mode, @InvocationOption int... options)`<br>`+ invokeWithMode:options:`                              |
|                                                                                             | `setState(Feature.State state)`<br>`enabled`                                                                                |
|                                                                                             | `setOnInvokeCallback(OnInvokeCallback onInvokeCallback)`<br>`willInvokeHandler`                                             |
|                                                                                             | `setOnDismissCallback(OnSdkDismissCallback onSdkDismissedCallback)`<br>`didDismissHandler`                                  |
|                                                                                             | `setInvocationEvents(InstabugInvocationEvent... invocationEvents)`<br>`invocationEvents`                                    |
|                                                                                             | `setAttachmentTypesEnabled(boolean initial, boolean extra, boolean gallery, boolean recording)`<br>`enabledAttachmentTypes` |
|                                                                                             | `setReportTypes(@BugReporting.ReportType int... types)`<br>`promptOptionsEnabledReportTypes`                                |
|                                                                                             | `setExtendedBugReportState(ExtendedBugReport.State state)`<br>`extendedBugReportMode`                                       |
|                                                                                             | `setOptions(@Option int... options)`<br>`bugReportingOptions`
|                                                                                             | `show(@BugReporting.ReportType int type)`<br>`+ showWithReportType:options:`

#### `InstabugLog`

| API Method                                    | Native Equivalent (Android/iOS)                              |
|-----------------------------------------------|--------------------------------------------------------------|
| `logDebug(String message)`                     | `d(String message)`<br>`+ logDebug:`                         |
| `logVerbose(String message)`                  | `v(String message)`<br>`+ logVerbose:`                       |
| `logInfo(String message)`                     | `i(String message)`<br>`+ logInfo:`                          |
| `logWarn(String message)`                     | `w(String message)`<br>`+ logWarn:`                          |
| `logError(String message)`                    | `e(String message)`<br>`+ logError:`                         |
| `clearAllLogs(String message)`                | `clearLogs()`<br>`+ clearAllLogs:`                           |

#### `Surveys`

| API Method                                    | Native Equivalent (Android/iOS)                                                                                                             |
|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
|                                               | `setState(Feature.State state)`<br>`enabled`                                                                                                |
|                                               | `setAutoShowingEnabled(boolean isAutoShowingEnabled)`<br>`autoShowingEnabled`                                                               |
|                                               | `getAvailableSurveys()`<br>`+ availableSurveys`                                                                                             |
|                                               | `setOnShowCallback(OnShowCallback onShowCallback)`<br>`willShowSurveyHandler`                                                               |
|                                               | `setOnDismissCallback(OnDismissCallback onDismissCallback)`<br>`didDismissSurveyHandler`                                                    |
|                                               | `setShouldShowWelcomeScreen(boolean shouldShow)`<br>`shouldShowWelcomeScreen`                                                               |
|                                               | `showSurveyIfAvailable()`<br>`+ showSurveyIfAvailable`                                                                                      |
|                                               | `showSurvey(String token)`<br>`+ showSurveyWithToken:`                                                                                      |
|                                               | `setThresholdForReshowingSurveyAfterDismiss(int sessionsCount, int daysCount)`<br>`+ setThresholdForReshowingSurveyAfterDismiss:daysCount:` |
|                                               | `hasRespondToSurvey(String token)`<br>`+ hasRespondedToSurveyWithToken:`                                                                    |

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
