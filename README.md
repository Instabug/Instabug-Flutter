# Instabug for Flutter

A Flutter plugin for [Instabug](https://instabug.com/).

⚠️ This plugin is currently under active development and is not ready for production use yet. If you'd like to give us [feedback](https://github.com/Instabug/Instabug-Flutter/issues) or create a [pull request](https://github.com/Instabug/Instabug-Flutter/pulls), we would highly appreciate it!

## Available Features

|      Feature     | Status |
|:----------------:|:------:|
| Bug Reporting    |    ⚙️   |
| Crash Reporting  |    ❌   |
| In-App Chat      |    ❌   |
| In-App Surveys   |    ❌   |
| Feature Requests |    ❌   |

* ✅ Stable
* ⚙️ Under active development
* ❌ Unavailable

### APIs

The table below contains a list of APIs we're planning to implement for our 1.0 release. We'll add the Dart API methods as we implement them.

| Dart API Method | Android Equivalent                                                              | iOS Equivalent                                  |
|------------|---------------------------------------------------------------------------------|-------------------------------------------------|
|            | `new Instabug.Builder(this, "APP_TOKEN").build()`                               | `+ [Instabug startWithToken:invocationEvents:]` |
|            | `Instabug.showWelcomeMessage(WelcomeMessage.State state)`                       | ` + [Instabug showWelcomeMessageWithMode:]`     |
|            | `Instabug.identifyUser(String username, String email)`                          | `+ [Instabug identifyUserWithEmail:name:]`      |
|            | `Instabug.logoutUser()`                                                         | `+ [Instabug logOut]`                           |
|            | `Instabug.setLocale(Locale locale)`                                             | `+ [Instabug setLocale:]`                       |
|            | `Instabug.setColorTheme(InstabugColorTheme theme)`                              | `+ [Instabug setColorTheme:]`                   |
|            | `Instabug.addTags(String... tags)`                                              | `+ [Instabug appendTags:]`                      |
|            | `Instabug.resetTags()`                                                          | `+ [Instabug resetTags]`                        |
|            | `Instabug.getTags()`                                                            | `+ [Instabug getTags]`                          |
|            | `Instabug.setCustomTextPlaceHolders(InstabugCustomTextPlaceHolder placeholder)` | `+ [Instabug setValue:forStringWithKey:]`       |
|            | `Instabug.setUserAttribute(String key, String value)`                           | `+ [Instabug setUserAttribute:withKey:]`        |
|            | `Instabug.getUserAttribute(String key)`                                         | `+ [Instabug userAttributeForKey:]`             |
|            | `Instabug.removeUserAttribute(String key)`                                      | `+ [Instabug removeUserAttributeForKey:]`       |
|            | `Instabug.getAllUserAttributes()`                                               | `+ [Instabug userAttributes:]`                  |
|            | `Instabug.logUserEvent(String name)`                                            | `+ [Instabug logUserEventWithName:]`            |
|            | `BugReporting.invoke()`                                                         | `+ [IBGBugReporting invoke]`                    |
|            | `BugReporting.invoke(InvocationMode mode,@InvocationOption int... options)`     | `+ [IBGBugReporting invokeWithMode:options:]    |
|            | `InstabugLog.d(String message)`                                                 | `+ [IBGLog log:]`                               |
|            | `InstabugLog.v(String message)`                                                 | `+ [IBGLog logVerbose:]`                        |
|            | `InstabugLog.d(String message)`                                                 | `+ [IBGLog logDebug:]`                          |
|            | `InstabugLog.i(String message)`                                                 | `+ [IBGLog logInfo:]`                           |
|            | `InstabugLog.w(String message)`                                                 | `+ [IBGLog logWarn:]`                           |
|            | `InstabugLog.e(String message)`                                                 | `+ [IBGLog logError:]`                          |
|            | `Instabug.clearLogs()`                                                          | `+ [IBGLog clearAllLogs:]`                      |