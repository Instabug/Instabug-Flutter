//
//  IBGAPM+PrivateAPIs.h
//  Instabug
//
//  Created by Yousef Hamza on 9/7/20.
//  Copyright © 2020 Moataz. All rights reserved.
//

#import <InstabugSDK/IBGAPM.h>
#import "IBGTimeIntervalUnits.h"

@interface IBGAPM (PrivateAPIs)


/// `endScreenLoadingEnabled` will be only true if  APM, screenLoadingFeature.enabled and autoUITracesUserPreference are true
@property (class, atomic, assign) BOOL endScreenLoadingEnabled;

+ (void)startUITraceCPWithName:(NSString *)name startTimestampMUS:(IBGMicroSecondsTimeInterval)startTimestampMUS;

+ (void)reportScreenLoadingCPWithStartTimestampMUS:(IBGMicroSecondsTimeInterval)startTimestampMUS
                                       durationMUS:(IBGMicroSecondsTimeInterval)durationMUS;

+ (void)endScreenLoadingCPWithEndTimestampMUS:(IBGMicroSecondsTimeInterval)endTimestampMUS;

@end
