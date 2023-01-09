// Autogenerated from Pigeon (v3.0.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "FeatureRequestsPigeon.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary<NSString *, id> *wrapResult(id result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = @{
        @"code": (error.code ?: [NSNull null]),
        @"message": (error.message ?: [NSNull null]),
        @"details": (error.details ?: [NSNull null]),
        };
  }
  return @{
      @"result": (result ?: [NSNull null]),
      @"error": errorDict,
      };
}
static id GetNullableObject(NSDictionary* dict, id key) {
  id result = dict[key];
  return (result == [NSNull null]) ? nil : result;
}
static id GetNullableObjectAtIndex(NSArray* array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}



@interface FeatureRequestsHostApiCodecReader : FlutterStandardReader
@end
@implementation FeatureRequestsHostApiCodecReader
@end

@interface FeatureRequestsHostApiCodecWriter : FlutterStandardWriter
@end
@implementation FeatureRequestsHostApiCodecWriter
@end

@interface FeatureRequestsHostApiCodecReaderWriter : FlutterStandardReaderWriter
@end
@implementation FeatureRequestsHostApiCodecReaderWriter
- (FlutterStandardWriter *)writerWithData:(NSMutableData *)data {
  return [[FeatureRequestsHostApiCodecWriter alloc] initWithData:data];
}
- (FlutterStandardReader *)readerWithData:(NSData *)data {
  return [[FeatureRequestsHostApiCodecReader alloc] initWithData:data];
}
@end

NSObject<FlutterMessageCodec> *FeatureRequestsHostApiGetCodec() {
  static dispatch_once_t sPred = 0;
  static FlutterStandardMessageCodec *sSharedObject = nil;
  dispatch_once(&sPred, ^{
    FeatureRequestsHostApiCodecReaderWriter *readerWriter = [[FeatureRequestsHostApiCodecReaderWriter alloc] init];
    sSharedObject = [FlutterStandardMessageCodec codecWithReaderWriter:readerWriter];
  });
  return sSharedObject;
}


void FeatureRequestsHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<FeatureRequestsHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.FeatureRequestsHostApi.show"
        binaryMessenger:binaryMessenger
        codec:FeatureRequestsHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(showWithError:)], @"FeatureRequestsHostApi api (%@) doesn't respond to @selector(showWithError:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api showWithError:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.FeatureRequestsHostApi.setEmailFieldRequired"
        binaryMessenger:binaryMessenger
        codec:FeatureRequestsHostApiGetCodec()        ];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEmailFieldRequiredIsRequired:actionTypes:error:)], @"FeatureRequestsHostApi api (%@) doesn't respond to @selector(setEmailFieldRequiredIsRequired:actionTypes:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_isRequired = GetNullableObjectAtIndex(args, 0);
        NSArray<NSString *> *arg_actionTypes = GetNullableObjectAtIndex(args, 1);
        FlutterError *error;
        [api setEmailFieldRequiredIsRequired:arg_isRequired actionTypes:arg_actionTypes error:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
