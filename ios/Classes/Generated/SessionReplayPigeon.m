// Autogenerated from Pigeon (v10.1.5), do not edit directly.
// See also: https://pub.dev/packages/pigeon

#import "SessionReplayPigeon.h"

#if TARGET_OS_OSX
#import <FlutterMacOS/FlutterMacOS.h>
#else
#import <Flutter/Flutter.h>
#endif

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSArray *wrapResult(id result, FlutterError *error) {
  if (error) {
    return @[
      error.code ?: [NSNull null], error.message ?: [NSNull null], error.details ?: [NSNull null]
    ];
  }
  return @[ result ?: [NSNull null] ];
}
static id GetNullableObjectAtIndex(NSArray *array, NSInteger key) {
  id result = array[key];
  return (result == [NSNull null]) ? nil : result;
}

NSObject<FlutterMessageCodec> *SessionReplayHostApiGetCodec(void) {
  static FlutterStandardMessageCodec *sSharedObject = nil;
  sSharedObject = [FlutterStandardMessageCodec sharedInstance];
  return sSharedObject;
}

void SessionReplayHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, NSObject<SessionReplayHostApi> *api) {
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.SessionReplayHostApi.setEnabled"
        binaryMessenger:binaryMessenger
        codec:SessionReplayHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setEnabledIsEnabled:error:)], @"SessionReplayHostApi api (%@) doesn't respond to @selector(setEnabledIsEnabled:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_isEnabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setEnabledIsEnabled:arg_isEnabled error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.SessionReplayHostApi.setNetworkLogsEnabled"
        binaryMessenger:binaryMessenger
        codec:SessionReplayHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setNetworkLogsEnabledIsEnabled:error:)], @"SessionReplayHostApi api (%@) doesn't respond to @selector(setNetworkLogsEnabledIsEnabled:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_isEnabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setNetworkLogsEnabledIsEnabled:arg_isEnabled error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.SessionReplayHostApi.setInstabugLogsEnabled"
        binaryMessenger:binaryMessenger
        codec:SessionReplayHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setInstabugLogsEnabledIsEnabled:error:)], @"SessionReplayHostApi api (%@) doesn't respond to @selector(setInstabugLogsEnabledIsEnabled:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_isEnabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setInstabugLogsEnabledIsEnabled:arg_isEnabled error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.SessionReplayHostApi.setUserStepsEnabled"
        binaryMessenger:binaryMessenger
        codec:SessionReplayHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(setUserStepsEnabledIsEnabled:error:)], @"SessionReplayHostApi api (%@) doesn't respond to @selector(setUserStepsEnabledIsEnabled:error:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        NSArray *args = message;
        NSNumber *arg_isEnabled = GetNullableObjectAtIndex(args, 0);
        FlutterError *error;
        [api setUserStepsEnabledIsEnabled:arg_isEnabled error:&error];
        callback(wrapResult(nil, error));
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
  {
    FlutterBasicMessageChannel *channel =
      [[FlutterBasicMessageChannel alloc]
        initWithName:@"dev.flutter.pigeon.instabug_flutter.SessionReplayHostApi.getSessionReplayLink"
        binaryMessenger:binaryMessenger
        codec:SessionReplayHostApiGetCodec()];
    if (api) {
      NSCAssert([api respondsToSelector:@selector(getSessionReplayLinkWithCompletion:)], @"SessionReplayHostApi api (%@) doesn't respond to @selector(getSessionReplayLinkWithCompletion:)", api);
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        [api getSessionReplayLinkWithCompletion:^(NSString *_Nullable output, FlutterError *_Nullable error) {
          callback(wrapResult(output, error));
        }];
      }];
    } else {
      [channel setMessageHandler:nil];
    }
  }
}