#import "InstabugFlutterPlugin.h"
#import "Instabug.h"
#import "IBGAPM.h"

#import "Generated/BugReportingPigeon.h"
#import "Generated/CrashReportingPigeon.h"
#import "Generated/FeatureRequestsPigeon.h"
#import "Generated/InstabugPigeon.h"
#import "Generated/InstabugLogPigeon.h"
#import "Generated/SurveysPigeon.h"

#import "BugReportingApiImpl.h"
#import "CrashReportingApiImpl.h"
#import "FeatureRequestsApiImpl.h"
#import "InstabugApiImpl.h"
#import "InstabugLogApiImpl.h"
#import "SurveysApiImpl.h"


@implementation InstabugFlutterPlugin

FlutterMethodChannel* channel;
NSMutableDictionary *traces;

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
      methodChannelWithName:@"instabug_flutter"
            binaryMessenger:[registrar messenger]];
  InstabugFlutterPlugin* instance = [[InstabugFlutterPlugin alloc] init];
  traces = [[NSMutableDictionary alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];

  BugReportingFlutterApi *bugReportingFlutterApi = [[BugReportingFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  BugReportingApiImpl *bugReportingApi = [[BugReportingApiImpl alloc] initWithFlutterApi:bugReportingFlutterApi];

  SurveysFlutterApi *surveysFlutterApi = [[SurveysFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  SurveysApiImpl *surveysApi = [[SurveysApiImpl alloc] initWithFlutterApi:surveysFlutterApi];

  InstabugApiSetup([registrar messenger], [[InstabugApiImpl alloc] init]);
  InstabugLogApiSetup([registrar messenger], [[InstabugLogApiImpl alloc] init]);
  CrashReportingApiSetup([registrar messenger], [[CrashReportingApiImpl alloc] init]);
  FeatureRequestsApiSetup([registrar messenger], [[FeatureRequestsApiImpl alloc] init]);
  BugReportingApiSetup([registrar messenger], bugReportingApi);
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

/**
  * Enables and disables everything related to receiving replies.
  * @param {boolean} isEnabled 
  */
+ (void)setRepliesEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGReplies.enabled = boolValue;
}

/**
  * Manual invocation for replies.
  */
+ (void)showReplies {
   [IBGReplies show];
}

/**
  * Tells whether the user has chats already or not.
  */
+ (void)hasChats {
    BOOL hasChats = IBGReplies.hasChats;
    NSNumber *boolNumber = [NSNumber numberWithBool:hasChats];
    [channel invokeMethod:@"hasChatsCallback" arguments:boolNumber];
}

/**
  * Sets a block of code that gets executed when a new message is received.
  */
+ (void)setOnNewReplyReceivedCallback {
  IBGReplies.didReceiveReplyHandler = ^{
          [channel invokeMethod:@"onNewReplyReceivedCallback" arguments:nil];
        };
}

/**
  * Get current unread count of messages for this user
  *
  * @return number of messages that are unread for this user
  */
+ (void)getUnreadRepliesCount {
    [channel invokeMethod:@"unreadRepliesCountCallback" arguments:@(IBGReplies.unreadRepliesCount)];
}

/**
  * Enabled/disable chat notification
  *
  * @param isEnabled whether chat notification is reburied or not
  */
+ (void)setChatNotificationEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGReplies.inAppNotificationsEnabled = boolValue;
}

/**
 * Extracts HTTP connection properties. Request method, Headers, Date, Url and Response code
 *
 * @param networkData the NSDictionary containing all HTTP connection properties
 */
+ (void)networkLog:(NSDictionary *) networkData {
    NSString* url = networkData[@"url"];
    NSString* method = networkData[@"method"];
    NSString* requestBody = networkData[@"requestBody"];
    NSString* responseBody = networkData[@"responseBody"];
    int32_t responseCode = [networkData[@"responseCode"] integerValue];
    int64_t requestBodySize = [networkData[@"requestBodySize"] integerValue];
    int64_t responseBodySize = [networkData[@"responseBodySize"] integerValue];
    int32_t errorCode = [networkData[@"errorCode"] integerValue];
    NSString* errorDomain = networkData[@"errorDomain"];
    NSDictionary* requestHeaders = networkData[@"requestHeaders"];
    if ([requestHeaders count] == 0) {
        requestHeaders = @{};
    }
    NSDictionary* responseHeaders = networkData[@"responseHeaders"];
    NSString* contentType = networkData[@"responseContentType"];
    int64_t duration = [networkData[@"duration"] integerValue];
    int64_t startTime = [networkData[@"startTime"] integerValue] * 1000;

    for(NSString *key in [requestHeaders allKeys]) {
        NSLog(@"key: %@", key);
        NSLog(@"value: %@",[requestHeaders objectForKey:key]);
    }
    
    NSString* gqlQueryName = nil;
    NSString* serverErrorMessage = nil;
    if (networkData[@"gqlQueryName"] != [NSNull null]) {
        gqlQueryName = networkData[@"gqlQueryName"];
    }
    if (networkData[@"serverErrorMessage"] != [NSNull null]) {
        serverErrorMessage = networkData[@"serverErrorMessage"];
    }
    
    SEL networkLogSEL = NSSelectorFromString(@"addNetworkLogWithUrl:method:requestBody:requestBodySize:responseBody:responseBodySize:responseCode:requestHeaders:responseHeaders:contentType:errorDomain:errorCode:startTime:duration:gqlQueryName:serverErrorMessage:");

    if([[IBGNetworkLogger class] respondsToSelector:networkLogSEL]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[IBGNetworkLogger class] methodSignatureForSelector:networkLogSEL]];
        [inv setSelector:networkLogSEL];
        [inv setTarget:[IBGNetworkLogger class]];

        [inv setArgument:&(url) atIndex:2];
        [inv setArgument:&(method) atIndex:3];
        [inv setArgument:&(requestBody) atIndex:4];
        [inv setArgument:&(requestBodySize) atIndex:5];
        [inv setArgument:&(responseBody) atIndex:6];
        [inv setArgument:&(responseBodySize) atIndex:7];
        [inv setArgument:&(responseCode) atIndex:8];
        [inv setArgument:&(requestHeaders) atIndex:9];
        [inv setArgument:&(responseHeaders) atIndex:10];
        [inv setArgument:&(contentType) atIndex:11];
        [inv setArgument:&(errorDomain) atIndex:12];
        [inv setArgument:&(errorCode) atIndex:13];
        [inv setArgument:&(startTime) atIndex:14];
        [inv setArgument:&(duration) atIndex:15];
        [inv setArgument:&(gqlQueryName) atIndex:16];
        [inv setArgument:&(serverErrorMessage) atIndex:17];

        [inv invoke];
    }
}

/**
  * Enables and disables everything related to APM feature.
  * @param {boolean} isEnabled
  */
+ (void)setAPMEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGAPM.enabled = boolValue;
}

/**
  * Sets the printed logs priority. Filter to one of the following levels:
  *
  * - logLevelNone disables all APM SDK console logs.
  *
  * - logLevelError prints errors only, we use this level to let you know if something goes wrong.
  *
  * - logLevelWarning displays warnings that will not necessarily lead to errors but should be addressed nonetheless.
  *
  * - logLevelInfo (default) logs information that we think is useful without being too verbose.
  *
  * - logLevelDebug use this in case you are debugging an issue. Not recommended for production use.
  *
  * - logLevelVerbose use this only if logLevelDebug was not enough and you need more visibility
  * on what is going on under the hood.
  *
  * Similar to the logLevelDebug level, this is not meant to be used on production environments.
  *
  * Each log level will also include logs from all the levels above it. For instance,
  * logLevelInfo will include logLevelInfo logs as well as logLevelWarning
  * and logLevelError logs.

  * @param {logLevel} the printed logs priority.
  */
+ (void)setAPMLogLevel:(NSString *)_logLevel {
  NSDictionary *constants = [self constants];
  NSInteger _logLevelIntValue = ((NSNumber *) constants[_logLevel]).integerValue;
    IBGAPM.logLevel = _logLevelIntValue;
}

/**
  * Enables and disables cold app launch tracking.
  * @param {boolean} isEnabled
  */
+ (void)setColdAppLaunchEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGAPM.appLaunchEnabled = boolValue;
}

/**
  * Starts an execution trace
  * @param {string} name of the trace.
  * @param {string} id of the trace.
  */
+ (NSString *)startExecutionTrace:(NSString *)name id:(NSString *)id {
    IBGExecutionTrace *trace = [IBGAPM startExecutionTraceWithName:name];
    if (trace != nil) {
        [traces setObject: trace forKey: id];
        return id;
    } else {
        return nil;
    }
}

/**
  * Sets an execution trace attribute
  * @param {string} id of the trace.
  * @param {string} key of the attribute.
  * @param {string} value of the attribute.
  */
+ (void)setExecutionTraceAttribute:(NSString *)id key:(NSString *)key value:(NSString *)value {
    IBGExecutionTrace *trace = [traces objectForKey:id];
    if (trace != nil) {
        [trace setAttributeWithKey:key value:value];
    }
}

/**
  * End an execution trace
  * @param {string} id of the trace.
  */
+ (void)endExecutionTrace:(NSString *)id {
    IBGExecutionTrace *trace = [traces objectForKey:id];
    if (trace != nil) {
        [trace end];
    }
}

/**
  * Enables or disables auto UI tracing.
  * @param isEnabled boolean indicating enabled or disabled.
  */
+ (void)setAutoUITraceEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGAPM.autoUITraceEnabled = boolValue;
}

/**
  * Start UI trace.
  * @param name string holding the name of the trace.
  */
+ (void)startUITrace:(NSString *)name {
    [IBGAPM startUITraceWithName:name];
}

/**
  * Ends UI trace.
  */
+ (void)endUITrace {
    [IBGAPM endUITrace];
}

/**
  * Ends app launch.
  */
+ (void)endAppLaunch {
    [IBGAPM endAppLaunch];
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
