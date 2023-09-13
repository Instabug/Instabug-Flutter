# Changelog

## [Unreleased](https://github.com/Instabug/Instabug-Flutter/compare/v11.14.0...dev)

### Added

- Add network logs obfuscation support using the new `NetworkLogger.obfuscateLog` API ([#380](https://github.com/Instabug/Instabug-Flutter/pull/380)).
- Add network logs omission support using the new `NetworkLogger.omitLog` API ([#382](https://github.com/Instabug/Instabug-Flutter/pull/382)).
- Add the new repro steps configuration API `Instabug.setReproStepsConfig` ([#388](https://github.com/Instabug/Instabug-Flutter/pull/388)).

### Changed

- Bump Instabug Android SDK to v11.14.0 ([#384](https://github.com/Instabug/Instabug-Flutter/pull/384)). [See release notes](https://github.com/Instabug/Instabug-Android/releases/tag/v11.14.0).
- Bump Instabug iOS SDK to v11.14.0 ([#383](https://github.com/Instabug/Instabug-Flutter/pull/383)). [See release notes](https://github.com/Instabug/Instabug-iOS/releases/tag/11.14.0).

### Deprecated

- Deprecate `Instabug.setReproStepsMode` in favor of the new `Instabug.setReproStepsConfig` ([#388](https://github.com/Instabug/Instabug-Flutter/pull/388)).

## [11.13.0](https://github.com/Instabug/Instabug-Flutter/compare/v11.12.0...v11.13.0) (July 10, 2023)

### Changed

- Bump Instabug iOS SDK to v11.13.3 ([#373](https://github.com/Instabug/Instabug-Flutter/pull/373)). [See release notes](https://github.com/Instabug/Instabug-iOS/releases/tag/v11.13.0).
- Bump Instabug Android SDK to v11.13.0 ([#372](https://github.com/Instabug/Instabug-Flutter/pull/372)). [See release notes](https://github.com/Instabug/Instabug-Android/releases/tag/v11.13.0).

### Fixed

- Fix an issue that caused APIs that return a value or invoke a callback break on Android in some versions of Flutter ([#370](https://github.com/Instabug/Instabug-Flutter/pull/370), [#369](https://github.com/Instabug/Instabug-Flutter/pull/369)).

  Below is a list of all the affected APIs:

  - `APM.startExecutionTrace`
  - `BugReporting.setOnInvokeCallback`
  - `BugReporting.setOnDismissCallback`
  - `Instabug.getTags`
  - `Instabug.getUserAttributeForKey`
  - `Instabug.getUserAttributes`
  - `Replies.getUnreadRepliesCount`
  - `Replies.hasChats`
  - `Replies.setOnNewReplyReceivedCallback`
  - `Surveys.hasRespondToSurvey`
  - `Surveys.setOnShowCallback`
  - `Surveys.setOnDismissCallback`

## [11.12.0](https://github.com/Instabug/Instabug-Flutter/compare/v11.10.1...v11.12.0) (May 30, 2023)

### Changed

- Bump Instabug Android SDK to v11.12.0 ([#366](https://github.com/Instabug/Instabug-Flutter/pull/366)). [See release notes](https://github.com/Instabug/Instabug-Android/releases/tag/v11.12.0).
- Bump Instabug iOS SDK to v11.12.0 ([#365](https://github.com/Instabug/Instabug-Flutter/pull/365)). [See release notes](https://github.com/Instabug/Instabug-iOS/releases/tag/11.12.0).

## [11.10.1](https://github.com/Instabug/Instabug-Flutter/compare/v11.10.0...v11.10.1) (April 17, 2023)

### Changed

- Bump Instabug iOS SDK to v11.10.1 ([#358](https://github.com/Instabug/Instabug-Flutter/pull/358)). [See release notes](https://github.com/Instabug/Instabug-iOS/releases/tag/11.10.1).

## [11.10.0](https://github.com/Instabug/Instabug-Flutter/compare/v11.9.0...v11.10.0) (April 12, 2023)

### Changed

- Bump Instabug Android SDK to v11.11.0 ([#352](https://github.com/Instabug/Instabug-Flutter/pull/352)). [See release notes](https://github.com/Instabug/Instabug-Android/releases/tag/v11.11.0).
- Bump Instabug iOS SDK to v11.10.0 ([#353](https://github.com/Instabug/Instabug-Flutter/pull/353)). [See release notes](https://github.com/Instabug/Instabug-iOS/releases/tag/11.10.0).

## 11.9.0 (2023-02-21)

- Bumps Instabug Android SDK to v11.9.0.
- Bumps Instabug iOS SDK to v11.9.0.
- Adds the new `Instabug.init` API to start the SDK as follows:
  ```dart
  Instabug.init(
    token: '<APP_TOKEN>',
    invocationEvents: [InvocationEvent.shake],
    debugLogsLevel: LogLevel.verbose,
  );
  ```
- Adds `hungarian` and `finnish` locales support.
- Deprecates `Instabug.start` in favour of `Instabug.init`.
- Deprecates `Instabug.setDebugEnabled`, `Instabug.setSdkDebugLogsLevel`, and `APM.setLogLevel` in favour of `debugLogsLevel` parameter of `Instabug.init`.
- Deprecates the `IBGSDKDebugLogsLevel` enum in favour of the `LogLevel` enum.
- Deprecates both `warning` and `info` values from the `LogLevel` enum.
- Fixes `norwegian` and `slovak` locales on iOS.
- Fixes license warning on iOS.
- Exports Instabug Android SDK using `api` instead of `implementation`.

## 11.6.0 (2022-12-29)

- Bumps Instabug Android SDK to v11.7.0
- Bumps Instabug iOS SDK to v11.6.0
- Adds new string keys: okButtonText, audio, image, screenRecording, messagesNotificationAndOthers, insufficientContentTitle, insufficientContentMessage
- Fixes APM network logging on Android
- Fixes a NullPointerException when overriding a string key that doesn't exist on Android
- Removes redundant native logs

## 11.5.0 (2022-11-24)

- Bumps Instabug Android SDK to v11.6.0
- Bumps Instabug iOS SDK to v11.5.0
- Adds BugReporting.setDisclaimerText API
- Adds BugReporting.setCommentMinimumCharacterCount API
- Adds Romanian locale support
- Adds Repro Steps screenshots on Android
- Removes "Media Projection" dialog while taking screenshots on Android
- Fixes APM network logging on Android
- Fixes main thread violation on Android
- Fixes an issue with request and response headers parameters type causing network requests not getting logged on iOS
- Improves performance by using pigeon for internal communication between Flutter and the host platform
- Deprecates Instabug.enableAndroid and Instabug.disableAndroid APIs in favour of the new API Instabug.setEnabled, which works on both platforms
- Deprecates callbacks in favor of return values in the following APIs:
  1. Replies.getUnreadRepliesCount
  2. Replies.hasChats
  3. Surveys.hasRespondedToSurvey
  4. Surveys.getAvailableSurveys

## 11.3.0 (2022-09-30)

- Bumps Instabug Android SDK to v11.5.1
- Bumps Instabug iOS SDK to v11.3.0
- Adds BugReporting.setVideoRecordingFloatingButtonPosition API
- Adds some missing string keys and their mappings on iOS and Android
- Adds missing mapping for portuguesePortugal locale on iOS
- Fixes an issue with some string keys not working on Android

## 11.2.0 (2022-09-08)

- Bumps Instabug Android SDK to v11.4.1
- Bumps Instabug iOS SDK to v11.2.0
- Fixes an issue with BugReporting.setInvocationEvents on iOS that always sets the event to none
- Fixes an issue with network logging on iOS which caused the initial network requests logs to be skipped
- Renames Android package from com.instabug.instabugFlutter to com.instabug.flutter

## v11.0.0 (2022-07-20)

- Bumps Instabug native SDKs to v11
- Adds the ability to initialize the Android SDK from Dart. Check the migration guide referenced in our docs
- Changes the package importing style for a more conventional use. Check the migration guide referenced in our docs
- Moves InstabugCustomHttpClient used for network logging into a separate repo. Check the migration guide referenced in our docs
- Flutter 3 compatibility
- Bumps Gradle to 6.8 & Android Gradle plugin to 4.1
- Adds BugReporting.setFloatingButtonEdge API
- Removes the string keys bugReportHeader and feedbackReportHeader. Check the migration guide referenced in our docs
- Removes the deprecated APIs. Check the migration guide referenced in our docs
- Fixes an issue with Android screenshots being black on release mode on SDK v10.13.0

## v10.13.0 (2022-03-31)

- Adds support for uploading debug symbols on Android to be used for crash deobfuscation
- Adds Instabug Experiments APIs
- Bumps Instabug native SDKs to v10.13
- Fixes iOS platform calls not completing with `void` return type

## v10.11.0 (2022-01-04)

- Adds support for APM.endAppLaunch API
- Bumps Instabug native SDKs to v10.11
- Fixes an issue with APM logged requests payload size

## v10.9.1 (2021-10-13)

- Bumps Instabug Android SDK to v10.9.1
- Bumps Instabug iOS SDK to v10.9.3
- Fixes an issue with network requests not getting logged on iOS

## v10.9.0 (2021-09-28)

- Migrates to Flutter Android embedding v2
- Bumps Instabug native SDKs to v10.9

## v10.8.0 (2021-09-13)

- Introduces Instabug's new App Performance Monitoring (APM)

## v10.0.1 (2021-08-25)

- Fixes an issue with http client logger.

## v10.0.0 (2021-08-04)

- Bumps Instabug native SDKs to v10.8

## v9.2.0 (2021-08-02)

- Adds null safety support.
- Fixes a crash when Instabug.start API is called on Android without Platform check.
- Changes all `void ... async` methods to `Future<void> ... async` so that callers can use `await`.

## v9.2.0-nullsafety.0 (2021-07-14)

- Adds null safety support.
- Fixes a crash when Instabug.start API is called on Android without Platform check.
- Changes all `void ... async` methods to `Future<void> ... async` so that callers can use `await`.

## v9.1.9 (2021-05-11)

- Adds support for overriding the replies notification string values through `repliesNotificationTeamName`, `repliesNotificationReplyButton`, `repliesNotificationDismissButton`
- Removes the use of `android:requestLegacyExternalStorage` attribute on Android

## v9.1.8 (2021-02-17)

- Fixes an issue with iOS invocation events causing the welcome message not to show.

## v9.1.7 (2020-10-01)

- Adds support for the Azerbaijani locale
- Adds support for the Enable/Disable APIs on Android
- Bumps Instabug iOS SDK to v9.1.7
- Bumps Instabug Android SDK to v9.1.8

## v9.1.6 (2020-07-13)

- Added CrashReporting
- Added setShakingThresholdForiPhone, setShakingThresholdForiPad and setShakingThresholdForAndroid APIs
- Added Proguard rules to protect Flutter bridge class and method names from getting obfuscated when the minifyEnabled flag is set to true.

## v9.1.0 (2020-03-19)

- Bump Native SDKs to v9.1

## v9.0.6 (2020-01-29)

- Bump iOS Native SDK to v9.0.6

## v9.0.5 (2020-01-27)

- Bump Native SDKs to v9.0.5

## Version 9.0.1 (2019-12-12)

- Added enum `CustomTextPlaceHolderKey.reportQuestion` which maps to `InstabugCustomTextPlaceHolder.Key.REPORT_QUESTION` on Android and `kIBGAskAQuestionStringName` on iOS

## Version 9.0.0 (2019-12-09)

- Updated native SDKs to v9.0

## Version 8.7.0 (2019-11-11)

- Updates native SDK dependencies to 8.7

## Version 8.6.4 (2019-09-16)

- Updates native SDK dependencies to 8.6.3

## Version 8.6.3 (2019-09-05)

- Updates native SDK dependencies to 8.6.2

## Version 8.6.1 (2019-08-26)

- Bumps version to 8.6 to be in sync with other platforms.
- Updates native SDK dependencies to 8.6.1.

## Version 1.0.0 (2019-07-29)

**⚠️ Package on pub has been renamed to `instabug_flutter` the old package `instabug` is deprecated**

## Version 1.0.0-beta.5 (2019-07-22)

- Adds Network logging feature for the dart:io package HttpClient.
- Fixes a linker issue on iOS when using Swift and CocoaPods.
- Bumps native iOS and Android dependencies to version 8.5.

## Version 1.0.0-beta.4 (2019-06-25)

- Fixes crash on Android on launching the sample app.

## Version 1.0.0-beta.3 (2019-05-28)

- Fixes `Locale` enum name collision with `dart.ui` library. Use `IBGLocale` instead.

- Updates Native SDK's to version 8.4

## Version 1.0.0-beta.2 (2019-05-22)

**⚠️ Check the README.md integration steps to add our new maven repository in android**

- Bump native SDK's to version 8.3
- Fixes issue of manually invoking BugReporting

## Version 1.0.0-beta.1 (2019-04-16)

- Adds New Sample App
- Adds Replies Api mappings
- Adds Chats Api mappings
- Adds FeatureRequests Api mappings.

## Version 0.0.4 (2019-04-14)

- Adds hasRespondedToSurvey API mapping.
- Adds showSurvey API mapping.
- Adds showSurveyIfAvailable API mapping.
- Adds setShouldShowWelcomeScreen API mapping.
- Adds setOnDismissCallback API mapping.
- Adds setOnShowCallback API mapping.
- Adds getAvailableSurveys API mapping.
- Adds setAutoShowingEnabled API mapping.
- Adds Surveys.setEnabled API mapping.
- Adds showWithOptions API mapping.
- Adds setInvocationOptions API mapping.
- Adds setExtendedBugReportMode API mapping.
- Adds setReportTypes API mapping.
- Adds setEnabledAttachmentTypes API mapping.
- Adds setInvocationEvents API mapping.
- Adds setOnDismissCallback API mapping.
- Adds setOnInvokeCallback API mapping.
- Adds BugReporting.setEnabled API mapping.
- Adds setWelcomeMessageMode API mapping.
- Adds addFileAttachmentWithURL, addFileAttachmentWithData, clearFileAttachments API mapping.
- Adds setUserData API mapping.
- Adds setPrimaryColor API mapping.
- Adds setSessionProfilerEnabled API mapping.

## Version 0.0.3 (2019-03-21)

- Divides the library into separate modules: (`Instabug`, `BugReporting`, `InstabugLog`).

## Version 0.0.2 (2019-03-20)

- Adds more API mappings.

## Version 0.0.1 (2019-03-07)

Adds the following APIs:

- start(String token, List<InvocationEvent> invocationEvents)
- showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode)
