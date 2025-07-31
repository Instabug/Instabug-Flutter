#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "ApmApi.h"
#import "InstabugSDK/IBGAPM.h"
#import "InstabugSDK/InstabugSDK.h"
#import "IBGAPM+PrivateAPIs.h"

@interface ApmApiTests : XCTestCase

@property (nonatomic, strong) id mAPM;
@property (nonatomic, strong) ApmApi *api;

@end

@implementation ApmApiTests

- (void)setUp {
    self.mAPM = OCMClassMock([IBGAPM class]);
    self.api = [[ApmApi alloc] init];
}


- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setEnabled:YES]);
}

- (void)testIsEnabled {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    BOOL isEnabled = YES;
    OCMStub([self.mAPM enabled]).andReturn(isEnabled);
    [self.api isEnabledWithCompletion:^(NSNumber *isEnabledNumber, FlutterError *error) {
        [expectation fulfill];
        
        XCTAssertEqualObjects(isEnabledNumber, @(isEnabled));
        XCTAssertNil(error);
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testSetScreenLoadingEnabled {
    
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setScreenLoadingEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setScreenLoadingEnabled:YES]);
}

- (void)testIsScreenLoadingEnabled {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    BOOL isScreenLoadingMonitoringEnabled = YES;
    OCMStub([self.mAPM screenLoadingEnabled]).andReturn(isScreenLoadingMonitoringEnabled);

    [self.api isScreenLoadingEnabledWithCompletion:^(NSNumber *isEnabledNumber, FlutterError *error) {
        [expectation fulfill];
        
        XCTAssertEqualObjects(isEnabledNumber, @(isScreenLoadingMonitoringEnabled));
        
        XCTAssertNil(error);
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testIsEndScreenLoadingEnabled {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    BOOL isEndScreenLoadingEnabled = YES;
    OCMStub([self.mAPM endScreenLoadingEnabled]).andReturn(isEndScreenLoadingEnabled);

    [self.api isEndScreenLoadingEnabledWithCompletion:^(NSNumber *isEnabledNumber, FlutterError *error) {
        [expectation fulfill];
        
        XCTAssertEqualObjects(isEnabledNumber, @(isEndScreenLoadingEnabled));
        
        XCTAssertNil(error);
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
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


- (void) testStartFlow {
    NSString* appFlowName = @"app-flow-name";
    FlutterError *error;
    
    [self.api startFlowName:appFlowName error:&error];
    
    OCMVerify([self.mAPM startFlowWithName:appFlowName]);
}

- (void) testEndFlow {
    NSString* appFlowName = @"app-flow-name";
    FlutterError *error;
    
    [self.api endFlowName:appFlowName error:&error];
    
    OCMVerify([self.mAPM endFlowWithName:appFlowName]);
}

- (void) testSetFlowAttribute {
    NSString* appFlowName = @"app-flow-name";
    NSString* attributeKey = @"attribute-key";
    NSString* attributeValue = @"attribute-value";
    FlutterError *error;
    
    [self.api setFlowAttributeName:appFlowName key:attributeKey value:attributeValue error:&error];
    
    OCMVerify([self.mAPM setAttributeForFlowWithName:appFlowName key:attributeKey value:attributeValue]);
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

- (void)testStartCpUiTrace {
    NSString *screenName = @"testScreen";
    NSNumber *microTimeStamp = @(123456789);
    NSNumber *traceId = @(987654321);
    
    NSTimeInterval microTimeStampMUS = [microTimeStamp doubleValue];
    FlutterError *error;

    [self.api startCpUiTraceScreenName:screenName microTimeStamp:microTimeStamp traceId:traceId error:&error];

    OCMVerify([self.mAPM startUITraceCPWithName:screenName startTimestampMUS:microTimeStampMUS]);
}

- (void)testReportScreenLoading {
    NSNumber *startTimeStampMicro = @(123456789);
    NSNumber *durationMicro = @(987654321);
    NSNumber *uiTraceId = @(135792468);
    FlutterError *error;
    
    NSTimeInterval startTimeStampMicroMUS = [startTimeStampMicro doubleValue];
    NSTimeInterval durationMUS = [durationMicro doubleValue];

    [self.api reportScreenLoadingCPStartTimeStampMicro:startTimeStampMicro durationMicro:durationMicro uiTraceId:uiTraceId error:&error];

    OCMVerify([self.mAPM reportScreenLoadingCPWithStartTimestampMUS:startTimeStampMicroMUS durationMUS:durationMUS]);
}

- (void)testEndScreenLoading {
    NSNumber *timeStampMicro = @(123456789);
    NSNumber *uiTraceId = @(987654321);
    FlutterError *error;
    
    NSTimeInterval endScreenLoadingCPWithEndTimestampMUS = [timeStampMicro doubleValue];
    [self.api endScreenLoadingCPTimeStampMicro:timeStampMicro uiTraceId:uiTraceId error:&error];

    OCMVerify([self.mAPM endScreenLoadingCPWithEndTimestampMUS:endScreenLoadingCPWithEndTimestampMUS]);
}


@end
