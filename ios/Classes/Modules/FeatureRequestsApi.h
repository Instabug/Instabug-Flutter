#import "FeatureRequestsPigeon.h"

@interface FeatureRequestsApi : NSObject<FeatureRequestsHostApi>

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
