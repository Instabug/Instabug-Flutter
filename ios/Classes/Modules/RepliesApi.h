#import "RepliesPigeon.h"

@interface RepliesApi : NSObject<RepliesHostApi>

@property (nonatomic, strong) RepliesFlutterApi* flutterApi;

- (instancetype)initWithBinaryMessenger:(id<FlutterBinaryMessenger>)messenger;

@end
