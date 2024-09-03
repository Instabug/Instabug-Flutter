#import "InstabugFlutterPlugin.h"
#import "Flutter/FlutterEngine.h"

#import "ApmApi.h"
#import "BugReportingApi.h"
#import "CrashReportingApi.h"
#import "FeatureRequestsApi.h"
#import "InstabugApi.h"
#import "InstabugLogApi.h"
#import "RepliesApi.h"
#import "SessionReplayApi.h"
#import "SurveysApi.h"

@interface FlutterEngineRegistrar : NSObject <FlutterPluginRegistrar>

@property(nonatomic, assign) FlutterEngine* flutterEngine;

@end


@implementation InstabugFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterEngineRegistrar *engineRegistrar = (FlutterEngineRegistrar *) registrar;
    UIView *flutterView = engineRegistrar.flutterEngine.viewController.view;

    InitApmApi([registrar messenger]);
    InitBugReportingApi([registrar messenger]);
    InitCrashReportingApi([registrar messenger]);
    InitFeatureRequestsApi([registrar messenger]);
    InitInstabugApi([registrar messenger], flutterView);
    InitInstabugLogApi([registrar messenger]);
    InitRepliesApi([registrar messenger]);
    InitSessionReplayApi([registrar messenger]);
    InitSurveysApi([registrar messenger]);
}

@end
