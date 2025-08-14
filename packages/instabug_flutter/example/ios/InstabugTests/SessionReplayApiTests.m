#import <XCTest/XCTest.h>
#import <instabug_flutter/InstabugFlutterPlugin.h>
#import <instabug_flutter/SessionReplayApi.h>
#import "OCMock/OCMock.h"
#import "SessionReplayApi.h"
#import "InstabugSDK/IBGSessionReplay.h"

@interface SessionReplayApiTests : XCTestCase

@property (nonatomic, strong) id mSessionReplay;
@property (nonatomic, strong) SessionReplayApi *api;

@end

@implementation SessionReplayApiTests

- (void)setUp {
    self.mSessionReplay = OCMClassMock([IBGSessionReplay class]);
    self.api = [[SessionReplayApi alloc] init];
}


- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mSessionReplay setEnabled:YES]);
}

- (void)testSetInstabugLogsEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setInstabugLogsEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mSessionReplay setIBGLogsEnabled:YES]);
}

- (void)testSetNetworkLogsEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setNetworkLogsEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mSessionReplay setNetworkLogsEnabled:YES]);
}

- (void)testSetUserStepsEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setUserStepsEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mSessionReplay setUserStepsEnabled:YES]);
}

- (void)testGetSessionReplayLink {
    NSString *link = @"link";
    id result = ^(NSString * result, FlutterError * error) {
        XCTAssertEqualObjects(result, link);
    };

    OCMStub([self.mSessionReplay sessionReplayLink]).andReturn(link);
    [self.api getSessionReplayLinkWithCompletion:result];
    OCMVerify([self.mSessionReplay sessionReplayLink]);

}


@end
