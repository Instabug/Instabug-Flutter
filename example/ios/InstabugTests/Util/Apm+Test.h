// This header file defines Instabug methods that are called using selectors for test verification.

#import <Instabug/IBGAPM.h>
#import <Instabug/Instabug.h>

@interface IBGAPM (Test)
+ (void)startUITraceCPWithName:(NSString *)name startTimestampMUS:(NSTimeInterval)startTimestampMUS;
+ (void)reportScreenLoadingCPWithStartTimestampMUS:(NSTimeInterval)startTimestampMUS
                                       durationMUS:(NSTimeInterval)durationMUS;
+ (void)endScreenLoadingCPWithEndTimestampMUS:(NSTimeInterval)endTimestampMUS;
@end
