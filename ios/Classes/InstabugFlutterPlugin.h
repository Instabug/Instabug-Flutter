#import <Flutter/Flutter.h>

@interface InstabugFlutterPlugin : NSObject <FlutterPlugin>

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

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

+ (void)networkLog:(NSDictionary *)networkData;

+ (NSDictionary *)constants;
@end
