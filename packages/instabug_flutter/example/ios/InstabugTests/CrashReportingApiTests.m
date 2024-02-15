#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "CrashReportingApi.h"
#import "Instabug/IBGCrashReporting.h"
#import "Instabug/Instabug.h"
#import "Util/Instabug+Test.h"

@interface CrashReportingApiTests : XCTestCase

@property (nonatomic, strong) id mCrashReporting;
@property (nonatomic, strong) id mInstabug;
@property (nonatomic, strong) CrashReportingApi *api;

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

    OCMVerify([self.mInstabug reportCrashWithStackTrace:@{} handled:isHandled]);
}

@end
