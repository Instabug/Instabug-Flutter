#import "InstabugPigeon.h"
#import "PrivateViewApi.h"

extern void InitInstabugApi(id<FlutterBinaryMessenger> _Nonnull messenger, PrivateViewApi * _Nonnull api);

@interface InstabugApi : NSObject <InstabugHostApi>
@property (nonatomic, strong) PrivateViewApi* _Nonnull privateViewApi;

- (UIImage *)getImageForAsset:(NSString *)assetName;
- (UIFont *)getFontForAsset:(NSString *)assetName  error:(FlutterError *_Nullable *_Nonnull)error;

@end
