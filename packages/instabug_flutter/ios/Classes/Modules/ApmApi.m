#import "Instabug.h"
#import "ApmApi.h"
#import "ArgsRegistry.h"

void InitApmApi(id<FlutterBinaryMessenger> messenger) {
    ApmApi *api = [[ApmApi alloc] init];
    ApmHostApiSetup(messenger, api);
}

@implementation ApmApi

NSMutableDictionary *traces;

- (instancetype)init {
    self = [super init];
    traces = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.enabled = [isEnabled boolValue];
}

- (void)setColdAppLaunchEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.coldAppLaunchEnabled = [isEnabled boolValue];
}

- (void)setAutoUITraceEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.autoUITraceEnabled = [isEnabled boolValue];
}

- (void)startExecutionTraceId:(NSString *)id name:(NSString *)name completion:(void(^)(NSString *_Nullable, FlutterError *_Nullable))completion {
    IBGExecutionTrace *trace = [IBGAPM startExecutionTraceWithName:name];

    if (trace != nil) {
        [traces setObject:trace forKey:id];
        return completion(id, nil);
    } else {
        return completion(nil, nil);
    }
}

- (void)setExecutionTraceAttributeId:(NSString *)id key:(NSString *)key value:(NSString *)value error:(FlutterError *_Nullable *_Nonnull)error {
    IBGExecutionTrace *trace = [traces objectForKey:id];

    if (trace != nil) {
        [trace setAttributeWithKey:key value:value];
    }
}

- (void)endExecutionTraceId:(NSString *)id error:(FlutterError *_Nullable *_Nonnull)error {
    IBGExecutionTrace *trace = [traces objectForKey:id];

    if (trace != nil) {
        [trace end];
    }
}

- (void)startUITraceName:(NSString *)name error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGAPM startUITraceWithName:name];
}

- (void)endUITraceWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGAPM endUITrace];
}

- (void)endAppLaunchWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGAPM endAppLaunch];
}

- (void)networkLogAndroidData:(NSDictionary<NSString *, id> *)data error:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}

@end
