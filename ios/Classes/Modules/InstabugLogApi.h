#import "InstabugLogPigeon.h"

@interface InstabugLogApi : NSObject<InstabugLogHostApi>

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
