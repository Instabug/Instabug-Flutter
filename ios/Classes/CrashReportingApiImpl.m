#import "Generated/CrashReportingPigeon.h"
#import "Instabug.h"
#import "CrashReportingApiImpl.h"

@implementation CrashReportingApiImpl

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
   SEL reportCrashWithStackTraceSEL = NSSelectorFromString(@"reportCrashWithStackTrace:handled:");
     if ([[Instabug class] respondsToSelector:reportCrashWithStackTraceSEL]) {
           [[Instabug class] performSelector:reportCrashWithStackTraceSEL withObject:stackTrace withObject:isHandled];
       }
}

@end
