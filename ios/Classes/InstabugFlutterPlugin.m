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
  if ([@"startWithToken:invocationEvents" isEqualToString:call.method]) {
    NSDictionary *invocationEventsMap = @{
      @"InvocationEvent.shake": @(IBGInvocationEventShake),
      @"InvocationEvent.screenshot": @(IBGInvocationEventScreenshot),
      @"InvocationEvent.twoFingersSwipeLeft": @(IBGInvocationEventTwoFingersSwipeLeft),
      @"InvocationEvent.rightEdgePan": @(IBGInvocationEventRightEdgePan),
      @"InvocationEvent.floatingButton": @(IBGInvocationEventFloatingButton),
      @"InvocationEvent.none": @(IBGInvocationEventNone),
    };

    NSString *token = call.arguments[@"token"];
  
    NSInteger invocationEvents = IBGInvocationEventNone;
    for (NSString * invocationEvent in call.arguments[@"invocationEvents"]) {
        invocationEvents |= ((NSNumber *) invocationEventsMap[invocationEvent]).integerValue;
    }

    [Instabug startWithToken:token invocationEvents:invocationEvents];
    result(nil);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
