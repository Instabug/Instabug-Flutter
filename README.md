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
|`logDebug(String message)`| `InstabugLog.d(String message)`<br>`+ [IBGLog logDebug:]`                                                                    |
|`logVerbose(String message)`| `InstabugLog.v(String message)`<br>`+ [IBGLog logVerbose:]`                                                                  |
|            | `InstabugLog.d(String message)`<br>`+ [IBGLog logDebug:]`                                                                    |
|`logInfo(String message)`| `InstabugLog.i(String message)`<br>`+ [IBGLog logInfo:]`                                                                     |
|            | `InstabugLog.w(String message)`<br>`+ [IBGLog logWarn:]`                                                                     |
|            | `InstabugLog.e(String message)`<br>`+ [IBGLog logError:]`                                                                    |
|            | `Instabug.clearLogs()`<br>`+ [IBGLog clearAllLogs:]`                                                                         |

## Integration

Creating a Flutter app on the Instabug dashboard isn't possible yet. Create a React Native app instead.
