#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "InstabugLogApi.h"
#import "InstabugSDK/IBGLog.h"

@interface InstabugLogApiTests : XCTestCase

@property (nonatomic, strong) id mInstabugLog;
@property (nonatomic, strong) InstabugLogApi *api;

@end

@implementation InstabugLogApiTests

- (void)setUp {
    self.mInstabugLog = OCMClassMock([IBGLog class]);
    self.api = [[InstabugLogApi alloc] init];
}

- (void)testLogVerbose {
    NSString *message = @"created an account";
    FlutterError *error;

    [self.api logVerboseMessage:message error:&error];

    OCMVerify([self.mInstabugLog logVerbose:message]);
}

- (void)testLogDebug {
    NSString *message = @"created an account";
    FlutterError *error;

    [self.api logDebugMessage:message error:&error];

    OCMVerify([self.mInstabugLog logDebug:message]);
}

- (void)testLogInfo {
    NSString *message = @"created an account";
    FlutterError *error;

    [self.api logInfoMessage:message error:&error];

    OCMVerify([self.mInstabugLog logInfo:message]);
}

- (void)testLogWarn {
    NSString *message = @"created an account";
    FlutterError *error;

    [self.api logWarnMessage:message error:&error];

    OCMVerify([self.mInstabugLog logWarn:message]);
}

- (void)testLogError {
    NSString *message = @"something went wrong";
    FlutterError *error;

    [self.api logErrorMessage:message error:&error];

    OCMVerify([self.mInstabugLog logError:message]);
}

- (void)testClearAllLogs {
    FlutterError *error;

    [self.api clearAllLogsWithError:&error];

    OCMVerify([self.mInstabugLog clearAllLogs]);
}

@end
