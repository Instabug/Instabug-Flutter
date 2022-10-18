#import "Instabug.h"
#import "ApmApiImpl.h"
#import "InstabugFlutterPlugin.h"

@implementation ApmApiImpl

NSMutableDictionary *traces;

- (instancetype)init {
    self = [super init];
    traces = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGAPM.enabled = boolValue;
}

- (void)setColdAppLaunchEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGAPM.appLaunchEnabled = boolValue;
}

- (void)setAutoUITraceEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGAPM.autoUITraceEnabled = boolValue;
}

- (void)setLogLevelLevel:(NSString *)level error:(FlutterError *_Nullable *_Nonnull)error {
    NSDictionary *constants = [InstabugFlutterPlugin constants];
    NSInteger logLevelValue = ((NSNumber *) constants[level]).integerValue;
    IBGAPM.logLevel = logLevelValue;
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
