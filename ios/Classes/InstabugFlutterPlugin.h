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

/**
  * Enables and disables everything related to APM feature.
  * @param isEnabled isEnabled 
  */
+ (void)setAPMEnabled:(NSNumber *)isEnabled;

/**
  * Sets the printed logs priority. Filter to one of the following levels:
  *
  * - logLevelNone disables all APM SDK console logs.
  *
  * - logLevelError prints errors only, we use this level to let you know if something goes wrong.
  *
  * - logLevelWarning displays warnings that will not necessarily lead to errors but should be addressed nonetheless.
  *
  * - logLevelInfo (default) logs information that we think is useful without being too verbose.
  *
  * - logLevelDebug use this in case you are debugging an issue. Not recommended for production use.
  *
  * - logLevelVerbose use this only if logLevelDebug was not enough and you need more visibility
  * on what is going on under the hood.
  *
  * Similar to the logLevelDebug level, this is not meant to be used on production environments.
  *
  * Each log level will also include logs from all the levels above it. For instance,
  * logLevelInfo will include logLevelInfo logs as well as logLevelWarning
  * and logLevelError logs.

  * @param _logLevel the printed logs priority.
  */
+ (void)setAPMLogLevel:(NSString *)_logLevel;

/**
  * Enables and disables cold app launch tracking.
  * @param isEnabled isEnabled 
  */
+ (void)setColdAppLaunchEnabled:(NSNumber *)isEnabled;

+ (NSString *)startExecutionTrace:(NSString *)name id:(NSString *)id;

+ (void)setExecutionTraceAttribute:(NSString *)id key:(NSString *)key value:(NSString *)value;

+ (void)endExecutionTrace:(NSString *)id;

/**
  * Enables or disables auto UI tracing.
  * @param isEnabled boolean indicating enabled or disabled.
  */
+ (void)setAutoUITraceEnabled:(NSNumber *)isEnabled;

/**
  * Start UI trace.
  * @param name string holding the name of the trace.
  */
+ (void)startUITrace:(NSString *)name;

/**
  * Ends UI trace.
  */
+ (void)endUITrace;

/**
  * Ends the current session’s App Launch. Calling this API is optional, App Launches will still be captured and ended automatically by the SDK;
  * this API just allows you to change when an App Launch actually ends.
  */
+ (void)endAppLaunch;

+ (NSDictionary *)constants;
@end
