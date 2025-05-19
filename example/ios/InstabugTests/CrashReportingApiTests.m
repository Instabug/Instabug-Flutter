#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "CrashReportingApi.h"
#import "InstabugSDK/IBGCrashReporting.h"
#import "InstabugSDK/InstabugSDK.h"
#import "Util/Instabug+Test.h"
#import "Util/IBGCrashReporting+CP.h"

@interface CrashReportingApiTests : XCTestCase

@property(nonatomic, strong) id mCrashReporting;
@property(nonatomic, strong) id mInstabug;
@property(nonatomic, strong) CrashReportingApi *api;

@end

@implementation CrashReportingApiTests

- (void)setUp {
    self.mInstabug = OCMClassMock([Instabug class]);
    self.mCrashReporting = OCMClassMock([IBGCrashReporting class]);
    self.api = [[CrashReportingApi alloc] init];
}

- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;
    
    [self.api setEnabledIsEnabled:isEnabled error:&error];
    
    OCMVerify([self.mCrashReporting setEnabled:YES]);
}

- (void)testSend {
    NSString *jsonCrash = @"{}";
    NSNumber *isHandled = @0;
    FlutterError *error;
    
    [self.api sendJsonCrash:jsonCrash isHandled:isHandled error:&error];
    
    OCMVerify([self.mCrashReporting cp_reportFatalCrashWithStackTrace:@{}]);
}


- (void)testSendNonFatalErrorJsonCrash {
    NSString *jsonCrash = @"{}";
    NSString *fingerPrint = @"fingerprint";
    NSDictionary *userAttributes = @{@"key": @"value",};
    NSString *ibgNonFatalLevel = @"NonFatalExceptionLevel.error";
    
    FlutterError *error;
    
    [self.api sendNonFatalErrorJsonCrash:jsonCrash
                          userAttributes:userAttributes
                             fingerprint:fingerPrint
                  nonFatalExceptionLevel:ibgNonFatalLevel
                                   error:&error];
    
    OCMVerify([self.mCrashReporting cp_reportNonFatalCrashWithStackTrace:@{}
                level:IBGNonFatalLevelError
                groupingString:fingerPrint
                userAttributes:userAttributes
              ]);
}

@end
