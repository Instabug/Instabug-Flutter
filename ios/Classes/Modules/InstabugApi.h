#import "InstabugPigeon.h"

@interface InstabugApi : NSObject<InstabugHostApi>

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
