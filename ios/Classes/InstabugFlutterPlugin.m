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
  BugReportingFlutterApi *bugReportingFlutterApi = [[BugReportingFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  BugReportingApi *bugReportingApi = [[BugReportingApi alloc] initWithFlutterApi:bugReportingFlutterApi];
    
  RepliesFlutterApi *repliesFlutterApi = [[RepliesFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  RepliesApi *repliesApi = [[RepliesApi alloc] initWithFlutterApi:repliesFlutterApi];

  SurveysFlutterApi *surveysFlutterApi = [[SurveysFlutterApi alloc] initWithBinaryMessenger:[registrar messenger]];
  SurveysApi *surveysApi = [[SurveysApi alloc] initWithFlutterApi:surveysFlutterApi];

  ApmHostApiSetup([registrar messenger], [[ApmApi alloc] init]);
  InstabugHostApiSetup([registrar messenger], [[InstabugApi alloc] init]);
  InstabugLogHostApiSetup([registrar messenger], [[InstabugLogApi alloc] init]);
  CrashReportingHostApiSetup([registrar messenger], [[CrashReportingApi alloc] init]);
  FeatureRequestsHostApiSetup([registrar messenger], [[FeatureRequestsApi alloc] init]);
  BugReportingHostApiSetup([registrar messenger], bugReportingApi);
  RepliesHostApiSetup([registrar messenger], repliesApi);
  SurveysHostApiSetup([registrar messenger], surveysApi);
}

@end
