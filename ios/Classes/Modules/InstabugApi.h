#import "InstabugPigeon.h"

extern void InitInstabugApi(id<FlutterBinaryMessenger> messenger, UIView *flutterView);

@interface InstabugApi : NSObject <InstabugHostApi>

@property (nonatomic, strong) InstabugFlutterApi *flutterApi;
@property (nonatomic, weak) UIView *flutterView;

- (instancetype)initWithFlutterApi:(InstabugFlutterApi *)api flutterView:(UIView *)flutterView;

- (UIImage *)getImageForAsset:(NSString *)assetName;
- (UIFont *)getFontForAsset:(NSString *)assetName  error:(FlutterError *_Nullable *_Nonnull)error;

@end
