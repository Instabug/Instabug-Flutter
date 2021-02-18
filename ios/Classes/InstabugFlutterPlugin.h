#import <Flutter/Flutter.h>

@interface InstabugFlutterPlugin : NSObject <FlutterPlugin>

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result;

/**
  * starts the SDK
  * @param token token The token that identifies the app
  * @param invocationEventsArray invocationEvents The events that invoke
  * the SDK's UI.
  */
+ (void)startWithToken:(NSString *)token invocationEvents:(NSArray *)invocationEventsArray;

/**
  * Shows the welcome message in a specific mode.
  *
  * @param welcomeMessageMode An enum to set the welcome message mode to
  *                          live, or beta.
  */
+ (void)showWelcomeMessageWithMode:(NSString *)welcomeMessageMode;

/**
  * Set the user identity.
  * Instabug will pre-fill the user email in reports.
  *
  * @param name  Username.
  * @param email User's default email
  */
+ (void)identifyUserWithEmail:(NSString *)email name:(NSString *)name;

/**
  * Sets the default value of the user's email to null and show email field and remove user
  * name from all reports
  * It also reset the chats on device and removes user attributes, user data and completed
  * surveys.
  */
+ (void)logOut;

/**
  * Change Locale of Instabug UI elements(defaults to English)
  *
  * @param locale locale
  */
+ (void)setLocale:(NSString *)locale;

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logVerbose:(NSString *)log;

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logDebug:(NSString *)log;

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logInfo:(NSString *)log;

/**
  * Clears Instabug internal log
  */
+ (void)clearAllLogs;

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logError:(NSString *)log;

/**
  * Appends a log message to Instabug internal log
  * These logs are then sent along the next uploaded report.
  * All log messages are timestamped 
  * @param log the message
  */
+ (void)logWarn:(NSString *)log;
/**
 * Sets the color theme of the SDK's whole UI.
 * @param colorTheme An `IBGColorTheme` to set the SDK's UI to.
 */
+ (void)setColorTheme:(NSString *)colorTheme;

/**
 * Appends a set of tags to previously added tags of reported feedback, bug or crash.
 * @param tags An array of tags to append to current tags.
 */
+ (void)appendTags:(NSArray *)tags;

/**
 * Manually removes all tags of reported feedback, bug or crash.
 */
+ (void)resetTags;

/**
 * Gets all tags of reported feedback, bug or crash.
 * @return An array of tags.
 */
+ (NSArray *)getTags;

/**
 * Set custom user attributes that are going to be sent with each feedback, bug or crash.
 * @param value User attribute value.
 * @param key User attribute key.
 */
+ (void)setUserAttribute:(NSString *)value withKey:(NSString *)key;

/**
 * Removes a given key and its associated value from user attributes.
 * Does nothing if a key does not exist.
 * @param key The key to remove.
 */
+ (void)removeUserAttributeForKey:(NSString *)key;

/**
 * Returns the user attribute associated with a given key.
 * @param key The key for which to return the corresponding value.
 * @return The value associated with aKey, or nil if no value is associated with aKey.
 */
+ (NSString *)getUserAttributeForKey:(NSString *)key;

/**
 * Returns all user attributes.
 * @return A new dictionary containing all the currently set user attributes, or an empty dictionary if no user attributes have been set.
 */
+ (NSDictionary *)getUserAttributes;

/**
 * invoke sdk manually
 */
+ (void)show;

/**
  * invoke sdk manually with desire invocation mode
  *
  * @param invocationMode the invocation mode
  * @param invocationOptionsArray the array of invocation options
  */
+ (void)invokeWithMode:(NSString *)invocationMode options:(NSArray *)invocationOptionsArray;

/**
  * Logs a user event that happens through the lifecycle of the application.
  * Logged user events are going to be sent with each report, as well as at the end of a session.
  *
  * @param name Event name.
  */
+ (void)logUserEventWithName:(NSString *)name;

/**
 * Overrides any of the strings shown in the SDK with custom ones.
 * Allows you to customize any of the strings shown to users in the SDK.
 * @param value String value to override the default one.
 * @param key Key of string to override. Use predefined keys like kIBGShakeStartAlertTextStringName,
 * kIBGEmailFieldPlaceholderStringName, etc.
 */
+ (void)setValue:(NSString *)value forStringWithKey:(NSString *)key;

/**
  * Enable/disable session profiler
  *
  * @param sessionProfilerEnabled desired state of the session profiler feature
  */
+ (void)setSessionProfilerEnabled:(NSNumber *)sessionProfilerEnabled;

/**
  * Set the primary color that the SDK will use to tint certain UI elements in the SDK
  *
  * @param color The value of the primary color 
  */
+ (void)setPrimaryColor:(NSNumber *)color;
/**
  * Adds specific user data that you need to be added to the reports
  *
  * @param userData user data
  */
+ (void)setUserData:(NSString *)userData;

/**
  * The file at filePath will be uploaded along upcoming reports with the name
  * fileNameWithExtension
  *
  * @param fileURLString the file uri
  */
+ (void)addFileAttachmentWithURL:(NSString *)fileURLString;

/**
  * The file at filePath will be uploaded along upcoming reports with the name
  * fileNameWithExtension
  *
  * @param data               the file data
  */
+ (void)addFileAttachmentWithData:(FlutterStandardTypedData *)data;

/**
  * Clears all Uris of the attached files.
  * The URIs which added via {@link Instabug#addFileAttachment} API not the physical files.
  */
+ (void)clearFileAttachments;

/**
  * Sets the welcome message mode to live, beta or disabled.
  *
  * @param welcomeMessageMode An enum to set the welcome message mode to
  *                          live, beta or disabled.
  */
+ (void)setWelcomeMessageMode:(NSString *)welcomeMessageMode;

/**
  * Enables and disables manual invocation and prompt options for bug and feedback.
  * @param isEnabled enabled
  */
+ (void)setBugReportingEnabled:(NSNumber *)isEnabled;

/**
  * Sets a block of code to be executed just before the SDK's UI is presented.
  * This block is executed on the UI thread. Could be used for performing any
  * UI changes before the SDK's UI is shown.
  */
+ (void)setOnInvokeCallback;

/**
  * Sets a block of code to be executed right after the SDK's UI is dismissed.
  * This block is executed on the UI thread. Could be used for performing any
  * UI changes after the SDK's UI is dismissed.
  */
+ (void)setOnDismissCallback;

/**
  * Sets whether attachments in bug reporting and in-app messaging are enabled or not.
  *
  * @param  screenShot A boolean to enable or disable screenshot attachments.
  * @param  extraScreenShot A boolean to enable or disable extra screenshot attachments.
  * @param  galleryImage A boolean to enable or disable gallery image attachments.
  * @param  screenRecording A boolean to enable or disable screen recording attachments.
  */
+ (void)setEnabledAttachmentTypes:(NSNumber *)screenShot
                  extraScreenShot:(NSNumber *)extraScreenShot
                     galleryImage:(NSNumber *)galleryImage
                  screenRecording:(NSNumber *)screenRecording;

/**
  * Sets the events that invoke the feedback form.
  * Default is set by `Instabug.startWithToken`.
  * @param invocationEventsArray invocationEvent Array of events that invokes the
  * feedback form.
  */
+ (void)setInvocationEvents:(NSArray *)invocationEventsArray;

/**
  * Sets the reports types.
  * Default is set by `Instabug.startWithToken`.
  * @param reportTypesArray report types array
  */
+ (void)setReportTypes:(NSArray *)reportTypesArray;

/**
  * Sets whether the extended bug report mode should be disabled,
  * enabled with required fields,  or enabled with optional fields.
  *
  * @param extendedBugReportMode extendedBugReportMode
  */
+ (void)setExtendedBugReportMode:(NSString *)extendedBugReportMode;

/**
  * Sets the invocation options
  *
  * @param invocationOptionsArray the array of invocation options
  */
+ (void)setInvocationOptions:(NSArray *)invocationOptionsArray;
/**
  * Sets the invocation options
  *
  * @param reportType reportType
  * @param invocationOptionsArray the array of invocation options
  */
+ (void)showBugReportingWithReportTypeAndOptions:(NSString *)reportType options:(NSArray *)invocationOptionsArray;

/**
  * Show any valid survey if exist
  *
  * @param isEnabled boolean
  */
+ (void)setSurveysEnabled:(NSNumber *)isEnabled;

/**
  * Sets url for the published iOS app on AppStore
  *
  * @param appStoreURL String
  */
+ (void)setAppStoreURL:(NSString *)appStoreURL;

/**
  * Set Surveys auto-showing state, default state auto-showing enabled
  *
  * @param isEnabled whether Surveys should be auto-showing or not
  */
+ (void)setAutoShowingSurveysEnabled:(NSNumber *)isEnabled;

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
  * Set Surveys auto-showing state, default state auto-showing enabled
  *
  * @param shouldShowWelcomeScreen whether Surveys should be auto-showing or not
  */
+ (void)setShouldShowSurveysWelcomeScreen:(NSNumber *)shouldShowWelcomeScreen;

/**
  * Show any valid survey if exist
  *
  * @return true if a valid survey was shown otherwise false
  */
+ (void)showSurveysIfAvailable;

/**
  * Shows survey with a specific token.
  * Does nothing if there are no available surveys with that specific token.
  * Answered and cancelled surveys won't show up again.
  *
  * @param surveyToken A String with a survey token.
  */
+ (void)showSurveyWithToken:(NSString *)surveyToken;

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
  * Manual invocation for chats view. 
  */
+ (void)showChats;

/**
  * Enables and disables everything related to creating new chats.
  * @param isEnabled isEnabled 
  */
+ (void)setChatsEnabled:(NSNumber *)isEnabled;

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
- (void)setChatNotificationEnabled:(NSNumber *)isEnabled;

+ (void)networkLog:(NSDictionary *)networkData;

@end
