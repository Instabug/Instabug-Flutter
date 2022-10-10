#import <Foundation/Foundation.h>
#import "Generated/InstabugPigeon.h"
#import "Instabug.h"
#import "InstabugApiImpl.h"

@implementation InstabugApiImpl

- (void)startToken:(NSString *)token invocationEvents:(NSArray<NSString *> *)invocationEvents error:(FlutterError *_Nullable *_Nonnull)error {
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
    NSInteger events = 0;
    for (NSString * invocationEvent in invocationEvents) {
        events |= ((NSNumber *) constants[invocationEvent]).integerValue;
    }
    if (events == 0) {
        events = IBGInvocationEventNone;
    }

    [Instabug startWithToken:token invocationEvents:events];
}

- (NSDictionary *)constants {
  return @{
      @"InvocationEvent.shake": @(IBGInvocationEventShake),
      @"InvocationEvent.screenshot": @(IBGInvocationEventScreenshot),
      @"InvocationEvent.twoFingersSwipeLeft": @(IBGInvocationEventTwoFingersSwipeLeft),
      @"InvocationEvent.floatingButton": @(IBGInvocationEventFloatingButton),
      @"InvocationEvent.none": @(IBGInvocationEventNone)
  };
};


@end
