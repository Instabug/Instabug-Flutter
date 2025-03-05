#import "PrivateViewApi.h"
#import "InstabugPrivateViewPigeon.h"
extern void InitPrivateViewHostApi(id<FlutterBinaryMessenger> _Nonnull messenger, PrivateViewApi * _Nonnull api);

@interface PrivateViewHostApi : NSObject <InstabugPrivateViewHostApi>
@property (nonatomic, strong) PrivateViewApi* _Nonnull privateViewApi;
@end
