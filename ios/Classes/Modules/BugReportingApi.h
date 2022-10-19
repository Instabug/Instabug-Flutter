#import "BugReportingPigeon.h"

@interface BugReportingApi : NSObject <BugReportingHostApi>

@property (nonatomic, strong) BugReportingFlutterApi* flutterApi;

-(BugReportingApi*) initWithFlutterApi:(BugReportingFlutterApi*)api;

@end
