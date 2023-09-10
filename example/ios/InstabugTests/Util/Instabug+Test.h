// This header file defines Instabug methods that are called using selectors for test verification.

#import <Instabug/Instabug.h>

@interface Instabug (Test)
+ (void)setCurrentPlatform:(IBGPlatform)platform cpSDKVersion:(NSString *)cpSDKVersion;
+ (void)reportCrashWithStackTrace:(NSDictionary*)stackTrace handled:(NSNumber*)handled;
@end
