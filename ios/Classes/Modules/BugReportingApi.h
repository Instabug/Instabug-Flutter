#import "BugReportingPigeon.h"

extern void InitBugReportingApi(id<FlutterBinaryMessenger> messenger);

@interface BugReportingApi : NSObject <BugReportingHostApi>

@property(nonatomic, strong) BugReportingFlutterApi *flutterApi;
- (instancetype)initWithFlutterApi:(BugReportingFlutterApi *)api;

@end
