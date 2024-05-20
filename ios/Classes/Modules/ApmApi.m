#import "Instabug.h"
#import "ApmApi.h"
#import "ArgsRegistry.h"
#import "IBGAPM+PrivateAPIs.h"
#import "IBGTimeIntervalUnits.h"

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

- (void)isEnabledWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
    BOOL isEnabled = IBGAPM.enabled;
    
    NSNumber *isEnabledNumber = @(isEnabled);
    
    completion(isEnabledNumber, nil);
}

- (void)setScreenLoadingEnabledIsEnabled:(nonnull NSNumber *)isEnabled error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM setScreenLoadingEnabled:[isEnabled boolValue]];
}


- (void)isScreenLoadingEnabledWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
    BOOL isScreenLoadingEnabled = IBGAPM.screenLoadingEnabled;
    NSNumber *isEnabledNumber = @(isScreenLoadingEnabled);
    completion(isEnabledNumber, nil);
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

- (void)startFlowName:(nonnull NSString *)name error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM startFlowWithName:name];
}

- (void)setFlowAttributeName:(nonnull NSString *)name key:(nonnull NSString *)key value:(nullable NSString *)value error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM setAttributeForFlowWithName:name key:key value:value];
}

- (void)endFlowName:(nonnull NSString *)name error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM endFlowWithName:name];
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


- (void)startCpUiTraceScreenName:(nonnull NSString *)screenName microTimeStamp:(nonnull NSNumber *)microTimeStamp traceId:(nonnull NSNumber *)traceId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSTimeInterval startTimeStampMUS = [microTimeStamp doubleValue];
    [IBGAPM startUITraceCPWithName:screenName startTimestampMUS:startTimeStampMUS];
}



- (void)reportScreenLoadingCPStartTimeStampMicro:(nonnull NSNumber *)startTimeStampMicro durationMicro:(nonnull NSNumber *)durationMicro uiTraceId:(nonnull NSNumber *)uiTraceId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSTimeInterval startTimeStampMicroMUS = [startTimeStampMicro doubleValue];
    NSTimeInterval durationMUS = [durationMicro doubleValue];
    [IBGAPM reportScreenLoadingCPWithStartTimestampMUS:startTimeStampMicroMUS durationMUS:durationMUS];
}

- (void)endScreenLoadingCPTimeStampMicro:(nonnull NSNumber *)timeStampMicro uiTraceId:(nonnull NSNumber *)uiTraceId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSTimeInterval endScreenLoadingCPWithEndTimestampMUS = [timeStampMicro doubleValue];
    [IBGAPM endScreenLoadingCPWithEndTimestampMUS:endScreenLoadingCPWithEndTimestampMUS];
}


@end
