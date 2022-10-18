#import "Generated/RepliesPigeon.h"
#import "Instabug.h"
#import "RepliesApiImpl.h"

@implementation RepliesApiImpl

- (RepliesApiImpl *)initWithFlutterApi:(RepliesFlutterApi *)api {
    self = [super init];
    self.flutterApi = api;
    return self;
}

- (void)setEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGReplies.enabled = boolValue;
}

- (void)showWithError:(FlutterError *_Nullable *_Nonnull)error {
    [IBGReplies show];
}

- (void)setInAppNotificationsEnabledIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    BOOL boolValue = [isEnabled boolValue];
    IBGReplies.inAppNotificationsEnabled = boolValue;
}

- (void)setInAppNotificationSoundIsEnabled:(NSNumber *)isEnabled error:(FlutterError *_Nullable *_Nonnull)error {
    // Android Only
}

- (nullable NSNumber *)getUnreadRepliesCountWithError:(FlutterError *_Nullable *_Nonnull)error {
    return [NSNumber numberWithLong:IBGReplies.unreadRepliesCount];
}

- (nullable NSNumber *)hasChatsWithError:(FlutterError *_Nullable *_Nonnull)error {
    return [NSNumber numberWithBool:IBGReplies.hasChats];
}

- (void)bindOnNewReplyCallbackWithError:(FlutterError *_Nullable *_Nonnull)error {
    IBGReplies.didReceiveReplyHandler = ^{
        [self->_flutterApi onNewReplyWithCompletion:^(NSError * _Nullable _) {}];
    };
}

@end
