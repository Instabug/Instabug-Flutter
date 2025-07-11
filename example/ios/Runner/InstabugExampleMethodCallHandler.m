#import <Foundation/Foundation.h>
#import "InstabugExampleMethodCallHandler.h"
#import <InstabugSDK/IBGCrashReporting.h>
#import <InstabugSDK/InstabugSDK.h>
#import <Flutter/Flutter.h>

// MARK: - Private Interface
@interface InstabugExampleMethodCallHandler()
@property (nonatomic, strong) NSMutableArray *oomBelly;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@end



// MARK: - Constants

extern NSString * const kSendNativeNonFatalCrashMethod;
extern NSString * const kSendNativeFatalCrashMethod;
extern NSString * const kSendNativeFatalHangMethod;
extern NSString * const kSendOOMMethod;

extern NSString * const kInstabugChannelName;

// MARK: - MethodCallHandler Implementation

@implementation InstabugExampleMethodCallHandler

NSString * const kSendNativeNonFatalCrashMethod = @"sendNativeNonFatalCrash";
NSString * const kSendNativeFatalCrashMethod = @"sendNativeFatalCrash";
NSString * const kSendNativeFatalHangMethod = @"sendNativeFatalHang";
NSString * const kSendOOMMethod = @"sendOom";

NSString * const kInstabugChannelName = @"instabug_flutter_example";

// MARK: - Initializer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.serialQueue = dispatch_queue_create("QUEUE>SERIAL", DISPATCH_QUEUE_SERIAL);
    }
    return self;
}


// MARK: - Flutter Plugin Methods

- (dispatch_queue_t)methodQueue {
    return dispatch_get_main_queue();
}

+ (BOOL)requiresMainQueueSetup
{
    return NO;
}

- (void)oomCrash {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *belly = [NSMutableArray array];
        while (true) {
            // 20 MB chunks to speed up OOM
            void *buffer = malloc(20 * 1024 * 1024);
            if (buffer == NULL) {
                NSLog(@"OOM: malloc failed");
                break;
            }
            memset(buffer, 1, 20 * 1024 * 1024);
            NSData *data = [NSData dataWithBytesNoCopy:buffer length:20 * 1024 * 1024 freeWhenDone:YES];
            [belly addObject:data];

            // Optional: slight delay to avoid CPU spike
            [NSThread sleepForTimeInterval:0.01];
        }
    });
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([kSendNativeNonFatalCrashMethod isEqualToString:call.method]) {
        NSLog(@"Sending native non-fatal crash from iOS");
        [self sendNativeNonFatal:call.arguments];
        result(nil);
    } else if ([kSendNativeFatalCrashMethod isEqualToString:call.method]) {
        NSLog(@"Sending native fatal crash from iOS");
        [self sendNativeFatalCrash];
        result(nil);
    } else if ([kSendNativeFatalHangMethod isEqualToString:call.method]) {
        NSLog(@"Sending native fatal hang for 3000 ms from iOS");
        [self sendFatalHang];
        result(nil);
    } else if ([kSendOOMMethod isEqualToString:call.method]) {
        NSLog(@"Sending out of memory from iOS");
        [self sendOOM];
        result(nil);
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// MARK: - Helper Methods

- (void)sendNativeNonFatal:(NSString *)exceptionObject {
    IBGNonFatalException *nonFatalException = [IBGCrashReporting exception:[NSException exceptionWithName:@"native Handled NS Exception" reason:@"Test iOS Handled Crash" userInfo:@{@"Key": @"Value"}]];
    
    [nonFatalException report];
}

- (void)sendNativeFatalCrash {
    NSException *exception = [NSException exceptionWithName:@"native Unhandled NS Exception" reason:@"Test iOS Unhandled Crash" userInfo:nil];
    @throw exception;
}

- (void)sendFatalHang {
    dispatch_async(dispatch_get_main_queue(), ^{
        sleep(20); // Block main thread for 20 seconds
    });
}

- (void)sendOOM {
    [self oomCrash];
}

- (void)sendNativeNonFatal {
}

@end
