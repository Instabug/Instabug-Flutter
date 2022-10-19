#import "BugReportingPigeon.h"

@interface BugReportingApi : NSObject<BugReportingHostApi>

@property (nonatomic, strong) BugReportingFlutterApi* flutterApi;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
