//
//  IBGAPM+PrivateAPIs.h
//  Instabug
//
//  Created by Yousef Hamza on 9/7/20.
//  Copyright © 2020 Moataz. All rights reserved.
//

#import <Instabug/IBGAPM.h>
#import "IBGTimeIntervalUnits.h"

@interface IBGAPM (PrivateAPIs)


@property (class, atomic, assign) BOOL networkEnabled;
/// `w3ExternalTraceIDEnabled` will be only true if APM and network are enabled
@property (class, atomic, assign) BOOL w3ExternalTraceIDEnabled;
/// `w3ExternalGeneratedHeaderEnabled` will be only true if  APM, network and w3ExternalTraceIDEnabled are true
@property (class, atomic, assign) BOOL w3ExternalGeneratedHeaderEnabled;
/// `w3CaughtHeaderEnabled` will be only true if  APM, network and w3ExternalTraceIDEnabled are true
@property (class, atomic, assign) BOOL w3CaughtHeaderEnabled;


/// `endScreenLoadingEnabled` will be only true if  APM, screenLoadingFeature.enabled and autoUITracesUserPreference are true
@property (class, atomic, assign) BOOL endScreenLoadingEnabled;

+ (void)startUITraceCPWithName:(NSString *)name startTimestampMUS:(IBGMicroSecondsTimeInterval)startTimestampMUS;

+ (void)reportScreenLoadingCPWithStartTimestampMUS:(IBGMicroSecondsTimeInterval)startTimestampMUS
                                       durationMUS:(IBGMicroSecondsTimeInterval)durationMUS;

+ (void)endScreenLoadingCPWithEndTimestampMUS:(IBGMicroSecondsTimeInterval)endTimestampMUS;

@end
