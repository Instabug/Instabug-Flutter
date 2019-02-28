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
