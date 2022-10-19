#import "InstabugFlutterPlugin.h"

#import "ApmApi.h"
#import "BugReportingApi.h"
#import "CrashReportingApi.h"
#import "FeatureRequestsApi.h"
#import "InstabugApi.h"
#import "InstabugLogApi.h"
#import "RepliesApi.h"
#import "SurveysApi.h"

@implementation InstabugFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wunused-value"
    [[ApmApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[BugReportingApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[CrashReportingApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[FeatureRequestsApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[InstabugApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[InstabugLogApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[RepliesApi alloc] initWithBinaryMessenger:[registrar messenger]];
    [[SurveysApi alloc] initWithBinaryMessenger:[registrar messenger]];
    #pragma clang diagnostic pop
}

@end
