#import "RepliesPigeon.h"

extern void InitRepliesApi(id<FlutterBinaryMessenger> messenger);

@interface RepliesApi : NSObject <RepliesHostApi>

@property(nonatomic, strong) RepliesFlutterApi *flutterApi;
- (instancetype)initWithFlutterApi:(RepliesFlutterApi *)api;

@end
