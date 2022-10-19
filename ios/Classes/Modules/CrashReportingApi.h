#import "CrashReportingPigeon.h"

@interface CrashReportingApi : NSObject<CrashReportingHostApi>

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
