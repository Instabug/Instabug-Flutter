#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "RepliesApi.h"
#import "InstabugSDK/IBGReplies.h"

@interface RepliesApiTests : XCTestCase

@property (nonatomic, strong) id mReplies;
@property (nonatomic, strong) RepliesFlutterApi *mFlutterApi;
@property (nonatomic, strong) RepliesApi *api;

@end

@implementation RepliesApiTests

- (void)setUp {
    self.mReplies = OCMClassMock([IBGReplies class]);
    self.mFlutterApi = OCMPartialMock([[RepliesFlutterApi alloc] init]);
    self.api = [[RepliesApi alloc] initWithFlutterApi:self.mFlutterApi];
}

- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mReplies setEnabled:YES]);
}

- (void)testShow {
    FlutterError *error;

    [self.api showWithError:&error];

    OCMVerify([self.mReplies show]);
}

- (void)testSetInAppNotificationsEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setInAppNotificationsEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mReplies setInAppNotificationsEnabled:YES]);
}

- (void)testGetUnreadRepliesCount {
    NSInteger expected = 5;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];
    
    OCMStub([self.mReplies unreadRepliesCount]).andReturn(expected);

    [self.api getUnreadRepliesCountWithCompletion:^(NSNumber *actual, FlutterError *error) {
        [expectation fulfill];
        XCTAssertEqual(expected, actual.integerValue);
    }];

    OCMVerify([self.mReplies unreadRepliesCount]);
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testHasChats {
    BOOL expected = YES;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    OCMStub([self.mReplies hasChats]).andReturn(expected);

    [self.api hasChatsWithCompletion:^(NSNumber *actual, FlutterError *error) {
        [expectation fulfill];
        XCTAssertEqual(expected, actual.boolValue);
    }];

    OCMVerify([self.mReplies hasChats]);
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testBindOnNewReplyCallback {
    FlutterError *error;

    [self.api bindOnNewReplyCallbackWithError:&error];
    IBGReplies.didReceiveReplyHandler();

    OCMVerify([self.mReplies setDidReceiveReplyHandler:[OCMArg any]]);
    OCMVerify([self.mFlutterApi onNewReplyWithCompletion:[OCMArg invokeBlock]]);
}

@end
