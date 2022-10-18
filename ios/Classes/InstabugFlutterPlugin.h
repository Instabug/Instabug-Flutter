#import <Flutter/Flutter.h>

@interface InstabugFlutterPlugin : NSObject <FlutterPlugin>

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

+ (void)networkLog:(NSDictionary *)networkData;

+ (NSDictionary *)constants;
@end
