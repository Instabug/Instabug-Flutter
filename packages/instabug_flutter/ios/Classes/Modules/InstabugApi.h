#import "InstabugPigeon.h"

extern void InitInstabugApi(id<FlutterBinaryMessenger> messenger);

@interface InstabugApi : NSObject <InstabugHostApi>

- (UIImage *)getImageForAsset:(NSString *)assetName;
- (UIFont *)getFontForAsset:(NSString *)assetName  error:(FlutterError *_Nullable *_Nonnull)error;

@end
