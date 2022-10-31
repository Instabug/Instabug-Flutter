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
    IBGAPM.appLaunchEnabled = [isEnabled boolValue];
}

- (void)setAutoUITraceEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.autoUITraceEnabled = [isEnabled boolValue];
}

- (void)setLogLevelLevel:(NSString *)level error:(FlutterError *_Nullable *_Nonnull)error {
    IBGLogLevel resolvedLevel = (ArgsRegistry.logLevels[level]).integerValue;
    IBGAPM.logLevel = resolvedLevel;
}

- (nullable NSString *)startExecutionTraceId:(NSString *)id name:(NSString *)name error:(FlutterError *_Nullable *_Nonnull)error {
    IBGExecutionTrace *trace = [IBGAPM startExecutionTraceWithName:name];

    if (trace != nil) {
        [traces setObject:trace forKey:id];
        return id;
    } else {
        return nil;
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
