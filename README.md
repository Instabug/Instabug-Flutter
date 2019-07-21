# Instabug for Flutter

[![pub package](https://img.shields.io/pub/v/instabug.svg)](https://pub.dev/packages/instabug)

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
| `setSessionProfilerEnabled(bool sessionProfilerEnabled)`             | `setSessionProfilerState(Feature.State state)`<br>`sessionProfilerEnabled`                                |
| `setPrimaryColor(Color color)`                                       | `setPrimaryColor(@ColorInt int primaryColorValue)`<br>`tintColor`                                         |
| `setUserData(String userData)`                                       | `setUserData(String userData)`<br>`userData`                                                              |
| `addFileAttachmentWithURL(String filePath, String fileName)`         | `addFileAttachment(Uri fileUri, String fileNameWithExtension)`<br>`+ addFileAttachmentWithURL:`           |
| `addFileAttachmentWithData(Uint8List data, String fileName)`         | `addFileAttachment(byte[] data, String fileNameWithExtension)` `+ addFileAttachmentWithData:`             |
| `clearFileAttachments()`                                             | `clearFileAttachment()`<br>`+ clearFileAttachments`                                                       |
| `setWelcomeMessageMode(WelcomeMessageMode welcomeMessageMode)`       | `setWelcomeMessageState(WelcomeMessage.State welcomeMessageState)`<br>`welcomeMessageMode`                |

#### `BugReporting`

| API Method                                                                                  | Native Equivalent (Android/iOS)                                                                                             |
|---------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------|
| `invokeWithMode(InvocationMode invocationMode, [List<InvocationOption> invocationOptions])` | `invoke(InvocationMode mode, @InvocationOption int... options)`<br>`+invokeWithMode:options:`|
| `setEnabled(bool isEnabled)`                                                                | `setState(Feature.State state)`<br>`enabled`                                                 |
| `setOnInvokeCallback(Function function)`                                                    | `setOnInvokeCallback(OnInvokeCallback onInvokeCallback)`<br>`willInvokeHandler`              |
| `setOnDismissCallback(Function function)`                                                   | `setOnDismissCallback(OnSdkDismissCallback onSdkDismissedCallback)`<br>`didDismissHandler`   |
| `setInvocationEvents(List<InvocationEvent> invocationEvents)`                               | `setInvocationEvents(InstabugInvocationEvent... invocationEvents)`<br>`invocationEvents`     |
| `setEnabledAttachmentTypes(bool screenshot, bool extraScreenshot, bool galleryImage, bool screenRecording)` | `setAttachmentTypesEnabled(boolean initial, boolean extra, boolean gallery, boolean                                                                                                            recording`<br>`enabledAttachmentTypes` |
| `setReportTypes(List<ReportType> reportTypes)`                                              | `setReportTypes(@BugReporting.ReportType int... types)`<br>`promptOptionsEnabledReportTypes` |
| `setExtendedBugReportMode(ExtendedBugReportMode extendedBugReportMode)`                     | `setExtendedBugReportState(ExtendedBugReport.State state)`<br>`extendedBugReportMode`        |
| `setInvocationOptions(List<InvocationOption> invocationOptions)`                            | `setOptions(@Option int... options)`<br>`bugReportingOptions`
| `showWithOptions(ReportType reportType, List<InvocationOption> invocationOptions)`          | `show(@BugReporting.ReportType int type)`<br>`+ showWithReportType:options:`

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
| `setEnabled(bool isEnabled)`                  | `setState(Feature.State state)`<br>`enabled`                                                                                                |
| `setAutoShowingEnabled(bool isEnabled)`       | `setAutoShowingEnabled(boolean isAutoShowingEnabled)`<br>`autoShowingEnabled`                                                               |
| `getAvailableSurveys(Function function)`      | `getAvailableSurveys()`<br>`+ availableSurveys`                                                                                             |
| `setOnShowCallback(Function function)`        | `setOnShowCallback(OnShowCallback onShowCallback)`<br>`willShowSurveyHandler`                                                               |
| `setOnDismissCallback(Function function)`     | `setOnDismissCallback(OnDismissCallback onDismissCallback)`<br>`didDismissSurveyHandler`                                                    |
| `setShouldShowWelcomeScreen(bool shouldShowWelcomeScreen)` | `setShouldShowWelcomeScreen(boolean shouldShow)`<br>`shouldShowWelcomeScreen`                                                                 |
| `showSurveyIfAvailable()`                     | `showSurveyIfAvailable()`<br>`+ showSurveyIfAvailable`                                                                                      |
| `showSurvey(String surveyToken)`              | `showSurvey(String token)`<br>`+ showSurveyWithToken:`                                                                                      |
| `hasRespondedToSurvey(String surveyToken, Function function)`   | `hasRespondToSurvey(String token)`<br>`+ hasRespondedToSurveyWithToken:`                                                                    |

#### `FeatureRequests`

| API Method                                    | Native Equivalent (Android/iOS)                              |
|-----------------------------------------------|--------------------------------------------------------------|
| `show()                 `                     | `show()`<br>`+ show`                         |
| `setEmailFieldRequired(bool isEmailFieldRequired, List<ActionType> actionTypes)`             | `setEmailFieldRequired(boolean isEmailRequired, ActionTypes actions)`<br>`+ setEmailFieldRequired:forAction:`                       |


#### `Chats`

| API Method                                    | Native Equivalent (Android/iOS)                              |
|-----------------------------------------------|--------------------------------------------------------------|
| `show()`                     | `show()`<br>`+ show`                         |
| `setEnabled(bool isEnabled)`                  | `setState(Feature.State state)`<br>`enabled`                 |


#### `Replies`

| API Method                                    | Native Equivalent (Android/iOS)                                                                                                             |
|-----------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------------------|
| `setEnabled(bool isEnabled)`                  | `setState(Feature.State state)`<br>`enabled`                                               |
| `show()`                                      | `show()`<br>`+ show`                                                                       |
| `hasChats(Function function)`                 | `hasChats()`<br>`+ hasChats`                                                               |
| `setOnNewReplyReceivedCallback(Function function)`  | `setOnNewReplyReceivedCallback(Callback callback)`<br>`didReceiveReplyHandler` 
| `getUnreadRepliesCount(Function function)`    | `getUnreadRepliesCount()`<br>`unreadRepliesCount`                                         |
| `setInAppNotificationsEnabled(bool isEnabled)`| `setInAppNotificationEnabled(Boolean isChatNotificationEnable)`<br>`inAppNotificationsEnabled`  |
| `setInAppNotificationSound(bool isEnabled)`   | `setInAppNotificationSound(Boolean shouldPlaySound)`                                       |

## Integration

Creating a Flutter app on the Instabug dashboard isn't possible yet. Create a React Native app instead.


### Installation


1. Add Instabug to your `pubspec.yaml` file.

```yaml
dependencies:
    instabug:
```

2. Install the package by running the following command.

```bash
flutter packages get
```

### Using Instabug

1. To start using Instabug, import it into your Flutter app. 

```dart
import 'package:instabug/Instabug.dart';
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
