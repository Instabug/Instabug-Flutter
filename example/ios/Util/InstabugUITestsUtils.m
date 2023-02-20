#import "InstabugUITestsUtils.h"

@implementation InstabugUITestsUtils

+ (UIColor *)getPixelColorWithImage:(UIImage *)image x:(NSInteger)x y:(NSInteger)y {
    CGImageRef cgImage = image.CGImage;
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    int bytesPerPixel = 4;
    NSUInteger bitsPerComponent = 8;
    UInt8 pixelData[4] = {0, 0, 0, 0};
    CGContextRef context = CGBitmapContextCreate(pixelData, 1, 1, bitsPerComponent, bytesPerPixel, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);

    CGContextTranslateCTM(context, -x, y - height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, width, height), cgImage);
    CGContextRelease(context);

    CGFloat red = pixelData[0] / 255.0f;
    CGFloat green = pixelData[1] / 255.0f;
    CGFloat blue = pixelData[2] / 255.0f;
    CGFloat alpha = pixelData[3] / 255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
