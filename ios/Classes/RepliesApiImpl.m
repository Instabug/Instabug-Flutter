#import "Generated/RepliesPigeon.h"
#import "Instabug.h"
#import "RepliesApiImpl.h"

@implementation RepliesApiImpl

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

@end
