#import "InstabugPigeon.h"

extern void InitInstabugApi(id<FlutterBinaryMessenger> messenger);

@interface InstabugApi : NSObject <InstabugHostApi>

- (UIImage *)getImageForAsset:(NSString *)assetName;

@end
