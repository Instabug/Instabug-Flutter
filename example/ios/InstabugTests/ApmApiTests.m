#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "ApmApi.h"
#import "Instabug/IBGAPM.h"
#import "Instabug/Instabug.h"

@interface ApmApiTests : XCTestCase

@property (nonatomic, strong) id mAPM;
@property (nonatomic, strong) ApmApi *api;

@end

@implementation ApmApiTests

- (void)setUp {
    self.mAPM = OCMClassMock([IBGAPM class]);
    self.api = [[ApmApi alloc] init];
}

- (IBGExecutionTrace *)mockTraceWithId:(NSString *)traceId {
    NSString* name = @"trace-name";
    IBGExecutionTrace *mTrace = OCMClassMock([IBGExecutionTrace class]);

    OCMStub([self.mAPM startExecutionTraceWithName:name]).andReturn(mTrace);

    [self.api startExecutionTraceId:traceId name:name completion:^(NSString * _Nullable _, FlutterError * _Nullable __) {}];

    return mTrace;
}

- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setEnabled:YES]);
}

- (void)testSetColdAppLaunchEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setColdAppLaunchEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setColdAppLaunchEnabled:YES]);
}

- (void)testSetAutoUITraceEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setAutoUITraceEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setAutoUITraceEnabled:YES]);
}

- (void)testStartExecutionTraceWhenTraceNotNil {
    NSString *expectedId = @"trace-id";
    NSString *name = @"trace-name";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    IBGExecutionTrace *mTrace = OCMClassMock([IBGExecutionTrace class]);
    OCMStub([self.mAPM startExecutionTraceWithName:name]).andReturn(mTrace);

    [self.api startExecutionTraceId:expectedId name:name completion:^(NSString *actualId, FlutterError *error) {
        [expectation fulfill];
        XCTAssertEqual(actualId, expectedId);
        XCTAssertNil(error);
    }];

    OCMVerify([self.mAPM startExecutionTraceWithName:name]);
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testStartExecutionTraceWhenTraceIsNil {
    NSString *traceId = @"trace-id";
    NSString *name = @"trace-name";
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    OCMStub([self.mAPM startExecutionTraceWithName:name]).andReturn(nil);

    [self.api startExecutionTraceId:traceId name:name completion:^(NSString *actualId, FlutterError *error) {
        [expectation fulfill];
        XCTAssertNil(actualId);
        XCTAssertNil(error);
    }];

    OCMVerify([self.mAPM startExecutionTraceWithName:name]);
    [self waitForExpectations:@[expectation] timeout:5.0];
}


- (void)testSetExecutionTraceAttribute {
    NSString *traceId = @"trace-id";
    NSString *key = @"is_premium";
    NSString *value = @"true";
    FlutterError *error;
    id mTrace = [self mockTraceWithId:traceId];

    [self.api setExecutionTraceAttributeId:traceId key:key value:value error:&error];

    OCMVerify([mTrace setAttributeWithKey:key value:value]);
}

- (void)testEndExecutionTrace {
    NSString *traceId = @"trace-id";
    FlutterError *error;
    IBGExecutionTrace *mTrace = [self mockTraceWithId:traceId];

    [self.api endExecutionTraceId:traceId error:&error];

    OCMVerify([mTrace end]);
}

- (void)testStartUITrace {
    NSString *name = @"login";
    FlutterError *error;

    [self.api startUITraceName:name error:&error];

    OCMVerify([self.mAPM startUITraceWithName:name]);
}

- (void)testEndUITrace {
    FlutterError *error;

    [self.api endUITraceWithError:&error];

    OCMVerify([self.mAPM endUITrace]);
}

- (void)testEndAppLaunch {
    FlutterError *error;

    [self.api endAppLaunchWithError:&error];

    OCMVerify([self.mAPM endAppLaunch]);
}

@end
