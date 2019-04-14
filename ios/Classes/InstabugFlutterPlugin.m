#import "InstabugFlutterPlugin.h"
#import "Instabug.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0 ];

@implementation InstabugFlutterPlugin


FlutterMethodChannel* channel;
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  channel = [FlutterMethodChannel
      methodChannelWithName:@"instabug_flutter"
            binaryMessenger:[registrar messenger]];
  InstabugFlutterPlugin* instance = [[InstabugFlutterPlugin alloc] init];
  [registrar addMethodCallDelegate:instance channel:channel];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL isImplemented = NO;
      SEL method = NSSelectorFromString(call.method);
      if([[InstabugFlutterPlugin class] respondsToSelector:method]) {
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
          [inv setArgument:&(argument) atIndex:index];
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
          }
      }
    if (!isImplemented) {
      result(FlutterMethodNotImplemented);
    }
}

/**
  * starts the SDK
  * @param token token The token that identifies the app
  * @param invocationEvents invocationEvents The events that invoke
  * the SDK's UI.
  */
+ (void)startWithToken:(NSString *)token invocationEvents:(NSArray*)invocationEventsArray {
    NSDictionary *constants = [self constants];
    NSInteger invocationEvents = IBGInvocationEventNone;
    for (NSString * invocationEvent in invocationEventsArray) {
        invocationEvents |= ((NSNumber *) constants[invocationEvent]).integerValue;
    }
    [Instabug startWithToken:token invocationEvents:invocationEvents];
}

/**
  * Shows the welcome message in a specific mode.
  *
  * @param welcomeMessageMode An enum to set the welcome message mode to
  *                          live, or beta.
  */
+ (void)showWelcomeMessageWithMode:(NSString *)welcomeMessageMode {
    NSDictionary *constants = [self constants];
    NSInteger welcomeMode = ((NSNumber *) constants[welcomeMessageMode]).integerValue;
    [Instabug showWelcomeMessageWithMode:welcomeMode];
}

/**
  * Set the user identity.
  * Instabug will pre-fill the user email in reports.
  *
  * @param name  Username.
  * @param email User's default email
  */
+ (void)identifyUserWithEmail:(NSString *)email name:(NSString *) name {
    if ([name isKindOfClass:[NSNull class]]) {
      [Instabug identifyUserWithEmail:email name:nil];
    } else {
      [Instabug identifyUserWithEmail:email name:name];
    }
}

/**
  * Sets the default value of the user's email to null and show email field and remove user
  * name from all reports
  * It also reset the chats on device and removes user attributes, user data and completed
  * surveys.
  */
+ (void)logOut {
  [Instabug logOut];
}

/**
  * Change Locale of Instabug UI elements(defaults to English)
  *
  * @param locale
  */
+ (void)setLocale:(NSString *)locale {
    NSDictionary *constants = [self constants];
    NSInteger localeInt = ((NSNumber *) constants[locale]).integerValue;
    [Instabug setLocale:localeInt];
}

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logVerbose:(NSString *)log {
  [IBGLog logVerbose:log];
}

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logDebug:(NSString *)log {
  [IBGLog logDebug:log];
}

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logInfo:(NSString *)log {
  [IBGLog logInfo:log];
}

/**
  * Clears Instabug internal log
  */
+ (void)clearAllLogs {
  [IBGLog clearAllLogs];
}

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logError:(NSString *)log {
  [IBGLog logError:log];
}


/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logWarn:(NSString *)log {
  [IBGLog logWarn:log];
}

/**
 * Sets the color theme of the SDK's whole UI.
 * @param colorTheme An `IBGColorTheme` to set the SDK's UI to.
 */
+ (void)setColorTheme:(NSString*) colorTheme {
    NSDictionary *constants = [self constants];
    NSInteger intColorTheme = ((NSNumber *) constants[colorTheme]).integerValue;
    [Instabug setColorTheme:intColorTheme];
}

/**
 * Appends a set of tags to previously added tags of reported feedback, bug or crash.
 * @param tags An array of tags to append to current tags.
 */
+ (void)appendTags:(NSArray*) tags {
    [Instabug appendTags:tags];
}

/**
 * Manually removes all tags of reported feedback, bug or crash.
 */
+ (void)resetTags {
    [Instabug resetTags];
}

/**
 * Gets all tags of reported feedback, bug or crash.
 * @return An array of tags.
 */
+ (NSArray*)getTags {
    return [Instabug getTags];
}

/**
 * Set custom user attributes that are going to be sent with each feedback, bug or crash.
 * @param value User attribute value.
 * @param key User attribute key.
 */
+ (void) setUserAttribute:(NSString*) value withKey:(NSString*) key {
    [Instabug setUserAttribute:value withKey:key];
}

/**
 * Removes a given key and its associated value from user attributes.
 * Does nothing if a key does not exist.
 * @param key The key to remove.
 */
+ (void) removeUserAttributeForKey:(NSString*) key {
    [Instabug removeUserAttributeForKey:key];
}

/**
 * Returns the user attribute associated with a given key.
 * @param key The key for which to return the corresponding value.
 * @return The value associated with aKey, or nil if no value is associated with aKey.
 */
+ (NSString*) getUserAttributeForKey:(NSString*) key {
     return [Instabug userAttributeForKey:key];
}

/**
 * Returns all user attributes.
 * @return A new dictionary containing all the currently set user attributes, or an empty dictionary if no user attributes have been set.
 */
+ (NSDictionary*) getUserAttributes {
    return Instabug.userAttributes;
}

/**
 * invoke sdk manually
 */
+ (void) show {
    [Instabug show];
}

/**
  * invoke sdk manually with desire invocation mode
  *
  * @param invocationMode the invocation mode
  * @param invocationOptions the array of invocation options
  */
+ (void) invokeWithMode:(NSString *)invocationMode options:(NSArray*)invocationOptionsArray {
    if ([invocationMode isEqualToString:@"InvocationMode.chats"]) {
         [IBGChats show];
         return;
    }
     if ([invocationMode isEqualToString:@"InvocationMode.replies"]) {
        [IBGReplies show];
        return;
    }
    NSDictionary *constants = [self constants];
    NSInteger invocationOptions = 0;
    for (NSString * invocationOption in invocationOptionsArray) {
        invocationOptions |= ((NSNumber *) constants[invocationOption]).integerValue;
    }
    NSInteger invocation = ((NSNumber *) constants[invocationMode]).integerValue;
    [IBGBugReporting showWithReportType:invocation options:invocationOptions];
}

 /**
  * Logs a user event that happens through the lifecycle of the application.
  * Logged user events are going to be sent with each report, as well as at the end of a session.
  *
  * @param name Event name.
  */
+ (void) logUserEventWithName:(NSString *) name {
    [Instabug logUserEventWithName:name];
}

/**
 * Overrides any of the strings shown in the SDK with custom ones.
 * Allows you to customize any of the strings shown to users in the SDK.
 * @param value String value to override the default one.
 * @param key Key of string to override. Use predefined keys like kIBGShakeStartAlertTextStringName,
 * kIBGEmailFieldPlaceholderStringName, etc.
 */
+ (void) setValue: (NSString*) value forStringWithKey: (NSString*) key {
    NSDictionary *constants = [self constants];
    [Instabug setValue:value forStringWithKey:constants[key]];
}

/**
  * Enable/disable session profiler
  *
  * @param sessionProfilerEnabled desired state of the session profiler feature
  */
+ (void)setSessionProfilerEnabled:(NSNumber *)sessionProfilerEnabled {
   BOOL boolValue = [sessionProfilerEnabled boolValue];
   [Instabug setSessionProfilerEnabled:boolValue];
}

/**
  * Set the primary color that the SDK will use to tint certain UI elements in the SDK
  *
  * @param color The value of the primary color 
  */
+ (void)setPrimaryColor:(NSNumber *)color {
  Instabug.tintColor = UIColorFromRGB([color longValue]);
}

 /**
  * Adds specific user data that you need to be added to the reports
  *
  * @param userData
  */
+ (void)setUserData:(NSString *)userData {
  [Instabug setUserData:userData];
}

/**
  * The file at filePath will be uploaded along upcoming reports with the name
  * fileNameWithExtension
  *
  * @param fileUri               the file uri
  */
+ (void)addFileAttachmentWithURL:(NSString *)fileURLString {
  [Instabug addFileAttachmentWithURL:[NSURL URLWithString:fileURLString]];
}

/**
  * The file at filePath will be uploaded along upcoming reports with the name
  * fileNameWithExtension
  *
  * @param data               the file data
  */
+ (void)addFileAttachmentWithData:(FlutterStandardTypedData *)data {
  [Instabug addFileAttachmentWithData:[data data]];
}

/**
  * Clears all Uris of the attached files.
  * The URIs which added via {@link Instabug#addFileAttachment} API not the physical files.
  */
+ (void)clearFileAttachments {
  [Instabug clearFileAttachments];
}

/**
  * Sets the welcome message mode to live, beta or disabled.
  *
  * @param welcomeMessageMode An enum to set the welcome message mode to
  *                          live, beta or disabled.
  */
+ (void)setWelcomeMessageMode:(NSString *)welcomeMessageMode {
    NSDictionary *constants = [self constants];
    NSInteger welcomeMode = ((NSNumber *) constants[welcomeMessageMode]).integerValue;
    [Instabug setWelcomeMessageMode:welcomeMode];
}

/**
  * Enables and disables manual invocation and prompt options for bug and feedback.
  * @param {boolean} isEnabled
  */
+ (void)setBugReportingEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGBugReporting.enabled = boolValue;
}

/**
  * Sets a block of code to be executed just before the SDK's UI is presented.
  * This block is executed on the UI thread. Could be used for performing any
  * UI changes before the SDK's UI is shown.
  */
+ (void)setOnInvokeCallback {
   IBGBugReporting.willInvokeHandler = ^{
             [channel invokeMethod:@"onInvokeCallback" arguments:nil];
        };
}

/**
  * Sets a block of code to be executed right after the SDK's UI is dismissed.
  * This block is executed on the UI thread. Could be used for performing any
  * UI changes after the SDK's UI is dismissed.
  */
+ (void)setOnDismissCallback {
   IBGBugReporting.didDismissHandler = ^(IBGDismissType dismissType, IBGReportType reportType) {            
            //parse dismiss type enum
            NSString* dismissTypeString;
            if (dismissType == IBGDismissTypeCancel) {
                dismissTypeString = @"CANCEL";
            } else if (dismissType == IBGDismissTypeSubmit) {
                dismissTypeString = @"SUBMIT";
            } else if (dismissType == IBGDismissTypeAddAttachment) {
                dismissTypeString = @"ADD_ATTACHMENT";
            }
            //parse report type enum
            NSString* reportTypeString;
            if (reportType == IBGReportTypeBug) {
                reportTypeString = @"bug";
            } else if (reportType == IBGReportTypeFeedback) {
                reportTypeString = @"feedback";
            } else {
                reportTypeString = @"other";
            }
            NSDictionary *result = @{ @"dismissType": dismissTypeString,
                                     @"reportType": reportTypeString};
             [channel invokeMethod:@"onDismissCallback" arguments:result];
        };
}

/**
  * Sets whether attachments in bug reporting and in-app messaging are enabled or not.
  *
  * @param  screenshot A boolean to enable or disable screenshot attachments.
  * @param  extraScreenShot A boolean to enable or disable extra screenshot attachments.
  * @param  galleryImage A boolean to enable or disable gallery image attachments.
  * @param  screenRecording A boolean to enable or disable screen recording attachments.
  */
+ (void)setEnabledAttachmentTypes:(NSNumber *)screenShot
                    extraScreenShot:(NSNumber *)extraScreenShot
                    galleryImage:(NSNumber *)galleryImage
                    screenRecording:(NSNumber *)screenRecording {
   IBGAttachmentType attachmentTypes = 0;
     if([screenShot boolValue]) {
         attachmentTypes = IBGAttachmentTypeScreenShot;
     }
     if([extraScreenShot boolValue]) {
         attachmentTypes |= IBGAttachmentTypeExtraScreenShot;
     }
     if([galleryImage boolValue]) {
         attachmentTypes |= IBGAttachmentTypeGalleryImage;
     }
     if([screenRecording boolValue]) {
         attachmentTypes |= IBGAttachmentTypeScreenRecording;
     }

     IBGBugReporting.enabledAttachmentTypes = attachmentTypes;
}

/**
  * Sets the events that invoke the feedback form.
  * Default is set by `Instabug.startWithToken`.
  * @param {invocationEvent} invocationEvent Array of events that invokes the
  * feedback form.
  */
+ (void)setInvocationEvents:(NSArray *)invocationEventsArray {
    NSDictionary *constants = [self constants];
    NSInteger invocationEvents = IBGInvocationEventNone;
    for (NSString * invocationEvent in invocationEventsArray) {
        invocationEvents |= ((NSNumber *) constants[invocationEvent]).integerValue;
    }
    IBGBugReporting.invocationEvents = invocationEvents;
}

/**
  * Sets the events that invoke the feedback form.
  * Default is set by `Instabug.startWithToken`.
  * @param {invocationEvent} invocationEvent Array of events that invokes the
  * feedback form.
  */
+ (void)setReportTypes:(NSArray*)reportTypesArray {
    NSDictionary *constants = [self constants];
    NSInteger reportTypes = 0;
    for (NSString * reportType in reportTypesArray) {
        reportTypes |= ((NSNumber *) constants[reportType]).integerValue;
    }
   [IBGBugReporting setPromptOptionsEnabledReportTypes: reportTypes];
}

/**
  * Sets whether the extended bug report mode should be disabled,
  * enabled with required fields,  or enabled with optional fields.
  *
  * @param extendedBugReportMode
  */
+ (void)setExtendedBugReportMode:(NSString *)extendedBugReportMode {
    NSDictionary *constants = [self constants];
    NSInteger extendedBugReportModeInt = ((NSNumber *) constants[extendedBugReportMode]).integerValue;
    IBGBugReporting.extendedBugReportMode = extendedBugReportModeInt;
}

/**
  * Sets the invocation options
  *
  * @param invocationOptions the array of invocation options
  */
+ (void)setInvocationOptions:(NSArray *)invocationOptionsArray {
    NSDictionary *constants = [self constants];
    NSInteger invocationOptions = 0;
    for (NSString * invocationOption in invocationOptionsArray) {
        invocationOptions |= ((NSNumber *) constants[invocationOption]).integerValue;
    }
    IBGBugReporting.invocationOptions = invocationOptions;
}

/**
  * Sets the invocation options
  *
  * @param invocationOptions the array of invocation options
  */
+ (void)showBugReportingWithReportTypeAndOptions:(NSString*)reportType options:(NSArray *)invocationOptionsArray  {
    NSDictionary *constants = [self constants];
    NSInteger invocationOptions = 0;
    for (NSString * invocationOption in invocationOptionsArray) {
        invocationOptions |= ((NSNumber *) constants[invocationOption]).integerValue;
    }
    NSInteger reportTypeInt = ((NSNumber *) constants[reportType]).integerValue;
    [IBGBugReporting showWithReportType:reportTypeInt options:invocationOptions];
}

/**
  * Show any valid survey if exist
  *
  * @param {isEnabled} boolean
  */
+ (void)setSurveysEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGSurveys.enabled = boolValue;
}

/**
  * Set Surveys auto-showing state, default state auto-showing enabled
  *
  * @param {isEnabled} whether Surveys should be auto-showing or not
  */
+ (void)setAutoShowingSurveysEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGSurveys.autoShowingEnabled = boolValue;
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
  * Sets the runnable that gets executed just after showing any valid survey<br/>
  * WARNING: This runs on your application's main UI thread. Please do not include
  * any blocking operations to avoid ANRs.
  *
  */
+ (void)setOnDismissSurveyCallback {
  IBGSurveys.didDismissSurveyHandler = ^{
            [channel invokeMethod:@"onDismissSurveyCallback" arguments:nil];
        };
}

/**
  * Sets a block of code to be executed right after the SDK's UI is dismissed.
  * This block is executed on the UI thread. Could be used for performing any
  * UI changes after the SDK's UI is dismissed.
  */
+ (void)getAvailableSurveys {
     NSArray<IBGSurvey *> *surveys = [IBGSurveys availableSurveys];
     NSMutableArray <NSString *> *surveysArray = [[NSMutableArray alloc] init];
     for (IBGSurvey * survey in surveys) {
        [surveysArray addObject:survey.title];
    }
    NSArray *result = [surveysArray copy];
    [channel invokeMethod:@"availableSurveysCallback" arguments:result];
}


/**
  * Set Surveys auto-showing state, default state auto-showing enabled
  *
  * @param {isEnabled} whether Surveys should be auto-showing or not
  */
+ (void)setShouldShowSurveysWelcomeScreen:(NSNumber *)shouldShowWelcomeScreen {
   BOOL boolValue = [shouldShowWelcomeScreen boolValue];
   IBGSurveys.shouldShowWelcomeScreen = boolValue;
}

/**
  * Show any valid survey if exist
  *
  * @return true if a valid survey was shown otherwise false
  */
+ (void)showSurveysIfAvailable {
   [IBGSurveys showSurveyIfAvailable];
}

/**
  * Shows survey with a specific token.
  * Does nothing if there are no available surveys with that specific token.
  * Answered and cancelled surveys won't show up again.
  *
  * @param surveyToken A String with a survey token.
  */
+ (void)showSurveyWithToken:(NSString *)surveyToken {
   [IBGSurveys showSurveyWithToken:surveyToken];
}

/**
  * Returns true if the survey with a specific token was answered before.
  * Will return false if the token does not exist or if the survey was not answered before.
  *
  * @param surveyToken          the attribute key as string
  * @return the desired value of whether the user has responded to the survey or not.
  */
+ (void)hasRespondedToSurveyWithToken:(NSString *)surveyToken {
    bool hasResponded = [IBGSurveys hasRespondedToSurveyWithToken:surveyToken];
    NSNumber *boolNumber = [NSNumber numberWithBool:hasResponded];
    [channel invokeMethod:@"hasRespondedToSurveyCallback" arguments:boolNumber];
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

      @"InvocationMode.bug": @(IBGBugReportingReportTypeBug),
      @"InvocationMode.feedback": @(IBGBugReportingReportTypeFeedback),

      @"InvocationOption.commentFieldRequired": @(IBGBugReportingOptionCommentFieldRequired),
      @"InvocationOption.disablePostSendingDialog": @(IBGBugReportingOptionDisablePostSendingDialog),
      @"InvocationOption.emailFieldHidden": @(IBGBugReportingOptionEmailFieldHidden),
      @"InvocationOption.emailFieldOptional": @(IBGBugReportingOptionEmailFieldOptional),

      @"Locale.arabic": @(IBGLocaleArabic),
      @"Locale.chineseSimplified": @(IBGLocaleChineseSimplified),
      @"Locale.chineseTraditional": @(IBGLocaleChineseTraditional),
      @"Locale.czech": @(IBGLocaleCzech),
      @"Locale.danish": @(IBGLocaleDanish),
      @"Locale.dutch": @(IBGLocaleDutch),
      @"Locale.english": @(IBGLocaleEnglish),
      @"Locale.french": @(IBGLocaleFrench),
      @"Locale.german": @(IBGLocaleGerman),
      @"Locale.italian": @(IBGLocaleItalian),
      @"Locale.japanese": @(IBGLocaleJapanese),
      @"Locale.korean": @(IBGLocaleKorean),
      @"Locale.polish": @(IBGLocalePolish),
      @"Locale.portugueseBrazil": @(IBGLocalePortugueseBrazil),
      @"Locale.russian": @(IBGLocaleRussian),
      @"Locale.spanish": @(IBGLocaleSpanish),
      @"Locale.swedish": @(IBGLocaleSwedish),
      @"Locale.turkish": @(IBGLocaleTurkish),
      
      @"IBGCustomTextPlaceHolderKey.shakeHint": kIBGShakeStartAlertTextStringName,
      @"IBGCustomTextPlaceHolderKey.swipeHint": kIBGEdgeSwipeStartAlertTextStringName,
      @"IBGCustomTextPlaceHolderKey.invalidEmailMessage": kIBGInvalidEmailMessageStringName,
      @"IBGCustomTextPlaceHolderKey.invalidCommentMessage": kIBGInvalidCommentMessageStringName,
      @"IBGCustomTextPlaceHolderKey.invocationHeader": kIBGInvocationTitleStringName,
      @"IBGCustomTextPlaceHolderKey.startChats": kIBGChatsTitleStringName,
      @"IBGCustomTextPlaceHolderKey.reportBug": kIBGReportBugStringName,
      @"IBGCustomTextPlaceHolderKey.reportFeedback": kIBGReportFeedbackStringName,
      @"IBGCustomTextPlaceHolderKey.emailFieldHint": kIBGEmailFieldPlaceholderStringName,
      @"IBGCustomTextPlaceHolderKey.commentFieldHintForBugReport": kIBGCommentFieldPlaceholderForBugReportStringName,
      @"IBGCustomTextPlaceHolderKey.commentFieldHintForFeedback": kIBGCommentFieldPlaceholderForFeedbackStringName,
      @"IBGCustomTextPlaceHolderKey.addVoiceMessage": kIBGAddVoiceMessageStringName,
      @"IBGCustomTextPlaceHolderKey.addImageFromGallery": kIBGAddImageFromGalleryStringName,
      @"IBGCustomTextPlaceHolderKey.addExtraScreenshot": kIBGAddExtraScreenshotStringName,
      @"IBGCustomTextPlaceHolderKey.conversationsListTitle": kIBGChatsTitleStringName,
      @"IBGCustomTextPlaceHolderKey.audioRecordingPermissionDenied": kIBGAudioRecordingPermissionDeniedTitleStringName,
      @"IBGCustomTextPlaceHolderKey.conversationTextFieldHint": kIBGChatReplyFieldPlaceholderStringName,
      @"IBGCustomTextPlaceHolderKey.bugReportHeader": kIBGReportBugStringName,
      @"IBGCustomTextPlaceHolderKey.feedbackReportHeader": kIBGReportFeedbackStringName,
      @"IBGCustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord": kIBGRecordingMessageToHoldTextStringName,
      @"IBGCustomTextPlaceHolderKey.voiceMessageReleaseToAttach": kIBGRecordingMessageToReleaseTextStringName,
      @"IBGCustomTextPlaceHolderKey.reportSuccessfullySent": kIBGThankYouAlertMessageStringName,
      @"IBGCustomTextPlaceHolderKey.successDialogHeader": kIBGThankYouAlertTitleStringName,
      @"IBGCustomTextPlaceHolderKey.addVideo": kIBGAddScreenRecordingMessageStringName,
      @"IBGCustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle": kIBGBetaWelcomeMessageWelcomeStepTitle,
      @"IBGCustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent": kIBGBetaWelcomeMessageWelcomeStepContent,
      @"IBGCustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle": kIBGBetaWelcomeMessageHowToReportStepTitle,
      @"IBGCustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent": kIBGBetaWelcomeMessageHowToReportStepContent,
      @"IBGCustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle": kIBGBetaWelcomeMessageFinishStepTitle,
      @"IBGCustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent": kIBGBetaWelcomeMessageFinishStepContent,
      @"IBGCustomTextPlaceHolderKey.liveWelcomeMessageTitle": kIBGLiveWelcomeMessageTitle,
      @"IBGCustomTextPlaceHolderKey.liveWelcomeMessageContent": kIBGLiveWelcomeMessageContent,

      @"ReportType.bug": @(IBGBugReportingReportTypeBug),
      @"ReportType.feedback": @(IBGBugReportingReportTypeFeedback),

      @"ExtendedBugReportMode.enabledWithRequiredFields": @(IBGExtendedBugReportModeEnabledWithRequiredFields),
      @"ExtendedBugReportMode.enabledWithOptionalFields": @(IBGExtendedBugReportModeEnabledWithOptionalFields),
      @"ExtendedBugReportMode.disabled": @(IBGExtendedBugReportModeDisabled),
  };
};

@end
