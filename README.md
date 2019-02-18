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



| API Method | Native Equivalent                                                                                                                       |
|------------|-----------------------------------------------------------------------------------------------------------------------------------------|
|            | Android: `new Instabug.Builder(this, "APP_TOKEN").build()`<br>iOS: `+ [Instabug startWithToken:invocationEvents:]`                         |
|            | Android: `Instabug.showWelcomeMessage(WelcomeMessage.State state)`<br>iOS: `+ [Instabug showWelcomeMessageWithMode:]`                      |
|            | Android: `Instabug.identifyUser(String username, String email)`<br>iOS: `+ [Instabug identifyUserWithEmail:name:]`                         |
|            | Android: `Instabug.logoutUser()`<br>iOS: `+ [Instabug logOut]`                                                                             |
|            | Android: `Instabug.setLocale(Locale locale)`<br>iOS: `+ [Instabug setLocale:]`                                                             |
|            |  Android: `Instabug.setColorTheme(InstabugColorTheme theme)`<br>iOS: `+ [Instabug setColorTheme:]`                                         |
|            | Android: `Instabug.addTags(String... tags)`<br>iOS: `+ [Instabug appendTags:]`                                                             |
|            | Android: `Instabug.resetTags()`<br>iOS: `+ [Instabug resetTags]`                                                                           |
|            | Android: `Instabug.getTags()`<br>iOS: `+ [Instabug getTags]`                                                                               |
|            | Android: `Instabug.setCustomTextPlaceHolders(InstabugCustomTextPlaceHolder placeholder)`<br>iOS: `+ [Instabug setValue:forStringWithKey:]` |
|            | Android: `Instabug.setUserAttribute(String key, String value)`<br>iOS: `+ [Instabug setUserAttribute:withKey:]`                            |
|            | Android: `Instabug.getUserAttribute(String key)`<br>iOS: `+ [Instabug userAttributeForKey:]`                                               |
|            | Android: `Instabug.removeUserAttribute(String key)`<br>iOS: `+ [Instabug removeUserAttributeForKey:]`                                      |
|            | Android: `Instabug.getAllUserAttributes()`<br>iOS: `+ [Instabug userAttributes:]`                                                          |
|            | Android: `Instabug.logUserEvent(String name)`<br>iOS: `+ [Instabug logUserEventWithName:]`                                                 |
|            | Android: `BugReporting.invoke()`<br>iOS: `+ [IBGBugReporting invoke]`                                                                      |
|            | Android: `BugReporting.invoke(InvocationMode mode, @InvocationOption int... options)`<br>iOS: `+ [IBGBugReporting invokeWithMode:options:]`  |
|            | Android: `InstabugLog.d(String message)`<br>iOS: `+ [IBGLog log:]`                                                                         |
|            | Android: `InstabugLog.v(String message)`<br>iOS: `+ [IBGLog logVerbose:]`                                                                  |
|            | Android: `InstabugLog.d(String message)`<br>iOS: `+ [IBGLog logDebug:]`                                                                    |
|            | Android: `InstabugLog.i(String message)`<br>iOS: `+ [IBGLog logInfo:]`                                                                     |
|            | Android: `InstabugLog.w(String message)`<br>iOS: `+ [IBGLog logWarn:]`                                                                     |
|            | Android: `InstabugLog.e(String message)`<br>iOS: `+ [IBGLog logError:]`                                                                    |
|            | Android: `Instabug.clearLogs()`<br>iOS: `+ [IBGLog clearAllLogs:]`                                                                         |
