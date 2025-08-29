#import "InstabugPigeon.h"

extern void InitInstabugApi(id<FlutterBinaryMessenger> messenger);

@interface InstabugApi : NSObject <InstabugHostApi>

- (UIImage *)getImageForAsset:(NSString *)assetName;
- (UIFont *)getFontForAsset:(NSString *)assetName  error:(FlutterError *_Nullable *_Nonnull)error;
+ (void)setScreenshotMaskingHandler:(nullable void (^)(UIImage *_Nonnull, void (^_Nonnull)(UIImage *_Nonnull)))maskingHandler;

@end
