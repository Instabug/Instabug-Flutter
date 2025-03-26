#import "Instabug.h"
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
    NSLog(@"[Instabug][Fatal] isHandled: %@", isHandled);

    NSError *jsonError;
    NSData *objectData = [jsonCrash dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *stackTrace = [NSJSONSerialization JSONObjectWithData:objectData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&jsonError];
    BOOL isNonFatal = [isHandled boolValue];

    if (isNonFatal) {
        NSLog(@"[Instabug][Crash - Non Fatal] jsonCrash: %@", jsonCrash);
        NSLog(@"[Instabug][Crash - Non Fatal] stackTrace: %@", stackTrace);
        [IBGCrashReporting cp_reportNonFatalCrashWithStackTrace:stackTrace
                                                          level:IBGNonFatalLevelError groupingString:nil userAttributes:nil
        ];
    } else {
        NSLog(@"[Instabug][Crash - Fatal] jsonCrash: %@", jsonCrash);
        NSLog(@"[Instabug][Crash - Fatal] stackTrace: %@", stackTrace);
        [IBGCrashReporting cp_reportFatalCrashWithStackTrace:stackTrace  ];

    }
}

- (void)sendNonFatalErrorJsonCrash:(nonnull NSString *)jsonCrash userAttributes:(nullable NSDictionary<NSString *,NSString *> *)userAttributes fingerprint:(nullable NSString *)fingerprint nonFatalExceptionLevel:(nonnull NSString *)nonFatalExceptionLevel error:(FlutterError * _Nullable __autoreleasing * _Nonnull)error {
    NSLog(@"[Instabug][Non Fatal] jsonCrash: %@", jsonCrash);
    NSLog(@"[Instabug][Non Fatal] userAttributes: %@", userAttributes);
    NSLog(@"[Instabug][Non Fatal] fingerprint: %@", fingerprint);
    NSLog(@"[Instabug][Non Fatal] nonFatalExceptionLevel: %@", nonFatalExceptionLevel);

    NSError *jsonError;
    NSData *objectData = [jsonCrash dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *stackTrace = [NSJSONSerialization JSONObjectWithData:objectData
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&jsonError];

    NSLog(@"[Instabug][Non Fatal] stackTrace: %@", stackTrace);

    IBGNonFatalLevel level = (ArgsRegistry.nonFatalExceptionLevel[nonFatalExceptionLevel]).integerValue;

    NSLog(@"[Instabug][Non Fatal] level: %ld", (long)level);

    [IBGCrashReporting cp_reportNonFatalCrashWithStackTrace:stackTrace
                                                      level: level
                                             groupingString:fingerprint
                                             userAttributes:userAttributes];

}
@end
