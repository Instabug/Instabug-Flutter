#import <XCTest/XCTest.h>
#import <ArgsRegistry.h>

@interface ArgsRegistryTests : XCTestCase
@end

@implementation ArgsRegistryTests

- (void)testSdkLogLevels {
    NSArray *values = @[
        @(IBGSDKDebugLogsLevelVerbose),
        @(IBGSDKDebugLogsLevelDebug),
        @(IBGSDKDebugLogsLevelError),
        @(IBGSDKDebugLogsLevelNone)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.sdkLogLevels allValues] containsObject:value]);
    }
}

- (void)testInvocationEvents {
    NSArray *values = @[
        @(IBGInvocationEventNone),
        @(IBGInvocationEventShake),
        @(IBGInvocationEventScreenshot),
        @(IBGInvocationEventTwoFingersSwipeLeft),
        @(IBGInvocationEventFloatingButton),
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.invocationEvents allValues] containsObject:value]);
    }
}

- (void)testInvocationOptions {
    NSArray *values = @[
        @(IBGBugReportingOptionEmailFieldHidden),
        @(IBGBugReportingOptionEmailFieldOptional),
        @(IBGBugReportingOptionCommentFieldRequired),
        @(IBGBugReportingOptionDisablePostSendingDialog)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.invocationOptions allValues] containsObject:value]);
    }
}

- (void)testColorThemes {
    NSArray *values = @[
        @(IBGColorThemeLight),
        @(IBGColorThemeDark)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.colorThemes allValues] containsObject:value]);
    }
}

- (void)testFloatingButtonEdges {
    NSArray *values = @[
        @(CGRectMinXEdge),
        @(CGRectMaxXEdge)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.floatingButtonEdges allValues] containsObject:value]);
    }
}

- (void)testRecordButtonPositions {
    NSArray *values = @[
        @(IBGPositionTopLeft),
        @(IBGPositionTopRight),
        @(IBGPositionBottomLeft),
        @(IBGPositionBottomRight)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.recordButtonPositions allValues] containsObject:value]);
    }
}

- (void)testWelcomeMessageStates {
    NSArray *values = @[
        @(IBGWelcomeMessageModeLive),
        @(IBGWelcomeMessageModeBeta),
        @(IBGWelcomeMessageModeDisabled)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.welcomeMessageStates allValues] containsObject:value]);
    }
}

- (void)testReportTypes {
    NSArray *values = @[
        @(IBGBugReportingReportTypeBug),
        @(IBGBugReportingReportTypeFeedback),
        @(IBGBugReportingReportTypeQuestion)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.reportTypes allValues] containsObject:value]);
    }
}

- (void)testDismissTypes {
    NSArray *values = @[
        @(IBGDismissTypeSubmit),
        @(IBGDismissTypeCancel),
        @(IBGDismissTypeAddAttachment)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.dismissTypes allValues] containsObject:value]);
    }
}

- (void)testActionTypes {
    NSArray *values = @[
        @(IBGActionAllActions),
        @(IBGActionReportBug),
        @(IBGActionRequestNewFeature),
        @(IBGActionAddCommentToFeature),
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.actionTypes allValues] containsObject:value]);
    }
}

- (void)testExtendedBugReportStates {
    NSArray *values = @[
        @(IBGExtendedBugReportModeEnabledWithRequiredFields),
        @(IBGExtendedBugReportModeEnabledWithOptionalFields),
        @(IBGExtendedBugReportModeDisabled)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.extendedBugReportStates allValues] containsObject:value]);
    }
}

- (void)testReproModes {
    NSArray *values = @[
        @(IBGUserStepsModeEnable),
        @(IBGUserStepsModeDisable),
        @(IBGUserStepsModeEnabledWithNoScreenshots)
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.reproModes allValues] containsObject:value]);
    }
}

- (void)testLocales {
    NSArray *values = @[
        @(IBGLocaleArabic),
        @(IBGLocaleAzerbaijani),
        @(IBGLocaleChineseSimplified),
        @(IBGLocaleChineseTraditional),
        @(IBGLocaleCzech),
        @(IBGLocaleDanish),
        @(IBGLocaleDutch),
        @(IBGLocaleEnglish),
        @(IBGLocaleFinnish),
        @(IBGLocaleFrench),
        @(IBGLocaleGerman),
        @(IBGLocaleHungarian),
        @(IBGLocaleItalian),
        @(IBGLocaleJapanese),
        @(IBGLocaleKorean),
        @(IBGLocaleNorwegian),
        @(IBGLocalePolish),
        @(IBGLocalePortugueseBrazil),
        @(IBGLocalePortuguese),
        @(IBGLocaleRomanian),
        @(IBGLocaleRussian),
        @(IBGLocaleSlovak),
        @(IBGLocaleSpanish),
        @(IBGLocaleSwedish),
        @(IBGLocaleTurkish),
    ];

    for (NSNumber *value in values) {
        XCTAssertTrue([[ArgsRegistry.locales allValues] containsObject:value]);
    }
}

- (void)testPlaceholders {
    NSArray *values = @[
        kIBGShakeStartAlertTextStringName,
        kIBGEdgeSwipeStartAlertTextStringName,
        kIBGInvalidEmailMessageStringName,
        kIBGInvocationTitleStringName,
        kIBGAskAQuestionStringName,
        kIBGReportBugStringName,
        kIBGReportFeedbackStringName,
        kIBGEmailFieldPlaceholderStringName,
        kIBGCommentFieldPlaceholderForBugReportStringName,
        kIBGCommentFieldPlaceholderForFeedbackStringName,
        kIBGCommentFieldPlaceholderForQuestionStringName,
        kIBGAddVoiceMessageStringName,
        kIBGAddImageFromGalleryStringName,
        kIBGAddExtraScreenshotStringName,
        kIBGChatsTitleStringName,
        kIBGAudioRecordingPermissionDeniedTitleStringName,
        kIBGChatReplyFieldPlaceholderStringName,
        kIBGRecordingMessageToHoldTextStringName,
        kIBGRecordingMessageToReleaseTextStringName,
        kIBGThankYouAlertMessageStringName,
        kIBGThankYouAlertTitleStringName,
        kIBGAddScreenRecordingMessageStringName,
        kIBGVideoPressRecordTitle,
        kIBGBetaWelcomeMessageWelcomeStepTitle,
        kIBGBetaWelcomeMessageWelcomeStepContent,
        kIBGBetaWelcomeMessageHowToReportStepTitle,
        kIBGBetaWelcomeMessageHowToReportStepContent,
        kIBGBetaWelcomeMessageFinishStepTitle,
        kIBGBetaWelcomeMessageFinishStepContent,
        kIBGLiveWelcomeMessageTitle,
        kIBGLiveWelcomeMessageContent,

        kIBGTeamStringName,
        kIBGReplyButtonTitleStringName,
        kIBGDismissButtonTitleStringName,

        kIBGStoreRatingThankYouTitleText,
        kIBGStoreRatingThankYouDescriptionText,

        kIBGReportBugDescriptionStringName,
        kIBGReportFeedbackDescriptionStringName,
        kIBGReportQuestionDescriptionStringName,
        kIBGRequestFeatureDescriptionStringName,

        kIBGDiscardAlertTitle,
        kIBGDiscardAlertMessage,
        kIBGDiscardAlertCancel,
        kIBGDiscardAlertAction,
        kIBGAddAttachmentButtonTitleStringName,

        kIBGReproStepsDisclaimerBody,
        kIBGReproStepsDisclaimerLink,
        kIBGProgressViewTitle,
        kIBGReproStepsListTitle,
        kIBGReproStepsListHeader,
        kIBGReproStepsListEmptyStateLabel,
        kIBGReproStepsListItemName,
    ];

    for (NSString *value in values) {
        XCTAssertTrue([[ArgsRegistry.placeholders allValues] containsObject:value]);
    }
}

@end
