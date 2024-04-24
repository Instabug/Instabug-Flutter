#import <Instabug/IBGAPM.h>
#import "IBGTimeIntervalUnits.h"

@interface IBGAPM (PrivateAPIs)

@property (class, atomic, assign) BOOL networkEnabled;

+ (void)startUITraceCPWithName:(NSString *)name startTimestampMUS:(IBGMicroSecondsTimeInterval)startTimestampMUS;

+ (void)reportScreenLoadingCPWithStartTimestampMUS:(IBGMicroSecondsTimeInterval)startTimestampMUS
                                       durationMUS:(IBGMicroSecondsTimeInterval)durationMUS;

+ (void)endScreenLoadingCPWithEndTimestampMUS:(IBGMicroSecondsTimeInterval)endTimestampMUS;

@end
