#import "InstabugFlutterPlugin.h"

#import "ApmApi.h"
#import "BugReportingApi.h"
#import "CrashReportingApi.h"
#import "FeatureRequestsApi.h"
#import "InstabugApi.h"
#import "InstabugLogApi.h"
#import "RepliesApi.h"
#import "SessionReplayApi.h"
#import "SurveysApi.h"
#import "PrivateViewApi.h"

@implementation InstabugFlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    FlutterEngineRegistrar *engineRegistrar = (FlutterEngineRegistrar *) registrar;

    InitApmApi([registrar messenger]);
    InitBugReportingApi([registrar messenger]);
    InitCrashReportingApi([registrar messenger]);
    InitFeatureRequestsApi([registrar messenger]);
    PrivateViewApi* privateViewApi = InitPrivateViewApi([registrar messenger],engineRegistrar);
    InitInstabugApi([registrar messenger],privateViewApi);
    InitInstabugLogApi([registrar messenger]);
    InitRepliesApi([registrar messenger]);
    InitSessionReplayApi([registrar messenger]);
    InitSurveysApi([registrar messenger]);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(8.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIView *flutterView = engineRegistrar.flutterEngine.viewController.view;
            if (flutterView) {
                // Begin image context with the view's bounds
                UIGraphicsBeginImageContextWithOptions(flutterView.bounds.size, NO, 0.0);
                [flutterView drawViewHierarchyInRect:flutterView.bounds afterScreenUpdates:YES];

                // Capture the image from the context
                UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                [privateViewApi mask:screenshot completion:^(UIImage * _Nonnull maskedImage) {
                    NSLog(@"1");
                    NSLog(@"2");
                }];
            }else{
                NSLog(@"Error: Flutter view not found.");
            }
        
       });
    
}

@end
