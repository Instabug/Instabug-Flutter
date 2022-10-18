#import "InstabugFlutterPlugin.h"
#import "Instabug.h"
#import "IBGAPM.h"

#import "ApmApiImpl.h"
#import "BugReportingApiImpl.h"
#import "CrashReportingApiImpl.h"
#import "FeatureRequestsApiImpl.h"
#import "InstabugApiImpl.h"
#import "InstabugLogApiImpl.h"
#import "RepliesApiImpl.h"
#import "SurveysApiImpl.h"


@implementation InstabugFlutterPlugin

FlutterMethodChannel* channel;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
      methodChannelWithName:@"instabug_flutter"
            binaryMessenger:[registrar messenger]];
  InstabugFlutterPlugin* instance = [[InstabugFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  BugReportingFlutterApi *bugReportingFlutterApi = [[BugReportingFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  BugReportingApiImpl *bugReportingApi = [[BugReportingApiImpl alloc] initWithFlutterApi:bugReportingFlutterApi];
    
  RepliesFlutterApi *repliesFlutterApi = [[RepliesFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  RepliesApiImpl *repliesApi = [[RepliesApiImpl alloc] initWithFlutterApi:repliesFlutterApi];

  SurveysFlutterApi *surveysFlutterApi = [[SurveysFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  SurveysApiImpl *surveysApi = [[SurveysApiImpl alloc] initWithFlutterApi:surveysFlutterApi];

  ApmApiSetup([registrar messenger], [[ApmApiImpl alloc] init]);
  InstabugApiSetup([registrar messenger], [[InstabugApiImpl alloc] init]);
  InstabugLogApiSetup([registrar messenger], [[InstabugLogApiImpl alloc] init]);
  CrashReportingApiSetup([registrar messenger], [[CrashReportingApiImpl alloc] init]);
  FeatureRequestsApiSetup([registrar messenger], [[FeatureRequestsApiImpl alloc] init]);
  BugReportingApiSetup([registrar messenger], bugReportingApi);
  RepliesApiSetup([registrar messenger], repliesApi);
  SurveysApiSetup([registrar messenger], surveysApi);
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL isImplemented = NO;
    SEL method = NSSelectorFromString(call.method);
    if ([[InstabugFlutterPlugin class] respondsToSelector:method]) {
        isImplemented = YES;
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[InstabugFlutterPlugin class] methodSignatureForSelector:method]];
        [inv setSelector:method];
        [inv setTarget:[InstabugFlutterPlugin class]];
        /*
         * Indices 0 and 1 indicate the hidden arguments self and _cmd,
         * respectively; you should set these values directly with the target and selector properties.
         * Use indices 2 and greater for the arguments normally passed in a message.
         */
        NSInteger index = 2;
        NSArray* argumentsArray = call.arguments;
        for (NSObject * argument in argumentsArray) {
            [inv setArgument:&argument atIndex:index];
            index++;
        }
        [inv invoke];
        NSMethodSignature *signature = [inv methodSignature];
        const char *type = [signature methodReturnType];

        if (strcmp(type, "v") != 0) {
            void *returnVal;
            [inv getReturnValue:&returnVal];
            NSObject *resultSet = (__bridge NSObject *)returnVal;
            result(resultSet);
        } else {
            result(nil);
        }
    }
    if (!isImplemented) {
        result(FlutterMethodNotImplemented);
    }
}


/**
  * Sets the runnable that gets executed just before showing any valid survey<br/>
  * WARNING: This runs on your application's main UI thread. Please do not include
  * any blocking operations to avoid ANRs.
  */
+ (void)setOnShowSurveyCallback {
  IBGSurveys.willShowSurveyHandler = ^{
           [channel invokeMethod:@"onShowSurveyCallback" arguments:nil];
        };
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
