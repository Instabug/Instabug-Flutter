#import "InstabugFlutterPlugin.h"
#import "Instabug.h"

@implementation InstabugFlutterPlugin

+ (NSDictionary *) constants {
  return @{
      @"InvocationEvent.shake": @(IBGInvocationEventShake),
      @"InvocationEvent.screenshot": @(IBGInvocationEventScreenshot),
      @"InvocationEvent.twoFingersSwipeLeft": @(IBGInvocationEventTwoFingersSwipeLeft),
      @"InvocationEvent.floatingButton": @(IBGInvocationEventFloatingButton),
      @"InvocationEvent.none": @(IBGInvocationEventNone),
  };
};

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
        int index = 2;
        NSDictionary *myDict = call.arguments;
        for(id key in myDict) {
          NSObject *arg = [myDict objectForKey:key];
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
  * starts the SDK with the desired
  * @param {token} token The token that identifies the app, you can find
  * it on your dashboard.
  * @param {invocationEvents} invocationEvents The events that invoke
  * the SDK's UI.
  */
+ (void)startWithToken:(NSString *)token invocationEvents:(NSArray*)invocationEventsArray {
    NSDictionary *invocationEventsMap = [self constants];
    NSInteger invocationEvents = IBGInvocationEventNone;
    for (NSString * invocationEvent in invocationEventsArray) {
        invocationEvents |= ((NSNumber *) invocationEventsMap[invocationEvent]).integerValue;
    }
    [Instabug startWithToken:token invocationEvents:invocationEvents];
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
