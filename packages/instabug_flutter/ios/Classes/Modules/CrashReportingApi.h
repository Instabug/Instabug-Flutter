#import "CrashReportingPigeon.h"

extern void InitCrashReportingApi(id<FlutterBinaryMessenger> messenger);

@interface CrashReportingApi : NSObject <CrashReportingHostApi>
@end
