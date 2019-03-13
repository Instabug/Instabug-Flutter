#import "InstabugFlutterPlugin.h"
#import "Instabug.h"

@implementation InstabugFlutterPlugin


+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
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
  * @param {token} token The token that identifies the app
  * @param {invocationEvents} invocationEvents The events that invoke
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
    if ([invocationMode isEqualToString:@"InvocationMode.CHATS"]) {
         [IBGChats show];
         return;
    }
     if ([invocationMode isEqualToString:@"InvocationMode.REPLIES"]) {
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

      @"InvocationMode.BUG": @(IBGBugReportingReportTypeBug),
      @"InvocationMode.FEEDBACK": @(IBGBugReportingReportTypeFeedback),

      @"InvocationOption.COMMENT_FIELD_REQUIRED": @(IBGBugReportingOptionCommentFieldRequired),
      @"InvocationOption.DISABLE_POST_SENDING_DIALOG": @(IBGBugReportingOptionDisablePostSendingDialog),
      @"InvocationOption.EMAIL_FIELD_HIDDEN": @(IBGBugReportingOptionEmailFieldHidden),
      @"InvocationOption.EMAIL_FIELD_OPTIONAL": @(IBGBugReportingOptionEmailFieldOptional),

      @"Locale.Arabic": @(IBGLocaleArabic),
      @"Locale.ChineseSimplified": @(IBGLocaleChineseSimplified),
      @"Locale.ChineseTraditional": @(IBGLocaleChineseTraditional),
      @"Locale.Czech": @(IBGLocaleCzech),
      @"Locale.Danish": @(IBGLocaleDanish),
      @"Locale.Dutch": @(IBGLocaleDutch),
      @"Locale.English": @(IBGLocaleEnglish),
      @"Locale.French": @(IBGLocaleFrench),
      @"Locale.German": @(IBGLocaleGerman),
      @"Locale.Italian": @(IBGLocaleItalian),
      @"Locale.Japanese": @(IBGLocaleJapanese),
      @"Locale.Korean": @(IBGLocaleKorean),
      @"Locale.Polish": @(IBGLocalePolish),
      @"Locale.PortugueseBrazil": @(IBGLocalePortugueseBrazil),
      @"Locale.Russian": @(IBGLocaleRussian),
      @"Locale.Spanish": @(IBGLocaleSpanish),
      @"Locale.Swedish": @(IBGLocaleSwedish),
      @"Locale.Turkish": @(IBGLocaleTurkish),
  };
};

@end
