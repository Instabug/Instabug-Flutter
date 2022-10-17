#import <Flutter/Flutter.h>

@interface InstabugFlutterPlugin : NSObject <FlutterPlugin>

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

/**
  * Enables and disables everything related to receiving replies.
  * @param isEnabled isEnabled 
  */
+ (void)setRepliesEnabled:(NSNumber *)isEnabled;

/**
  * Manual invocation for replies.
  */
+ (void)showReplies;
/**
  * Tells whether the user has chats already or not.
  */
+ (void)hasChats;

/**
  * Sets a block of code that gets executed when a new message is received.
  */
+ (void)setOnNewReplyReceivedCallback;

/**
  * Get current unread count of messages for this user
  *
  * @return number of messages that are unread for this user
  */
+ (void)getUnreadRepliesCount;

/**
  * Enabled/disable chat notification
  *
  * @param isEnabled whether chat notification is reburied or not
  */
+ (void)setChatNotificationEnabled:(NSNumber *)isEnabled;

+ (void)networkLog:(NSDictionary *)networkData;

+ (NSDictionary *)constants;
@end
