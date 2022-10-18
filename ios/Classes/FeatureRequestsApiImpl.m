#import "Instabug.h"
#import "FeatureRequestsApiImpl.h"
#import "InstabugFlutterPlugin.h"

@implementation FeatureRequestsApiImpl

- (void)showWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGFeatureRequests show];
}

- (void)setEmailFieldRequiredIsRequired:(NSNumber *)isRequired actionTypes:(NSArray<NSString *> *)actionTypes error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger types = 0;
    for (NSString * actionType in actionTypes) {
        types |= ((NSNumber *) constants[actionType]).integerValue;
    }
    
    BOOL boolValue = [isRequired boolValue];
    [IBGFeatureRequests setEmailFieldRequired:boolValue forAction:types];
}


@end
