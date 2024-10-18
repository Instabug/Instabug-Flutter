#import "FeatureRequestsPigeon.h"

extern void InitFeatureRequestsApi(id<FlutterBinaryMessenger> messenger);

@interface FeatureRequestsApi : NSObject <FeatureRequestsHostApi>
@end
