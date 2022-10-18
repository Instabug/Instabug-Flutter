#import "BugReportingPigeon.h"

@interface BugReportingApiImpl : NSObject <BugReportingApi>

@property (nonatomic, strong) BugReportingFlutterApi* flutterApi;

-(BugReportingApiImpl*) initWithFlutterApi:(BugReportingFlutterApi*)api;

@end
