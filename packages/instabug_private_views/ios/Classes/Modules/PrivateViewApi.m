#import "PrivateViewApi.h"
#import "FlutterPluginRegistrar+FlutterEngine.h"

extern PrivateViewApi* InitPrivateViewApi(
    id<FlutterBinaryMessenger> messenger,
    NSObject<FlutterPluginRegistrar> *flutterEngineRegistrar
) {
    InstabugPrivateViewFlutterApi *flutterApi = [[InstabugPrivateViewFlutterApi alloc] initWithBinaryMessenger:messenger];
    return [[PrivateViewApi alloc] initWithFlutterApi:flutterApi registrar:flutterEngineRegistrar];
}

@implementation PrivateViewApi

// Initializer with proper memory management
- (instancetype)initWithFlutterApi:(InstabugPrivateViewFlutterApi *)api
                         registrar:( NSObject<FlutterPluginRegistrar> *) registrar {
    if ((self = [super init])) {
        _flutterApi = api;
        _flutterEngineRegistrar = registrar;
    }
    return self;
}

- (void)mask:(UIImage *)screenshot
  completion:(void (^)(UIImage *))completion {
    
    __weak typeof(self) weakSelf = self;

    [self.flutterApi getPrivateViewsWithCompletion:^(NSArray<NSNumber *> *rectangles, FlutterError *error) {
        [weakSelf handlePrivateViewsResult:rectangles
                                     error:error
                                screenshot:screenshot
                                completion:completion];
    }];
}

#pragma mark - Private Methods

// Handle the result of fetching private views
- (void)handlePrivateViewsResult:(NSArray<NSNumber *> *)rectangles
                           error:(FlutterError *)error
                      screenshot:(UIImage *)screenshot
                      completion:(void (^)(UIImage *))completion {
    if (error) {
        [self logError:error];
        completion(screenshot);
        return;
    }

    NSArray<NSValue *> *privateViews = [self convertToRectangles:rectangles];
    UIImage *maskedScreenshot = [self drawMaskedImage:screenshot withPrivateViews:privateViews];
    completion(maskedScreenshot);

}

// Convert the raw rectangles array into CGRect values
- (NSArray<NSValue *> *)convertToRectangles:(NSArray<NSNumber *> *)rectangles {
    
    NSMutableArray<NSValue *> *privateViews = [NSMutableArray arrayWithCapacity:rectangles.count / 4];
    CGPoint flutterOrigin = [self getFlutterViewOrigin];

    for (NSUInteger i = 0; i < rectangles.count; i += 4) {
        CGFloat left = rectangles[i].doubleValue;
        CGFloat top = rectangles[i + 1].doubleValue;
        CGFloat right = rectangles[i + 2].doubleValue;
        CGFloat bottom = rectangles[i + 3].doubleValue;

        CGRect rect = CGRectMake(flutterOrigin.x + left,
                                 flutterOrigin.y + top,
                                 right - left + 1,
                                 bottom - top + 1);
        [privateViews addObject:[NSValue valueWithCGRect:rect]];
    }
    return privateViews;
}

// Draw the masked image by filling private views with black rectangles
- (UIImage *)drawMaskedImage:(UIImage *)screenshot withPrivateViews:(NSArray<NSValue *> *)privateViews {
    UIGraphicsBeginImageContextWithOptions(screenshot.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();

    @try {
        [screenshot drawAtPoint:CGPointZero];
        CGContextSetFillColorWithColor(context, UIColor.blackColor.CGColor);

        for (NSValue *value in privateViews) {
            CGContextFillRect(context, value.CGRectValue);
        }

        return UIGraphicsGetImageFromCurrentImageContext();
    } @finally {
        UIGraphicsEndImageContext();
    }
}

// Retrieve the origin point of the Flutter view
- (CGPoint)getFlutterViewOrigin {
    FlutterViewController *flutterVC = (FlutterViewController *)self.flutterEngineRegistrar.flutterEngine.viewController;

    UIView *flutterView = flutterVC.view;
    if(!flutterView)
        return  CGPointZero;
    UIWindow *window = flutterView.window;
    CGRect globalFrame = [flutterView convertRect:flutterView.bounds toView:window];

    return globalFrame.origin ;
}


// Log error details
- (void)logError:(FlutterError *)error {
    NSLog(@"IBG-Flutter: Error getting private views: %@", error.message);
}


@end
