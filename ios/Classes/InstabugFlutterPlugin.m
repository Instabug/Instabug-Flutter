#import "InstabugFlutterPlugin.h"
#import "Instabug.h"
#import "IBGAPM.h"

#import "ApmApi.h"
#import "BugReportingApi.h"
#import "CrashReportingApi.h"
#import "FeatureRequestsApi.h"
#import "InstabugApi.h"
#import "InstabugLogApi.h"
#import "RepliesApi.h"
#import "SurveysApi.h"


@implementation InstabugFlutterPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  BugReportingFlutterApi *bugReportingFlutterApi = [[BugReportingFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  BugReportingApi *bugReportingApi = [[BugReportingApi alloc] initWithFlutterApi:bugReportingFlutterApi];
    
  RepliesFlutterApi *repliesFlutterApi = [[RepliesFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  RepliesApi *repliesApi = [[RepliesApi alloc] initWithFlutterApi:repliesFlutterApi];

  SurveysFlutterApi *surveysFlutterApi = [[SurveysFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  SurveysApi *surveysApi = [[SurveysApi alloc] initWithFlutterApi:surveysFlutterApi];

  ApmHostApiSetup([registrar messenger], [[ApmApi alloc] init]);
  InstabugHostApiSetup([registrar messenger], [[InstabugApi alloc] init]);
  InstabugLogHostApiSetup([registrar messenger], [[InstabugLogApi alloc] init]);
  CrashReportingHostApiSetup([registrar messenger], [[CrashReportingApi alloc] init]);
  FeatureRequestsHostApiSetup([registrar messenger], [[FeatureRequestsApi alloc] init]);
  BugReportingHostApiSetup([registrar messenger], bugReportingApi);
  RepliesHostApiSetup([registrar messenger], repliesApi);
  SurveysHostApiSetup([registrar messenger], surveysApi);
}

+ (NSDictionary *)constants {
  return @{
      @"InvocationEvent.shake": @(IBGInvocationEventShake),
      @"InvocationEvent.screenshot": @(IBGInvocationEventScreenshot),
      @"InvocationEvent.twoFingersSwipeLeft": @(IBGInvocationEventTwoFingersSwipeLeft),
      @"InvocationEvent.floatingButton": @(IBGInvocationEventFloatingButton),
      @"InvocationEvent.none": @(IBGInvocationEventNone),

      @"WelcomeMessageMode.live": @(IBGWelcomeMessageModeLive),
      @"WelcomeMessageMode.beta": @(IBGWelcomeMessageModeBeta),
      @"WelcomeMessageMode.disabled": @(IBGWelcomeMessageModeDisabled),
      
      @"ColorTheme.dark": @(IBGColorThemeDark),
      @"ColorTheme.light": @(IBGColorThemeLight),

      @"FloatingButtonEdge.left": @(CGRectMinXEdge),
      @"FloatingButtonEdge.right": @(CGRectMaxXEdge),
      
      @"Position.topRight": @(IBGPositionTopRight),
      @"Position.topLeft": @(IBGPositionTopLeft),
      @"Position.bottomRight": @(IBGPositionBottomRight),
      @"Position.bottomLeft": @(IBGPositionBottomLeft),

      @"InvocationOption.commentFieldRequired": @(IBGBugReportingOptionCommentFieldRequired),
      @"InvocationOption.disablePostSendingDialog": @(IBGBugReportingOptionDisablePostSendingDialog),
      @"InvocationOption.emailFieldHidden": @(IBGBugReportingOptionEmailFieldHidden),
      @"InvocationOption.emailFieldOptional": @(IBGBugReportingOptionEmailFieldOptional),

      @"IBGLocale.arabic": @(IBGLocaleArabic),
      @"IBGLocale.azerbaijani": @(IBGLocaleAzerbaijani),
      @"IBGLocale.chineseSimplified": @(IBGLocaleChineseSimplified),
      @"IBGLocale.chineseTraditional": @(IBGLocaleChineseTraditional),
      @"IBGLocale.czech": @(IBGLocaleCzech),
      @"IBGLocale.danish": @(IBGLocaleDanish),
      @"IBGLocale.dutch": @(IBGLocaleDutch),
      @"IBGLocale.english": @(IBGLocaleEnglish),
      @"IBGLocale.french": @(IBGLocaleFrench),
      @"IBGLocale.german": @(IBGLocaleGerman),
      @"IBGLocale.italian": @(IBGLocaleItalian),
      @"IBGLocale.japanese": @(IBGLocaleJapanese),
      @"IBGLocale.korean": @(IBGLocaleKorean),
      @"IBGLocale.polish": @(IBGLocalePolish),
      @"IBGLocale.portugueseBrazil": @(IBGLocalePortugueseBrazil),
      @"IBGLocale.portuguesePortugal": @(IBGLocalePortuguese),
      @"IBGLocale.russian": @(IBGLocaleRussian),
      @"IBGLocale.spanish": @(IBGLocaleSpanish),
      @"IBGLocale.swedish": @(IBGLocaleSwedish),
      @"IBGLocale.turkish": @(IBGLocaleTurkish),

      @"IBGSDKDebugLogsLevel.verbose": @(IBGSDKDebugLogsLevelVerbose),
      @"IBGSDKDebugLogsLevel.debug": @(IBGSDKDebugLogsLevelDebug),
      @"IBGSDKDebugLogsLevel.error": @(IBGSDKDebugLogsLevelError),
      @"IBGSDKDebugLogsLevel.none": @(IBGSDKDebugLogsLevelNone),
      
      @"CustomTextPlaceHolderKey.shakeHint": kIBGShakeStartAlertTextStringName,
      @"CustomTextPlaceHolderKey.swipeHint": kIBGEdgeSwipeStartAlertTextStringName,
      @"CustomTextPlaceHolderKey.invalidEmailMessage": kIBGInvalidEmailMessageStringName,
      @"CustomTextPlaceHolderKey.invalidCommentMessage": kIBGInvalidCommentMessageStringName,
      @"CustomTextPlaceHolderKey.invocationHeader": kIBGInvocationTitleStringName,
      @"CustomTextPlaceHolderKey.reportQuestion": kIBGAskAQuestionStringName,
      @"CustomTextPlaceHolderKey.reportBug": kIBGReportBugStringName,
      @"CustomTextPlaceHolderKey.reportFeedback": kIBGReportFeedbackStringName,
      @"CustomTextPlaceHolderKey.emailFieldHint": kIBGEmailFieldPlaceholderStringName,
      @"CustomTextPlaceHolderKey.commentFieldHintForBugReport": kIBGCommentFieldPlaceholderForBugReportStringName,
      @"CustomTextPlaceHolderKey.commentFieldHintForFeedback": kIBGCommentFieldPlaceholderForFeedbackStringName,
      @"CustomTextPlaceHolderKey.commentFieldHintForQuestion": kIBGCommentFieldPlaceholderForQuestionStringName,
      @"CustomTextPlaceHolderKey.addVoiceMessage": kIBGAddVoiceMessageStringName,
      @"CustomTextPlaceHolderKey.addImageFromGallery": kIBGAddImageFromGalleryStringName,
      @"CustomTextPlaceHolderKey.addExtraScreenshot": kIBGAddExtraScreenshotStringName,
      @"CustomTextPlaceHolderKey.conversationsListTitle": kIBGChatsTitleStringName,
      @"CustomTextPlaceHolderKey.audioRecordingPermissionDenied": kIBGAudioRecordingPermissionDeniedTitleStringName,
      @"CustomTextPlaceHolderKey.conversationTextFieldHint": kIBGChatReplyFieldPlaceholderStringName,
      @"CustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord": kIBGRecordingMessageToHoldTextStringName,
      @"CustomTextPlaceHolderKey.voiceMessageReleaseToAttach": kIBGRecordingMessageToReleaseTextStringName,
      @"CustomTextPlaceHolderKey.reportSuccessfullySent": kIBGThankYouAlertMessageStringName,
      @"CustomTextPlaceHolderKey.successDialogHeader": kIBGThankYouAlertTitleStringName,
      @"CustomTextPlaceHolderKey.addVideo": kIBGAddScreenRecordingMessageStringName,
      @"CustomTextPlaceHolderKey.videoPressRecord": kIBGVideoPressRecordTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle": kIBGBetaWelcomeMessageWelcomeStepTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent": kIBGBetaWelcomeMessageWelcomeStepContent,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle": kIBGBetaWelcomeMessageHowToReportStepTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent": kIBGBetaWelcomeMessageHowToReportStepContent,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle": kIBGBetaWelcomeMessageFinishStepTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent": kIBGBetaWelcomeMessageFinishStepContent,
      @"CustomTextPlaceHolderKey.liveWelcomeMessageTitle": kIBGLiveWelcomeMessageTitle,
      @"CustomTextPlaceHolderKey.liveWelcomeMessageContent": kIBGLiveWelcomeMessageContent,

      @"CustomTextPlaceHolderKey.repliesNotificationTeamName": kIBGTeamStringName,
      @"CustomTextPlaceHolderKey.repliesNotificationReplyButton": kIBGReplyButtonTitleStringName,
      @"CustomTextPlaceHolderKey.repliesNotificationDismissButton": kIBGDismissButtonTitleStringName,

      @"CustomTextPlaceHolderKey.surveysStoreRatingThanksTitle": kIBGStoreRatingThankYouTitleText,
      @"CustomTextPlaceHolderKey.surveysStoreRatingThanksSubtitle": kIBGStoreRatingThankYouDescriptionText,

      @"CustomTextPlaceHolderKey.reportBugDescription": kIBGReportBugDescriptionStringName,
      @"CustomTextPlaceHolderKey.reportFeedbackDescription": kIBGReportFeedbackDescriptionStringName,
      @"CustomTextPlaceHolderKey.reportQuestionDescription": kIBGReportQuestionDescriptionStringName,
      @"CustomTextPlaceHolderKey.requestFeatureDescription": kIBGRequestFeatureDescriptionStringName,

      @"CustomTextPlaceHolderKey.discardAlertTitle": kIBGDiscardAlertTitle,
      @"CustomTextPlaceHolderKey.discardAlertMessage": kIBGDiscardAlertMessage,
      @"CustomTextPlaceHolderKey.discardAlertCancel": kIBGDiscardAlertCancel,
      @"CustomTextPlaceHolderKey.discardAlertAction": kIBGDiscardAlertAction,
      @"CustomTextPlaceHolderKey.addAttachmentButtonTitleStringName": kIBGAddAttachmentButtonTitleStringName,

      @"CustomTextPlaceHolderKey.reportReproStepsDisclaimerBody": kIBGReproStepsDisclaimerBody,
      @"CustomTextPlaceHolderKey.reportReproStepsDisclaimerLink": kIBGReproStepsDisclaimerLink,
      @"CustomTextPlaceHolderKey.reproStepsProgressDialogBody": kIBGProgressViewTitle,
      @"CustomTextPlaceHolderKey.reproStepsListHeader": kIBGReproStepsListTitle,
      @"CustomTextPlaceHolderKey.reproStepsListDescription": kIBGReproStepsListHeader,
      @"CustomTextPlaceHolderKey.reproStepsListEmptyStateDescription": kIBGReproStepsListEmptyStateLabel,
      @"CustomTextPlaceHolderKey.reproStepsListItemTitle": kIBGReproStepsListItemName,

      @"ReportType.bug": @(IBGBugReportingReportTypeBug),
      @"ReportType.feedback": @(IBGBugReportingReportTypeFeedback),
      @"ReportType.question": @(IBGBugReportingReportTypeQuestion),

      @"ExtendedBugReportMode.enabledWithRequiredFields": @(IBGExtendedBugReportModeEnabledWithRequiredFields),
      @"ExtendedBugReportMode.enabledWithOptionalFields": @(IBGExtendedBugReportModeEnabledWithOptionalFields),
      @"ExtendedBugReportMode.disabled": @(IBGExtendedBugReportModeDisabled),

      @"ActionType.allActions": @(IBGActionAllActions),
      @"ActionType.reportBug": @(IBGActionReportBug),
      @"ActionType.requestNewFeature": @(IBGActionRequestNewFeature),
      @"ActionType.addCommentToFeature": @(IBGActionAddCommentToFeature),

      @"ReproStepsMode.enabled": @(IBGUserStepsModeEnable),
      @"ReproStepsMode.disabled": @(IBGUserStepsModeDisable),
      @"ReproStepsMode.enabledWithNoScreenshots": @(IBGUserStepsModeEnabledWithNoScreenshots),

      @"LogLevel.none": @(IBGLogLevelNone),
      @"LogLevel.error": @(IBGLogLevelError),
      @"LogLevel.warning": @(IBGLogLevelWarning),
      @"LogLevel.info": @(IBGLogLevelInfo),
      @"LogLevel.debug": @(IBGLogLevelDebug),
      @"LogLevel.verbose": @(IBGLogLevelVerbose)
  };
};

@end
