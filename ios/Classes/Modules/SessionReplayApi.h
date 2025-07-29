#import "SessionReplayPigeon.h"

extern void InitSessionReplayApi(id<FlutterBinaryMessenger> messenger);

@interface SessionReplayApi : NSObject <SessionReplayHostApi>
@end
