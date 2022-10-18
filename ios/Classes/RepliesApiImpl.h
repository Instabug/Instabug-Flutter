@interface RepliesApiImpl : NSObject <RepliesApi>

@property (nonatomic, strong) RepliesFlutterApi* flutterApi;

-(RepliesApiImpl*) initWithFlutterApi:(RepliesFlutterApi*)api;

@end
