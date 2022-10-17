#import <Flutter/Flutter.h>

@interface InstabugFlutterPlugin : NSObject <FlutterPlugin>

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;


/**
  * Sets the runnable that gets executed just before showing any valid survey<br/>
  * WARNING: This runs on your application's main UI thread. Please do not include
  * any blocking operations to avoid ANRs.
  */
+ (void)setOnShowSurveyCallback;

/**
  * Sets the runnable that gets executed just after showing any valid survey<br/>
  * WARNING: This runs on your application's main UI thread. Please do not include
  * any blocking operations to avoid ANRs.
  *
  */
+ (void)setOnDismissSurveyCallback;

/**
  * Sets a block of code to be executed right after the SDK's UI is dismissed.
  * This block is executed on the UI thread. Could be used for performing any
  * UI changes after the SDK's UI is dismissed.
  */
+ (void)getAvailableSurveys;

/**
  * Returns true if the survey with a specific token was answered before.
  * Will return false if the token does not exist or if the survey was not answered before.
  *
  * @param surveyToken the attribute key as string
  * @return the desired value of whether the user has responded to the survey or not.
  */
+ (void)hasRespondedToSurveyWithToken:(NSString *)surveyToken;

/**
  * Shows the UI for feature requests list
  */
+ (void)showFeatureRequests;

/**
  * Sets whether email field is required or not when submitting
  * new-feature-request/new-comment-on-feature
  *
  * @param isEmailFieldRequired set true to make email field required
  * @param actionTypesArray Bitwise-or of actions
  */
+ (void)setEmailFieldRequiredForFeatureRequests:(NSNumber *)isEmailFieldRequired forAction:(NSArray *)actionTypesArray;

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
