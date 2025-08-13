#import "InstabugSDK.h"
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

// This method is setting the enabled state of the APM feature. It
// takes a boolean value wrapped in an NSNumber object as a parameter and sets the APM enabled state
// based on that value. The `IBGAPM.enabled` property is being set to the boolean value extracted from
// the NSNumber parameter using the `boolValue` method.
- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.enabled = [isEnabled boolValue];
}

// This method is used to check if the APM feature is enabled.
// `completion` handler is a way for implementing callback functionality.
- (void)isEnabledWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
    BOOL isEnabled = IBGAPM.enabled;
    
    NSNumber *isEnabledNumber = @(isEnabled);
    
    completion(isEnabledNumber, nil);
}

// This method is setting the enabled state of the screen loading feature in the APM module.
// It takes a boolean value wrapped in an NSNumber object as a parameter.
//The method then extracts the boolean value from the NSNumber parameter using the
// `boolValue` method and sets the screen loading enabled state in the APM module based on that value.
- (void)setScreenLoadingEnabledIsEnabled:(nonnull NSNumber *)isEnabled error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM setScreenLoadingEnabled:[isEnabled boolValue]];
}


// checks whether the screen loading feature is enabled.
//`completion` handler is a way for implementing callback functionality.
- (void)isScreenLoadingEnabledWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
    BOOL isScreenLoadingEnabled = IBGAPM.screenLoadingEnabled;
    NSNumber *isEnabledNumber = @(isScreenLoadingEnabled);
    completion(isEnabledNumber, nil);
}

// This method is setting the enabled state of the cold app launch feature in the APM module. It takes
// a boolean value wrapped in an NSNumber object as a parameter. The method then extracts the boolean
// value from the NSNumber parameter using the `boolValue` method and sets the cold app launch enabled
// state in the APM module based on that value.
- (void)setColdAppLaunchEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.coldAppLaunchEnabled = [isEnabled boolValue];
}

// This method is setting the enabled state of the auto UI trace feature in the APM module. It takes a
// boolean value wrapped in an NSNumber object as a parameter. The method then extracts the boolean
// value from the NSNumber parameter using the `boolValue` method and sets the auto UI trace enabled
// state in the APM module based on that value.
- (void)setAutoUITraceEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    IBGAPM.autoUITraceEnabled = [isEnabled boolValue];
}


// This method is responsible for starting a flow with the given `name`. This functionality is used to
// track and monitor the performance of specific flows within the application.
- (void)startFlowName:(nonnull NSString *)name error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM startFlowWithName:name];
}

// This method sets an attribute for a specific flow identified by the
// provided `name`. It takes three parameters:
// 1. `name`: The name of the flow for which the attribute needs to be set.
// 2. `key`: The key of the attribute being set.
// 3. `value`: The value of the attribute being set.
- (void)setFlowAttributeName:(nonnull NSString *)name key:(nonnull NSString *)key value:(nullable NSString *)value error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM setAttributeForFlowWithName:name key:key value:value];
}

// This method is responsible for ending a flow with the given `name`.
// This functionality helps in monitoring and tracking the performance of different flows within the application.
- (void)endFlowName:(nonnull NSString *)name error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    [IBGAPM endFlowWithName:name];
}

// This method is responsible for starting a UI trace with the given `name`. 
// Which initiates the tracking of user interface interactions for monitoring the performance of the application.
- (void)startUITraceName:(NSString *)name error:(FlutterError *_Nullable *_Nonnull)error {
    [IBGAPM startUITraceWithName:name];
}

// The method is responsible for ending the currently active UI trace. 
// Which signifies the completion of tracking user interface interactions.
- (void)endUITraceWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGAPM endUITrace];
}

// The method is responsible for ending the app launch process in the APM module.
- (void)endAppLaunchWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGAPM endAppLaunch];
}

- (void)networkLogAndroidData:(NSDictionary<NSString *, id> *)data error:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}


// This method is responsible for initiating a custom performance UI trace
// in the APM module. It takes three parameters:
// 1. `screenName`: A string representing the name of the screen or UI element being traced.
// 2. `microTimeStamp`: A number representing the timestamp in microseconds when the trace is started.
// 3. `traceId`: A number representing the unique identifier for the trace.
- (void)startCpUiTraceScreenName:(nonnull NSString *)screenName microTimeStamp:(nonnull NSNumber *)microTimeStamp traceId:(nonnull NSNumber *)traceId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSTimeInterval startTimeStampMUS = [microTimeStamp doubleValue];
    [IBGAPM startUITraceCPWithName:screenName startTimestampMUS:startTimeStampMUS];
}



// This method is responsible for reporting the screen
// loading data from Dart side to iOS side. It takes three parameters:
// 1. `startTimeStampMicro`: A number representing the start timestamp in microseconds of the screen
// loading custom performance data.
// 2. `durationMicro`: A number representing the duration in microseconds of the screen loading custom
// performance data.
// 3. `uiTraceId`: A number representing the unique identifier for the UI trace associated with the
// screen loading.
- (void)reportScreenLoadingCPStartTimeStampMicro:(nonnull NSNumber *)startTimeStampMicro durationMicro:(nonnull NSNumber *)durationMicro uiTraceId:(nonnull NSNumber *)uiTraceId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSTimeInterval startTimeStampMicroMUS = [startTimeStampMicro doubleValue];
    NSTimeInterval durationMUS = [durationMicro doubleValue];
    [IBGAPM reportScreenLoadingCPWithStartTimestampMUS:startTimeStampMicroMUS durationMUS:durationMUS];
}

// This method is responsible for extend the end time if the screen loading custom
// trace. It takes two parameters:
// 1. `timeStampMicro`: A number representing the timestamp in microseconds when the screen loading
// custom trace is ending.
// 2. `uiTraceId`: A number representing the unique identifier for the UI trace associated with the
// screen loading.
- (void)endScreenLoadingCPTimeStampMicro:(nonnull NSNumber *)timeStampMicro uiTraceId:(nonnull NSNumber *)uiTraceId error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSTimeInterval endScreenLoadingCPWithEndTimestampMUS = [timeStampMicro doubleValue];
    [IBGAPM endScreenLoadingCPWithEndTimestampMUS:endScreenLoadingCPWithEndTimestampMUS];
}

// This method is used to check whether the end screen loading feature is enabled or not.
//`completion` handler is a way for implementing callback functionality.
- (void)isEndScreenLoadingEnabledWithCompletion:(nonnull void (^)(NSNumber * _Nullable, FlutterError * _Nullable))completion {
    BOOL isEndScreenLoadingEnabled = IBGAPM.endScreenLoadingEnabled;
    NSNumber *isEnabledNumber = @(isEndScreenLoadingEnabled);
    completion(isEnabledNumber, nil);
}


@end
