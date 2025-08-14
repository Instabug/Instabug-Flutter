#import "PrivateViewApi.h"
#import "../Util/FlutterPluginRegistrar+FlutterEngine.h"

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

static long long currentTimeMillis;


- (void)mask:(UIImage *)screenshot
  completion:(void (^)(UIImage *))completion {
    
    __weak typeof(self) weakSelf = self;
    // Wait for the Cupertino animation to complete
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    [self.flutterApi getPrivateViewsWithCompletion:^(NSArray<NSNumber *> *rectangles, FlutterError *error) {
        UIImage *capturedScreenshot = [self captureScreenshot];
            [weakSelf handlePrivateViewsResult:rectangles
                                         error:error
                                    screenshot:capturedScreenshot
                                    completion:completion];
      }];
    });
}

#pragma mark - Private Methods

// Method to capture a screenshot of the app's main window
- (UIImage *)captureScreenshot {
    CGSize imageSize = UIScreen.mainScreen.bounds.size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, UIScreen.mainScreen.scale);

    // Iterate over all windows, including the keyboard window
    for (UIWindow *window in UIApplication.sharedApplication.windows) {
        [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
    }

    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
}

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
    static long long currentTimeMillis2;
    currentTimeMillis2 = (long long)([[NSDate date] timeIntervalSince1970] * 1000);

    long long timeDifference = currentTimeMillis2 - currentTimeMillis;

    completion(maskedScreenshot);
    NSLog(@"Time Difference: %lld ms (Last: %lld, Current: %lld)", timeDifference, currentTimeMillis2, currentTimeMillis);


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
