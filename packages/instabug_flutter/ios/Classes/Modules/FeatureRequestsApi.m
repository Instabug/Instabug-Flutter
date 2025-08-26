#import "InstabugSDK.h"
#import "FeatureRequestsApi.h"
#import "ArgsRegistry.h"

extern void InitFeatureRequestsApi(id<FlutterBinaryMessenger> messenger) {
    FeatureRequestsApi *api = [[FeatureRequestsApi alloc] init];
    FeatureRequestsHostApiSetup(messenger, api);
}

@implementation FeatureRequestsApi

- (void)showWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGFeatureRequests show];
}

- (void)setEmailFieldRequiredIsRequired:(NSNumber *)isRequired actionTypes:(NSArray<NSString *> *)actionTypes error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAction resolvedTypes = 0;

    for (NSString *type in actionTypes) {
        resolvedTypes |= (ArgsRegistry.actionTypes[type]).integerValue;
    }

    [IBGFeatureRequests setEmailFieldRequired:[isRequired boolValue] forAction:resolvedTypes];
}

@end
