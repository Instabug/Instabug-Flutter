
#import <Foundation/Foundation.h>

@interface Instabug (CP)

+ (void)setScreenshotMaskingHandler:(nullable void (^)(UIImage *, void (^)(UIImage *)))maskingHandler;

@end
