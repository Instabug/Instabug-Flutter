#import <Flutter/Flutter.h>

extern NSString * const kInstabugChannelName;

@interface InstabugExampleMethodCallHandler : NSObject 

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result;
- (void)sendNativeNonFatal:(NSString *)exceptionObject;
- (void)sendNativeFatalCrash;
- (void)sendFatalHang;
- (void)sendOOM;

@end
