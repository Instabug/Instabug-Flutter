//
//  IBGTimeIntervalUnits.h
//  InstabugUtilities
//
//  Created by Yousef Hamza on 6/4/20.
//  Copyright © 2020 Moataz. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef double IBGMicroSecondsTimeInterval NS_SWIFT_NAME(MicroSecondsTimeInterval);
typedef double IBGMilliSecondsTimeInterval NS_SWIFT_NAME(MilliSecondsTimeInterval);
typedef double IBGMinutesTimeInterval NS_SWIFT_NAME(MinutesTimeInterval);

/// Convert from milli timestamp to micro timestamp
/// - Parameter timeInterval: micro timestamp
IBGMicroSecondsTimeInterval ibg_microSecondsIntervalFromTimeEpoch(NSTimeInterval timeInterval);
IBGMicroSecondsTimeInterval ibg_microSecondsIntervalFromTimeInterval(NSTimeInterval timeInterval);
IBGMilliSecondsTimeInterval ibg_milliSecondsIntervalFromTimeInterval(NSTimeInterval timeInterval);
IBGMinutesTimeInterval ibg_minutesIntervalFromTimeInterval(NSTimeInterval timeInterval);

NSTimeInterval ibg_timeIntervalFromMicroSecondsInterval(IBGMicroSecondsTimeInterval timeInterval);
NSTimeInterval ibg_timeIntervalFromMilliSecondsInterval(IBGMilliSecondsTimeInterval timeInterval);
NSTimeInterval ibg_timeIntervalFromMinutesInterval(IBGMinutesTimeInterval timeInterval);
