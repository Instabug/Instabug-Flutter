#import "InstabugPrivateViewPigeon.h"

extern void InitInstabugPrivateViewApi(id<FlutterBinaryMessenger> _Nullable messenger);


//@property(nonatomic, strong) RepliesFlutterApi *flutterApi;
//- (instancetype)getPrivateViewsWithCompletion:(void (^)(NSArray<NSNumber *> *_Nullable, FlutterError *_Nullable))completion;
@property(nonatomic, strong) InstabugPrivateViewApi *flutterApi;
- (instancetype)initWithFlutterApi:(InstabugPrivateViewApi *)api;


@end
