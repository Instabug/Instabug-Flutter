// ignore_for_file: avoid_classes_with_only_static_members

import 'dart:async';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:typed_data';
// to maintain supported versions prior to Flutter 3.3
// ignore: unnecessary_import
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instabug_flutter/instabug_flutter.dart';
import 'package:instabug_flutter/src/generated/instabug.api.g.dart';
import 'package:instabug_flutter/src/utils/enum_converter.dart';
import 'package:instabug_flutter/src/utils/ibg_build_info.dart';
import 'package:meta/meta.dart';

enum InvocationEvent {
  shake,
  screenshot,
  twoFingersSwipeLeft,
  floatingButton,
  none
}

enum WelcomeMessageMode { live, beta, disabled }

enum IBGLocale {
  arabic,
  azerbaijani,
  chineseSimplified,
  chineseTraditional,
  czech,
  danish,
  dutch,
  english,
  french,
  german,
  italian,
  japanese,
  korean,
  polish,
  portugueseBrazil,
  portuguesePortugal,
  russian,
  spanish,
  swedish,
  turkish,
  indonesian,
  slovak,
  norwegian,
  romanian,
  hungarian,
  finnish,
}

enum IBGSDKDebugLogsLevel { verbose, debug, error, none }

enum ColorTheme { dark, light }

enum CustomTextPlaceHolderKey {
  shakeHint,
  swipeHint,
  invalidEmailMessage,
  invalidCommentMessage,
  invocationHeader,
  reportQuestion,
  reportBug,
  reportFeedback,
  emailFieldHint,
  commentFieldHintForBugReport,
  commentFieldHintForFeedback,
  commentFieldHintForQuestion,
  addVoiceMessage,
  addImageFromGallery,
  addExtraScreenshot,
  conversationsListTitle,
  audioRecordingPermissionDenied,
  conversationTextFieldHint,
  voiceMessagePressAndHoldToRecord,
  voiceMessageReleaseToAttach,
  reportSuccessfullySent,
  successDialogHeader,
  addVideo,
  videoPressRecord,
  betaWelcomeMessageWelcomeStepTitle,
  betaWelcomeMessageWelcomeStepContent,
  betaWelcomeMessageHowToReportStepTitle,
  betaWelcomeMessageHowToReportStepContent,
  betaWelcomeMessageFinishStepTitle,
  betaWelcomeMessageFinishStepContent,
  liveWelcomeMessageTitle,
  liveWelcomeMessageContent,
  repliesNotificationTeamName,
  repliesNotificationReplyButton,
  repliesNotificationDismissButton,
  surveysStoreRatingThanksTitle,
  surveysStoreRatingThanksSubtitle,
  reportBugDescription,
  reportFeedbackDescription,
  reportQuestionDescription,
  requestFeatureDescription,
  discardAlertTitle,
  discardAlertMessage,
  discardAlertCancel,
  discardAlertAction,
  addAttachmentButtonTitleStringName,
  reportReproStepsDisclaimerBody,
  reportReproStepsDisclaimerLink,
  reproStepsProgressDialogBody,
  reproStepsListHeader,
  reproStepsListDescription,
  reproStepsListEmptyStateDescription,
  reproStepsListItemTitle,
  okButtonText,
  audio,
  image,
  screenRecording,
  messagesNotificationAndOthers,
  insufficientContentTitle,
  insufficientContentMessage,
}

enum ReproStepsMode { enabled, disabled, enabledWithNoScreenshots }

class Instabug {
  static var _host = InstabugHostApi();

  /// @nodoc
  @visibleForTesting
  // ignore: use_setters_to_change_properties
  static void $setHostApi(InstabugHostApi host) {
    _host = host;
  }

  /// @nodoc
  @internal
  static void init() {
    BugReporting.init();
    Replies.init();
    Surveys.init();
  }

  /// Enables or disables Instabug functionality.
  /// [boolean] isEnabled
  static Future<void> setEnabled(bool isEnabled) async {
    return _host.setEnabled(isEnabled);
  }

  /// Starts the SDK.
  /// This is the main SDK method that does all the magic. This is the only
  /// method that SHOULD be called.
  /// The [token] that identifies the app, you can find
  /// it on your dashboard.
  /// The [invocationEvents] are the events that invoke
  /// the SDK's UI.
  static Future<void> start(
    String token,
    List<InvocationEvent> invocationEvents,
  ) async {
    init();
    return _host.start(token, invocationEvents.mapToString());
  }

  /// Shows the welcome message in a specific mode.
  /// [welcomeMessageMode] is an enum to set the welcome message mode to live, or beta.
  static Future<void> showWelcomeMessageWithMode(
    WelcomeMessageMode welcomeMessageMode,
  ) async {
    return _host.showWelcomeMessageWithMode(welcomeMessageMode.toString());
  }

  /// Sets the default value of the user's [email] and hides the email field from the reporting UI
  /// and set the user's [name] to be included with all reports.
  /// It also reset the chats on device to that email and removes user attributes,
  /// user data and completed surveys.
  static Future<void> identifyUser(String email, [String? name]) async {
    return _host.identifyUser(email, name);
  }

  /// Sets the default value of the user's email to nil and show email field and remove user name
  /// from all reports
  /// It also reset the chats on device and removes user attributes, user data and completed surveys.
  static Future<void> logOut() async {
    return _host.logOut();
  }

  /// Sets the SDK's [locale].
  /// Use to change the SDK's UI to different language.
  /// Defaults to the device's current locale.
  static Future<void> setLocale(IBGLocale locale) async {
    return _host.setLocale(locale.toString());
  }

  /// Sets the verbosity level of logs used to debug The SDK. The defualt value in debug
  /// mode is sdkDebugLogsLevelVerbose and in production is sdkDebugLogsLevelError.
  static Future<void> setSdkDebugLogsLevel(
    IBGSDKDebugLogsLevel sdkDebugLogsLevel,
  ) async {
    return _host.setSdkDebugLogsLevel(sdkDebugLogsLevel.toString());
  }

  /// Sets the color theme of the SDK's whole UI to the [colorTheme] given.
  /// It should be of type [ColorTheme].
  static Future<void> setColorTheme(ColorTheme colorTheme) async {
    return _host.setColorTheme(colorTheme.toString());
  }

  /// Appends a set of [tags] to previously added tags of reported feedback, bug or crash.
  static Future<void> appendTags(List<String> tags) async {
    return _host.appendTags(tags);
  }

  /// Manually removes all tags of reported feedback, bug or crash.
  static Future<void> resetTags() async {
    return _host.resetTags();
  }

  /// Gets all tags of reported feedback, bug or crash. Returns the list of tags.
  static Future<List<String>?> getTags() async {
    final tags = await _host.getTags();
    return tags?.cast<String>();
  }

  /// Adds experiments to the next report.
  static Future<void> addExperiments(List<String> experiments) async {
    return _host.addExperiments(experiments);
  }

  /// Removes certain experiments from the next report.
  static Future<void> removeExperiments(List<String> experiments) async {
    return _host.removeExperiments(experiments);
  }

  /// Clears all experiments from the next report.
  static Future<void> clearAllExperiments() async {
    return _host.clearAllExperiments();
  }

  /// Add custom user attribute [value] with a [key] that is going to be sent with each feedback, bug or crash.
  static Future<void> setUserAttribute(String value, String key) async {
    return _host.setUserAttribute(value, key);
  }

  /// Removes a given [key] and its associated value from user attributes.
  /// Does nothing if a [key] does not exist.
  static Future<void> removeUserAttribute(String key) async {
    return _host.removeUserAttribute(key);
  }

  /// Returns the user attribute associated with a given [key].
  static Future<String?> getUserAttributeForKey(String key) {
    return _host.getUserAttributeForKey(key);
  }

  /// A new Map containing all the currently set user attributes, or an empty Map if no user attributes have been set.
  static Future<Map<String, String>> getUserAttributes() async {
    final attributes = await _host.getUserAttributes();
    return attributes != null
        ? Map<String, String>.from(attributes)
        : <String, String>{};
  }

  /// invoke sdk manually
  static Future<void> show() async {
    return _host.show();
  }

  /// Logs a user event with [name] that happens through the lifecycle of the application.
  /// Logged user events are going to be sent with each report, as well as at the end of a session.
  static Future<void> logUserEvent(String name) async {
    return _host.logUserEvent(name);
  }

  /// Overrides any of the strings shown in the SDK with custom ones.
  /// Allows you to customize a [value] shown to users in the SDK using a predefined [key].
  static Future<void> setValueForStringWithKey(
    String value,
    CustomTextPlaceHolderKey key,
  ) async {
    return _host.setValueForStringWithKey(value, key.toString());
  }

  /// Enable/disable session profiler
  /// [sessionProfilerEnabled] desired state of the session profiler feature.
  static Future<void> setSessionProfilerEnabled(
    bool sessionProfilerEnabled,
  ) async {
    return _host.setSessionProfilerEnabled(sessionProfilerEnabled);
  }

  /// Android only
  /// Enable/disable SDK logs
  /// [debugEnabled] desired state of debug mode.
  static Future<void> setDebugEnabled(bool debugEnabled) async {
    if (IBGBuildInfo.instance.isAndroid) {
      return _host.setDebugEnabled(debugEnabled);
    }
  }

  /// Sets the primary color of the SDK's UI.
  /// Sets the color of UI elements indicating interactivity or call to action.
  /// [color] primaryColor A color to set the UI elements of the SDK to.
  static Future<void> setPrimaryColor(Color color) async {
    return _host.setPrimaryColor(color.value);
  }

  /// Adds specific user data that you need to be added to the reports
  /// [userData] data to be added
  static Future<void> setUserData(String userData) async {
    return _host.setUserData(userData);
  }

  /// Add file to be attached to the bug report.
  /// [filePath] of the file
  /// [fileName] of the file
  static Future<void> addFileAttachmentWithURL(
    String filePath,
    String fileName,
  ) async {
    return _host.addFileAttachmentWithURL(filePath, fileName);
  }

  /// Add file to be attached to the bug report.
  /// [data] of the file
  /// [fileName] of the file
  static Future<void> addFileAttachmentWithData(
    Uint8List data,
    String fileName,
  ) async {
    return _host.addFileAttachmentWithData(data, fileName);
  }

  /// Clears all Uris of the attached files.
  /// The URIs which added via {@link Instabug#addFileAttachment} API not the physical files.
  static Future<void> clearFileAttachments() async {
    return _host.clearFileAttachments();
  }

  /// Sets the welcome message mode to live, beta or disabled.
  /// [welcomeMessageMode] An enum to set the welcome message mode to live, beta or disabled.
  static Future<void> setWelcomeMessageMode(
    WelcomeMessageMode welcomeMessageMode,
  ) async {
    return _host.setWelcomeMessageMode(welcomeMessageMode.toString());
  }

  /// Reports that the screen has been changed (repro steps)
  /// [screenName] String containing the screen name
  static Future<void> reportScreenChange(String screenName) async {
    return _host.reportScreenChange(screenName);
  }

  /// Changes the font of Instabug's UI.
  /// [font] The asset path to the font file (e.g. "fonts/Poppins.ttf").
  static Future<void> setFont(String font) async {
    if (IBGBuildInfo.I.isIOS) {
      return _host.setFont(font);
    }
  }

  /// Sets the repro steps mode
  /// [mode] repro steps mode
  static Future<void> setReproStepsMode(ReproStepsMode reproStepsMode) async {
    return _host.setReproStepsMode(reproStepsMode.toString());
  }

  /// Sets a custom branding image logo with [light] and [dark] images for different color modes.
  ///
  /// If no [context] is passed, [asset variants](https://docs.flutter.dev/development/ui/assets-and-images#asset-variants) won't work as expected;
  /// if you have different variants of the [light] or [dark] image assets make sure to pass the [context] in order for the right variant to be picked up.
  static Future<void> setCustomBrandingImage({
    required AssetImage light,
    required AssetImage dark,
    BuildContext? context,
  }) async {
    var configuration = ImageConfiguration.empty;
    if (context != null) {
      configuration = createLocalImageConfiguration(context);
    }

    final lightKey = await light.obtainKey(configuration);
    final darkKey = await dark.obtainKey(configuration);
    return _host.setCustomBrandingImage(lightKey.name, darkKey.name);
  }

  /// Android Only
  /// Enables all Instabug functionality
  @Deprecated(
    "Use [Instabug.setEnabled(true)] instead. This will work on both Android and iOS. ",
  )
  static Future<void> enableAndroid() async {
    if (IBGBuildInfo.I.isAndroid) {
      return _host.enableAndroid();
    }
  }

  /// Android Only
  /// Disables all Instabug functionality
  @Deprecated(
    "Use [Instabug.setEnabled(false)] instead. This will work on both Android and iOS. ",
  )
  static Future<void> disableAndroid() async {
    if (IBGBuildInfo.I.isAndroid) {
      return _host.disableAndroid();
    }
  }
}
