#import "InstabugLogPigeon.h"

extern void InitInstabugLogApi(id<FlutterBinaryMessenger> messenger);

@interface InstabugLogApi : NSObject <InstabugLogHostApi>
@end
