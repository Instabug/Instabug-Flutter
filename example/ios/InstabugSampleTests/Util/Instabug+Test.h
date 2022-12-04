// This header file defines Instabug methods that are called using selectors for test verification.

#import <Instabug/Instabug.h>

@interface Instabug (Test)
+ (void)setCurrentPlatform:(IBGPlatform)platform;
@end
