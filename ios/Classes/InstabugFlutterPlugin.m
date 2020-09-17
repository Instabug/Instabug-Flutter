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
    SEL setPrivateApiSEL = NSSelectorFromString(@"setCurrentPlatform:");
    if ([[Instabug class] respondsToSelector:setPrivateApiSEL]) {
        NSInteger *platformID = IBGPlatformFlutter;
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[Instabug class] methodSignatureForSelector:setPrivateApiSEL]];
        [inv setSelector:setPrivateApiSEL];
        [inv setTarget:[Instabug class]];
        [inv setArgument:&(platformID) atIndex:2];
        [inv invoke];
    }

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
    IBGBugReporting.bugReportingOptions = invocationOptions;
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
  * Sets url for the published iOS app on AppStore
  *
  * @param {appStoreURL} String
  */
+ (void)setAppStoreURL:(NSString *)appStoreURL {
   IBGSurveys.appStoreURL = appStoreURL;
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
    [IBGSurveys availableSurveysWithCompletionHandler:^(NSArray<IBGSurvey *> *availableSurveys) {
        NSMutableArray<NSDictionary*>* mappedSurveys = [[NSMutableArray alloc] init];
        for (IBGSurvey* survey in availableSurveys) {
            [mappedSurveys addObject:@{@"title": survey.title }];
        }
        NSArray *result = [mappedSurveys copy];
        [channel invokeMethod:@"availableSurveysCallback" arguments:result];
    }];
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

/**
  * Shows the UI for feature requests list
  */
+ (void)showFeatureRequests {
   [IBGFeatureRequests show];
}

/**
  * Sets whether email field is required or not when submitting
  * new-feature-request/new-comment-on-feature
  *
  * @param isEmailRequired set true to make email field required
  * @param actionTypes Bitwise-or of actions
  */
+ (void)setEmailFieldRequiredForFeatureRequests:(NSNumber*)isEmailFieldRequired forAction:(NSArray *)actionTypesArray  {
    NSDictionary *constants = [self constants];
    NSInteger actionTypes = 0;
    for (NSString * actionType in actionTypesArray) {
        actionTypes |= ((NSNumber *) constants[actionType]).integerValue;
    }
    BOOL boolValue = [isEmailFieldRequired boolValue];
    [IBGFeatureRequests setEmailFieldRequired:boolValue forAction:actionTypes];
}

/**
  * Manual invocation for chats view. 
  */
+ (void)showChats {
   [IBGChats show];
}

/**
  * Enables and disables everything related to creating new chats.
  * @param {boolean} isEnabled 
  */
+ (void)setChatsEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGChats.enabled = boolValue;
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
 * Sets the threshold value of the shake gesture for iPhone/iPod Touch
 * Default for iPhone is 2.5.
 * @param  iPhoneShakingThreshold Threshold for iPhone.
 */
+ (void)setShakingThresholdForiPhone:(NSNumber *)iPhoneShakingThreshold {
    double threshold = [iPhoneShakingThreshold doubleValue];
    IBGBugReporting.shakingThresholdForiPhone = threshold;

}

/**
 * Sets the threshold value of the shake gesture for iPad.
 * Default for iPad is 0.6.
 * @param iPadShakingThreshold Threshold for iPad.
 */
+ (void)setShakingThresholdForiPad:(NSNumber *)iPadShakingThreshold {
    double threshold = [iPadShakingThreshold doubleValue];
    IBGBugReporting.shakingThresholdForiPad = threshold;
}

/**
 * Extracts HTTP connection properties. Request method, Headers, Date, Url and Response code
 *
 * @param networkData the NSDictionary containing all HTTP connection properties
 */
+ (void)networkLog:(NSDictionary *) networkData {
    [IBGLog clearAllLogs];

    NSString* url = networkData[@"url"];
    NSString* method = networkData[@"method"];
    NSString* requestBody = networkData[@"requestBody"];
    NSString* responseBody = networkData[@"responseBody"];
    int32_t responseCode = [networkData[@"responseCode"] integerValue];
    NSDictionary* requestHeaders = networkData[@"requestHeaders"];
    if ([requestHeaders count] == 0) {
        requestHeaders = @{};
    }
    NSDictionary* responseHeaders = networkData[@"responseHeaders"];
    NSString* contentType = @"application/json";
    double duration = [networkData[@"duration"] doubleValue];

    for(NSString *key in [requestHeaders allKeys]) {
        NSLog(@"key: %@", key);
        NSLog(@"value: %@",[requestHeaders objectForKey:key]);
    }
    
    SEL networkLogSEL = NSSelectorFromString(@"addNetworkLogWithUrl:method:requestBody:responseBody:responseCode:requestHeaders:responseHeaders:contentType:duration:");

    if([[IBGNetworkLogger class] respondsToSelector:networkLogSEL]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[IBGNetworkLogger class] methodSignatureForSelector:networkLogSEL]];
        [inv setSelector:networkLogSEL];
        [inv setTarget:[IBGNetworkLogger class]];

        [inv setArgument:&(url) atIndex:2];
        [inv setArgument:&(method) atIndex:3];
        [inv setArgument:&(requestBody) atIndex:4];
        [inv setArgument:&(responseBody) atIndex:5];
        [inv setArgument:&(responseCode) atIndex:6];
        [inv setArgument:&(requestHeaders) atIndex:7];
        [inv setArgument:&(responseHeaders) atIndex:8];
        [inv setArgument:&(contentType) atIndex:9];
        [inv setArgument:&(duration) atIndex:10];

        [inv invoke];
    }
}

/**
  * Enables and disables automatic crash reporting.
  * @param {boolean} isEnabled
  */
+ (void)setCrashReportingEnabled:(NSNumber *)isEnabled {
   BOOL boolValue = [isEnabled boolValue];
   IBGCrashReporting.enabled = boolValue;
}

+ (void)sendJSCrashByReflection:(NSString *) jsonString handled: (NSNumber *) isHandled{
     NSError *jsonError;
     NSData *objectData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
     NSDictionary *stackTrace = [NSJSONSerialization JSONObjectWithData:objectData
                                                          options:NSJSONReadingMutableContainers
                                                            error:&jsonError];
    SEL reportCrashWithStackTraceSEL = NSSelectorFromString(@"reportCrashWithStackTrace:handled:");
      if ([[Instabug class] respondsToSelector:reportCrashWithStackTraceSEL]) {
            [[Instabug class] performSelector:reportCrashWithStackTraceSEL withObject:stackTrace withObject:isHandled];
        }
    
}

  /** Reports that the screen has been changed (Repro Steps) the screen sent to this method will be the 'current view' on the dashboard
  *
  * @param screenName string containing the screen name
  *
  */
+ (void) reportScreenChange:(NSString *)screenName {
   SEL setPrivateApiSEL = NSSelectorFromString(@"logViewDidAppearEvent:");
    if ([[Instabug class] respondsToSelector:setPrivateApiSEL]) {
        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[[Instabug class] methodSignatureForSelector:setPrivateApiSEL]];
        [inv setSelector:setPrivateApiSEL];
        [inv setTarget:[Instabug class]];
        [inv setArgument:&(screenName) atIndex:2];
        [inv invoke];
    }
}

/**
  * Sets the Repro Steps mode
  *
  * @param reproStepsMode string repro step mode
  *
  */
+ (void) setReproStepsMode:(NSString *)reproStepsMode {
    NSDictionary *constants = [self constants];
    NSInteger reproMode = ((NSNumber *) constants[reproStepsMode]).integerValue;
    [Instabug setReproStepsMode:reproMode];
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
      @"IBGLocale.russian": @(IBGLocaleRussian),
      @"IBGLocale.spanish": @(IBGLocaleSpanish),
      @"IBGLocale.swedish": @(IBGLocaleSwedish),
      @"IBGLocale.turkish": @(IBGLocaleTurkish),
      
      @"CustomTextPlaceHolderKey.shakeHint": kIBGShakeStartAlertTextStringName,
      @"CustomTextPlaceHolderKey.swipeHint": kIBGEdgeSwipeStartAlertTextStringName,
      @"CustomTextPlaceHolderKey.invalidEmailMessage": kIBGInvalidEmailMessageStringName,
      @"CustomTextPlaceHolderKey.invalidCommentMessage": kIBGInvalidCommentMessageStringName,
      @"CustomTextPlaceHolderKey.invocationHeader": kIBGInvocationTitleStringName,
      @"CustomTextPlaceHolderKey.startChats": kIBGChatsTitleStringName,
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
      @"CustomTextPlaceHolderKey.bugReportHeader": kIBGReportBugStringName,
      @"CustomTextPlaceHolderKey.feedbackReportHeader": kIBGReportFeedbackStringName,
      @"CustomTextPlaceHolderKey.voiceMessagePressAndHoldToRecord": kIBGRecordingMessageToHoldTextStringName,
      @"CustomTextPlaceHolderKey.voiceMessageReleaseToAttach": kIBGRecordingMessageToReleaseTextStringName,
      @"CustomTextPlaceHolderKey.reportSuccessfullySent": kIBGThankYouAlertMessageStringName,
      @"CustomTextPlaceHolderKey.successDialogHeader": kIBGThankYouAlertTitleStringName,
      @"CustomTextPlaceHolderKey.addVideo": kIBGAddScreenRecordingMessageStringName,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepTitle": kIBGBetaWelcomeMessageWelcomeStepTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageWelcomeStepContent": kIBGBetaWelcomeMessageWelcomeStepContent,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepTitle": kIBGBetaWelcomeMessageHowToReportStepTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageHowToReportStepContent": kIBGBetaWelcomeMessageHowToReportStepContent,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepTitle": kIBGBetaWelcomeMessageFinishStepTitle,
      @"CustomTextPlaceHolderKey.betaWelcomeMessageFinishStepContent": kIBGBetaWelcomeMessageFinishStepContent,
      @"CustomTextPlaceHolderKey.liveWelcomeMessageTitle": kIBGLiveWelcomeMessageTitle,
      @"CustomTextPlaceHolderKey.liveWelcomeMessageContent": kIBGLiveWelcomeMessageContent,

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
      @"ReproStepsMode.enabledWithNoScreenshots": @(IBGUserStepsModeEnabledWithNoScreenshots)
  };
};

@end
