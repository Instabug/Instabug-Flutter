#import "ArgsRegistry.h"

@implementation ArgsRegistry

+ (ArgsDictionary *)sdkLogLevels {
    return @{
        @"LogLevel.none" : @(IBGSDKDebugLogsLevelNone),
        @"LogLevel.error" : @(IBGSDKDebugLogsLevelError),
        @"LogLevel.debug" : @(IBGSDKDebugLogsLevelDebug),
        @"LogLevel.verbose" : @(IBGSDKDebugLogsLevelVerbose),
    };
}

+ (ArgsDictionary *)invocationEvents {
    return @{
        @"InvocationEvent.none" : @(IBGInvocationEventNone),
        @"InvocationEvent.shake" : @(IBGInvocationEventShake),
        @"InvocationEvent.screenshot" : @(IBGInvocationEventScreenshot),
        @"InvocationEvent.twoFingersSwipeLeft" : @(IBGInvocationEventTwoFingersSwipeLeft),
        @"InvocationEvent.floatingButton" : @(IBGInvocationEventFloatingButton),
    };
}

+ (ArgsDictionary *)invocationOptions {
    return @{
        @"InvocationOption.emailFieldHidden" : @(IBGBugReportingOptionEmailFieldHidden),
        @"InvocationOption.emailFieldOptional" : @(IBGBugReportingOptionEmailFieldOptional),
        @"InvocationOption.commentFieldRequired" : @(IBGBugReportingOptionCommentFieldRequired),
        @"InvocationOption.disablePostSendingDialog" : @(IBGBugReportingOptionDisablePostSendingDialog),
    };
}

+ (ArgsDictionary *)colorThemes {
    return @{
        @"ColorTheme.light" : @(IBGColorThemeLight),
        @"ColorTheme.dark" : @(IBGColorThemeDark),
    };
}

+ (ArgsDictionary *)floatingButtonEdges {
    return @{
        @"FloatingButtonEdge.left" : @(CGRectMinXEdge),
        @"FloatingButtonEdge.right" : @(CGRectMaxXEdge),
    };
}

+ (ArgsDictionary *)autoMasking {
    return @{
        @"AutoMasking.labels" : @(IBGAutoMaskScreenshotOptionLabels),
        @"AutoMasking.textInputs" : @(IBGAutoMaskScreenshotOptionTextInputs),
        @"AutoMasking.media" : @(IBGAutoMaskScreenshotOptionMedia),
        @"AutoMasking.none" : @(IBGAutoMaskScreenshotOptionMaskNothing
),

    };
}


+ (ArgsDictionary *)recordButtonPositions {
    return @{
        @"Position.topLeft" : @(IBGPositionTopLeft),
        @"Position.topRight" : @(IBGPositionTopRight),
        @"Position.bottomLeft" : @(IBGPositionBottomLeft),
        @"Position.bottomRight" : @(IBGPositionBottomRight),
    };
}

+ (ArgsDictionary *)welcomeMessageStates {
    return @{
        @"WelcomeMessageMode.live" : @(IBGWelcomeMessageModeLive),
        @"WelcomeMessageMode.beta" : @(IBGWelcomeMessageModeBeta),
        @"WelcomeMessageMode.disabled" : @(IBGWelcomeMessageModeDisabled),
    };
}

+ (ArgsDictionary *)reportTypes {
    return @{
        @"ReportType.bug" : @(IBGBugReportingReportTypeBug),
        @"ReportType.feedback" : @(IBGBugReportingReportTypeFeedback),
        @"ReportType.question" : @(IBGBugReportingReportTypeQuestion),
    };
}

+ (ArgsDictionary *)dismissTypes {
    return @{
        @"DismissType.submit" : @(IBGDismissTypeSubmit),
        @"DismissType.cancel" : @(IBGDismissTypeCancel),
        @"DismissType.addAttachment" : @(IBGDismissTypeAddAttachment),
    };
}

+ (ArgsDictionary *)actionTypes {
    return @{
        @"ActionType.allActions" : @(IBGActionAllActions),
        @"ActionType.reportBug" : @(IBGActionReportBug),
        @"ActionType.requestNewFeature" : @(IBGActionRequestNewFeature),
        @"ActionType.addCommentToFeature" : @(IBGActionAddCommentToFeature),
    };
}

+ (ArgsDictionary *)extendedBugReportStates {
    return @{
        @"ExtendedBugReportMode.enabledWithRequiredFields" : @(IBGExtendedBugReportModeEnabledWithRequiredFields),
        @"ExtendedBugReportMode.enabledWithOptionalFields" : @(IBGExtendedBugReportModeEnabledWithOptionalFields),
        @"ExtendedBugReportMode.disabled" : @(IBGExtendedBugReportModeDisabled),
    };
}
+ (ArgsDictionary *)nonFatalExceptionLevel {
    return @{
        @"NonFatalExceptionLevel.info" : @(IBGNonFatalLevelInfo),
        @"NonFatalExceptionLevel.error" : @(IBGNonFatalLevelError),
        @"NonFatalExceptionLevel.warning" : @(IBGNonFatalLevelWarning),
        @"NonFatalExceptionLevel.critical" : @(IBGNonFatalLevelCritical)


    };
}

+ (ArgsDictionary *)reproModes {
    return @{
        @"ReproStepsMode.enabled" : @(IBGUserStepsModeEnable),
        @"ReproStepsMode.disabled" : @(IBGUserStepsModeDisable),
        @"ReproStepsMode.enabledWithNoScreenshots" : @(IBGUserStepsModeEnabledWithNoScreenshots),
    };
}

+ (ArgsDictionary *)locales {
    return @{
        @"IBGLocale.arabic" : @(IBGLocaleArabic),
        @"IBGLocale.azerbaijani" : @(IBGLocaleAzerbaijani),
        @"IBGLocale.chineseSimplified" : @(IBGLocaleChineseSimplified),
        @"IBGLocale.chineseTraditional" : @(IBGLocaleChineseTraditional),
        @"IBGLocale.czech" : @(IBGLocaleCzech),
        @"IBGLocale.danish" : @(IBGLocaleDanish),
        @"IBGLocale.dutch" : @(IBGLocaleDutch),
        @"IBGLocale.english" : @(IBGLocaleEnglish),
        @"IBGLocale.finnish" : @(IBGLocaleFinnish),
        @"IBGLocale.french" : @(IBGLocaleFrench),
        @"IBGLocale.german" : @(IBGLocaleGerman),
        @"IBGLocale.hungarian" : @(IBGLocaleHungarian),
        @"IBGLocale.italian" : @(IBGLocaleItalian),
        @"IBGLocale.japanese" : @(IBGLocaleJapanese),
        @"IBGLocale.korean" : @(IBGLocaleKorean),
        @"IBGLocale.norwegian" : @(IBGLocaleNorwegian),
        @"IBGLocale.polish" : @(IBGLocalePolish),
        @"IBGLocale.portugueseBrazil" : @(IBGLocalePortugueseBrazil),
        @"IBGLocale.portuguesePortugal" : @(IBGLocalePortuguese),
        @"IBGLocale.romanian" : @(IBGLocaleRomanian),
        @"IBGLocale.russian" : @(IBGLocaleRussian),
        @"IBGLocale.slovak" : @(IBGLocaleSlovak),
        @"IBGLocale.spanish" : @(IBGLocaleSpanish),
        @"IBGLocale.swedish" : @(IBGLocaleSwedish),
        @"IBGLocale.turkish" : @(IBGLocaleTurkish),
    };
}

+ (NSDictionary<NSString *, NSString *> *)placeholders {
    return @{
        @"CustomTextPlaceHolderKey.shakeHint" : kIBGShakeStartAlertTextStringName,
        @"CustomTextPlaceHolderKey.swipeHint" : kIBGEdgeSwipeStartAlertTextStringName,
        @"CustomTextPlaceHolderKey.invalidEmailMessage" : kIBGInvalidEmailMessageStringName,
        @"CustomTextPlaceHolderKey.invocationHeader" : kIBGInvocationTitleStringName,
        @"CustomTextPlaceHolderKey.reportQuestion" : kIBGAskAQuestionStringName,
        @"CustomTextPlaceHolderKey.reportBug" : kIBGReportBugStringName,
        @"CustomTextPlaceHolderKey.reportFeedback" : kIBGReportFeedbackStringName,
        @"CustomTextPlaceHolderKey.emailFieldHint" : kIBGEmailFieldPlaceholderStringName,
        @"CustomTextPlaceHolderKey.commentFieldHintForBugReport" : kIBGCommentFieldPlaceholderForBugReportStringName,
        @"CustomTextPlaceHolderKey.commentFieldHintForFeedback" : kIBGCommentFieldPlaceholderForFeedbackStringName,
        @"CustomTextPlaceHolderKey.commentFieldHintForQuestion" : kIBGCommentFieldPlaceholderForQuestionStringName,
        @"CustomTextPlaceHolderKey.addVoiceMessage" : kIBGAddVoiceMessageStringName,
        @"CustomTextPlaceHolderKey.addImageFromGallery" : kIBGAddImageFromGalleryStringName,
        @"CustomTextPlaceHolderKey.addExtraScreenshot" : kIBGAddExtraScreenshotStringName,
        @"CustomTextPlaceHolderKey.conversationsListTitle" : kIBGChatsTitleStringName,
        @"CustomTextPlaceHolderKey.audioRecordingPermissionDenied" : kIBGAudioRecordingPermissionDeniedTitleStringName,
        @"CustomTextPlaceHolderKey.conversationTextFieldHint" : kIBGChatReplyFieldPlaceholderStringName,
        @"CustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord" : kIBGRecordingMessageToHoldTextStringName,
        @"CustomTextPlaceHolderKey.voiceMessageReleaseToAttach" : kIBGRecordingMessageToReleaseTextStringName,
        @"CustomTextPlaceHolderKey.reportSuccessfullySent" : kIBGThankYouAlertMessageStringName,
        @"CustomTextPlaceHolderKey.successDialogHeader" : kIBGThankYouAlertTitleStringName,
        @"CustomTextPlaceHolderKey.addVideo" : kIBGAddScreenRecordingMessageStringName,
        @"CustomTextPlaceHolderKey.videoPressRecord" : kIBGVideoPressRecordTitle,
        @"CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle" : kIBGBetaWelcomeMessageWelcomeStepTitle,
        @"CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent" : kIBGBetaWelcomeMessageWelcomeStepContent,
        @"CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle" : kIBGBetaWelcomeMessageHowToReportStepTitle,
        @"CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent" : kIBGBetaWelcomeMessageHowToReportStepContent,
        @"CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle" : kIBGBetaWelcomeMessageFinishStepTitle,
        @"CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent" : kIBGBetaWelcomeMessageFinishStepContent,
        @"CustomTextPlaceHolderKey.liveWelcomeMessageTitle" : kIBGLiveWelcomeMessageTitle,
        @"CustomTextPlaceHolderKey.liveWelcomeMessageContent" : kIBGLiveWelcomeMessageContent,

        @"CustomTextPlaceHolderKey.repliesNotificationTeamName" : kIBGTeamStringName,
        @"CustomTextPlaceHolderKey.repliesNotificationReplyButton" : kIBGReplyButtonTitleStringName,
        @"CustomTextPlaceHolderKey.repliesNotificationDismissButton" : kIBGDismissButtonTitleStringName,

        @"CustomTextPlaceHolderKey.surveysStoreRatingThanksTitle" : kIBGStoreRatingThankYouTitleText,
        @"CustomTextPlaceHolderKey.surveysStoreRatingThanksSubtitle" : kIBGStoreRatingThankYouDescriptionText,

        @"CustomTextPlaceHolderKey.reportBugDescription" : kIBGReportBugDescriptionStringName,
        @"CustomTextPlaceHolderKey.reportFeedbackDescription" : kIBGReportFeedbackDescriptionStringName,
        @"CustomTextPlaceHolderKey.reportQuestionDescription" : kIBGReportQuestionDescriptionStringName,
        @"CustomTextPlaceHolderKey.requestFeatureDescription" : kIBGRequestFeatureDescriptionStringName,

        @"CustomTextPlaceHolderKey.discardAlertTitle" : kIBGDiscardAlertTitle,
        @"CustomTextPlaceHolderKey.discardAlertMessage" : kIBGDiscardAlertMessage,
        @"CustomTextPlaceHolderKey.discardAlertCancel" : kIBGDiscardAlertCancel,
        @"CustomTextPlaceHolderKey.discardAlertAction" : kIBGDiscardAlertAction,
        @"CustomTextPlaceHolderKey.addAttachmentButtonTitleStringName" : kIBGAddAttachmentButtonTitleStringName,

        @"CustomTextPlaceHolderKey.reportReproStepsDisclaimerBody" : kIBGReproStepsDisclaimerBody,
        @"CustomTextPlaceHolderKey.reportReproStepsDisclaimerLink" : kIBGReproStepsDisclaimerLink,
        @"CustomTextPlaceHolderKey.reproStepsProgressDialogBody" : kIBGProgressViewTitle,
        @"CustomTextPlaceHolderKey.reproStepsListHeader" : kIBGReproStepsListTitle,
        @"CustomTextPlaceHolderKey.reproStepsListDescription" : kIBGReproStepsListHeader,
        @"CustomTextPlaceHolderKey.reproStepsListEmptyStateDescription" : kIBGReproStepsListEmptyStateLabel,
        @"CustomTextPlaceHolderKey.reproStepsListItemTitle" : kIBGReproStepsListItemName,

        @"CustomTextPlaceHolderKey.okButtonText" : kIBGOkButtonTitleStringName,
        @"CustomTextPlaceHolderKey.audio" : kIBGAudioStringName,
        @"CustomTextPlaceHolderKey.image" : kIBGImageStringName,
        @"CustomTextPlaceHolderKey.screenRecording" : kIBGScreenRecordingStringName,
        @"CustomTextPlaceHolderKey.messagesNotificationAndOthers" : kIBGMessagesNotificationTitleMultipleMessagesStringName,
        @"CustomTextPlaceHolderKey.insufficientContentTitle" : kIBGInsufficientContentTitleStringName,
        @"CustomTextPlaceHolderKey.insufficientContentMessage" : kIBGInsufficientContentMessageStringName,
    };
}
+ (ArgsDictionary *) userConsentActionTypes {
    return @{
        @"UserConsentActionType.dropAutoCapturedMedia": @(IBGActionTypeDropAutoCapturedMedia),
        @"UserConsentActionType.dropLogs": @(IBGActionTypeDropLogs),
        @"UserConsentActionType.noChat": @(IBGActionTypeNoChat)
    };
}

+ (ArgsDictionary *) userStepsGesture {
    return @{
        @"GestureType.swipe" : @(IBGUIEventTypeSwipe),
        @"GestureType.scroll" : @(IBGUIEventTypeScroll),
        @"GestureType.tap" : @(IBGUIEventTypeTap),
        @"GestureType.pinch" : @(IBGUIEventTypePinch),
        @"GestureType.longPress" : @(IBGUIEventTypeLongPress),
        @"GestureType.doubleTap" : @(IBGUIEventTypeDoubleTap),
    };
}
@end
