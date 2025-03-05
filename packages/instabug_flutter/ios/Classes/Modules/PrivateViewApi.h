#import <Foundation/Foundation.h>
#import "InstabugPrivateViewPigeon.h"
#import <Flutter/Flutter.h>


@interface PrivateViewApi : NSObject

@property (nonatomic, strong) InstabugPrivateViewFlutterApi *flutterApi;
@property (nonatomic, strong) NSObject<FlutterPluginRegistrar> * flutterEngineRegistrar;

- (instancetype)initWithFlutterApi:(InstabugPrivateViewFlutterApi *)api
                         registrar:(NSObject<FlutterPluginRegistrar> *)registrar;

- (void)mask:(UIImage *)screenshot
 completion:(void (^)(UIImage *maskedImage))completion;
- (void)handlePrivateViewsResult:(NSArray<NSNumber *> *)rectangles
                             error:(FlutterError *)error
                        screenshot:(UIImage *)screenshot
                      completion:(void (^)(UIImage *))completion;
- (NSArray<NSValue *> *)convertToRectangles:(NSArray<NSNumber *> *)rectangles;

- (UIImage *)drawMaskedImage:(UIImage *)screenshot withPrivateViews:(NSArray<NSValue *> *)privateViews;
- (CGPoint)getFlutterViewOrigin;

- (void)logError:(FlutterError *)error;

@end

// Extern function to initialize PrivateViewApi
extern PrivateViewApi* InitPrivateViewApi(
    id<FlutterBinaryMessenger> messenger,
    NSObject<FlutterPluginRegistrar> *flutterEngineRegistrar
);

