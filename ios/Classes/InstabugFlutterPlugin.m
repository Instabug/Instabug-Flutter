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
        NSDictionary *argumentsDictionary = call.arguments;
        for (id key in argumentsDictionary) {
          NSObject *arg = [argumentsDictionary objectForKey:key];
          [inv setArgument:&(arg) atIndex:index];
          index++;
        }        
        [inv invoke];
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
+ (void)logInfo:(NSString *)log {
  [IBGLog logInfo:log];
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
