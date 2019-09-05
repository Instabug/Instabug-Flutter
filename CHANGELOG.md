## Version 8.6.3 (2019-09-05)

* You can now initialize Instabug on Android by calling `Instabug.start` from Javascript, instead of calling the builder method from the application class.
* Updates native SDK dependencies to 8.6.2

## Version 8.6.1 (2019-08-26)

* Bumps version to 8.6 to be in sync with other platforms.
* Updates native SDK dependencies to 8.6.1.

## Version 1.0.0 (2019-07-29)

**⚠️ Package on pub has been renamed to `instabug_flutter` the old package `instabug` is deprecated**

## Version 1.0.0-beta.5 (2019-07-22)

* Adds Network logging feature for the dart:io package HttpClient.
* Fixes a linker issue on iOS when using Swift and CocoaPods.
* Bumps native iOS and Android dependencies to version 8.5.

## Version 1.0.0-beta.4 (2019-06-25)

* Fixes crash on Android on launching the sample app.

## Version 1.0.0-beta.3 (2019-05-28)

* Fixes `Locale` enum name collision with `dart.ui` library. Use `IBGLocale` instead.

* Updates Native SDK's to version 8.4

## Version 1.0.0-beta.2 (2019-05-22)

**⚠️ Check the README.md integration steps to add our new maven repository in android**

* Bump native SDK's to version 8.3
* Fixes issue of manually invoking BugReporting

## Version 1.0.0-beta.1 (2019-04-16)

* Adds New Sample App
* Adds Replies Api mappings 
* Adds Chats Api mappings
* Adds FeatureRequests Api mappings.

## Version 0.0.4 (2019-04-14)

* Adds hasRespondedToSurvey API mapping.
* Adds showSurvey API mapping.
* Adds showSurveyIfAvailable API mapping.
* Adds setShouldShowWelcomeScreen API mapping.
* Adds setOnDismissCallback API mapping.
* Adds setOnShowCallback API mapping.
* Adds getAvailableSurveys API mapping.
* Adds setAutoShowingEnabled API mapping.
* Adds Surveys.setEnabled API mapping.
* Adds showWithOptions API mapping.
* Adds setInvocationOptions API mapping.
* Adds setExtendedBugReportMode API mapping.
* Adds setReportTypes API mapping.
* Adds setEnabledAttachmentTypes API mapping.
* Adds setInvocationEvents API mapping.
* Adds setOnDismissCallback API mapping.
* Adds setOnInvokeCallback API mapping.
* Adds BugReporting.setEnabled API mapping.
* Adds setWelcomeMessageMode API mapping.
* Adds addFileAttachmentWithURL, addFileAttachmentWithData, clearFileAttachments API mapping.
* Adds setUserData API mapping.
* Adds setPrimaryColor API mapping.
* Adds setSessionProfilerEnabled API mapping.

## Version 0.0.3 (2019-03-21)

* Divides the library into separate modules: (`Instabug`, `BugReporting`, `InstabugLog`).

## Version 0.0.2 (2019-03-20)

* Adds more API mappings.


## Version 0.0.1 (2019-03-07)

Adds the following APIs:

* start(String token, List<InvocationEvent> invocationEvents)
* showWelcomeMessageWithMode(WelcomeMessageMode welcomeMessageMode)
