#import "ApmPigeon.h"

@interface ApmApi : NSObject<ApmHostApi>

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
