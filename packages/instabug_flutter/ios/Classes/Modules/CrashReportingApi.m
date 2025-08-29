#import "InstabugSDK.h"
#import "CrashReportingApi.h"
#import "../Util/IBGCrashReporting+CP.h"
#import "ArgsRegistry.h"

extern void InitCrashReportingApi(id<FlutterBinaryMessenger> messenger) {
    CrashReportingApi *api = [[CrashReportingApi alloc] init];
    CrashReportingHostApiSetup(messenger, api);
}

@implementation CrashReportingApi

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGCrashReporting.enabled = boolValue;
}

- (void)sendJsonCrash:(NSString *)jsonCrash isHandled:(NSNumber *)isHandled error:(FlutterError *_Nullable *_Nonnull)error {
    NSError *jsonError;
    NSData *objectData = [jsonCrash dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *stackTrace = [NSJSONSerialization JSONObjectWithData:objectData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&jsonError];
    BOOL isNonFatal = [isHandled boolValue];

    if (isNonFatal) {
        [IBGCrashReporting cp_reportNonFatalCrashWithStackTrace:stackTrace
                                                          level:IBGNonFatalLevelError groupingString:nil userAttributes:nil
        ];
    } else {
        [IBGCrashReporting cp_reportFatalCrashWithStackTrace:stackTrace  ];

    }
}

- (void)sendNonFatalErrorJsonCrash:(nonnull NSString *)jsonCrash userAttributes:(nullable NSDictionary<NSString *,NSString *> *)userAttributes fingerprint:(nullable NSString *)fingerprint nonFatalExceptionLevel:(nonnull NSString *)nonFatalExceptionLevel error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSError *jsonError;
    NSData *objectData = [jsonCrash dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *stackTrace = [NSJSONSerialization JSONObjectWithData:objectData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&jsonError];
    IBGNonFatalLevel level = (ArgsRegistry.nonFatalExceptionLevel[nonFatalExceptionLevel]).integerValue;
    [IBGCrashReporting cp_reportNonFatalCrashWithStackTrace:stackTrace
                                                      level: level
                                             groupingString:fingerprint
                                             userAttributes:userAttributes];

}
@end
