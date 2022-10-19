#import "RepliesPigeon.h"

@interface RepliesApi : NSObject <RepliesHostApi>

@property (nonatomic, strong) RepliesFlutterApi* flutterApi;

-(RepliesApi*) initWithFlutterApi:(RepliesFlutterApi*)api;

@end
