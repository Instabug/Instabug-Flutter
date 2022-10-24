#import "InstabugPigeon.h"

extern void InitInstabugApi(id<FlutterBinaryMessenger> messenger);

@interface InstabugApi : NSObject<InstabugHostApi>
@end
