#import "ApmPigeon.h"

extern void InitApmApi(id<FlutterBinaryMessenger> messenger);

@interface ApmApi : NSObject <ApmHostApi>
@end
