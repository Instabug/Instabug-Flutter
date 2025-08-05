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

- (void)testIsScreenRenderEnabled {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    BOOL isScreenRenderEnabled = YES;
    OCMStub([self.mAPM isScreenRenderingOperational]).andReturn(isScreenRenderEnabled);

    [self.api isScreenRenderEnabledWithCompletion:^(NSNumber *isEnabledNumber, FlutterError *error) {
        [expectation fulfill];
        
        XCTAssertEqualObjects(isEnabledNumber, @(isScreenRenderEnabled));
        XCTAssertNil(error);
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testIsScreenRenderEnabledWhenDisabled {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    BOOL isScreenRenderEnabled = NO;
    OCMStub([self.mAPM isScreenRenderingOperational]).andReturn(isScreenRenderEnabled);

    [self.api isScreenRenderEnabledWithCompletion:^(NSNumber *isEnabledNumber, FlutterError *error) {
        [expectation fulfill];
        
        XCTAssertEqualObjects(isEnabledNumber, @(isScreenRenderEnabled));
        XCTAssertNil(error);
    }];

    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testSetScreenRenderEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setScreenRenderEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setScreenRenderingEnabled:YES]);
}

- (void)testSetScreenRenderDisabled {
    NSNumber *isEnabled = @0;
    FlutterError *error;

    [self.api setScreenRenderEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mAPM setScreenRenderingEnabled:NO]);
}

- (void)testGetDeviceRefreshRateAndTolerance {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];
    
    // Mock values
    double expectedTolerance = 5.0;
    double expectedRefreshRate = 60.0;
    
    // Mock the tolerance value
    OCMStub([self.mAPM screenRenderingThreshold]).andReturn(expectedTolerance);
    
    // Mock UIScreen class methods
    id mockUIScreen = OCMClassMock([UIScreen class]);
    id mockMainScreen = OCMClassMock([UIScreen class]);
    
    // Stub the class method and instance property
    OCMStub([mockUIScreen mainScreen]).andReturn(mockMainScreen);
    OCMStub([mockMainScreen maximumFramesPerSecond]).andReturn(expectedRefreshRate);
    
    [self.api getDeviceRefreshRateAndToleranceWithCompletion:^(NSArray<NSNumber *> *result, FlutterError *error) {
        [expectation fulfill];
        
        XCTAssertNotNil(result);
        XCTAssertEqual(result.count, 2);
        XCTAssertEqualObjects(result[0], @(expectedRefreshRate));
        XCTAssertEqualObjects(result[1], @(expectedTolerance));
        XCTAssertNil(error);
    }];
    
    [self waitForExpectations:@[expectation] timeout:5.0];
    
    [mockUIScreen stopMocking];
    [mockMainScreen stopMocking];
}


- (void)testEndScreenRenderForAutoUiTrace {
    FlutterError *error;
    
    // Create mock frame data
    NSDictionary *frameData = @{
        @"frameData": @[
            @[@(1000.0), @(16.67)],  // Frame 1: start time 1000.0µs, duration 16.67µs
            @[@(1016.67), @(33.33)], // Frame 2: start time 1016.67µs, duration 33.33µs
            @[@(1050.0), @(50.0)]    // Frame 3: start time 1050.0µs, duration 50.0µs
        ]
    };
    
    [self.api endScreenRenderForAutoUiTraceData:frameData error:&error];
    
    // Verify that endAutoUITraceCPWithFrames was called
    OCMVerify([self.mAPM endAutoUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        // Verify that we have the correct number of frames
        XCTAssertEqual(frames.count, 3);
        
        // Verify the first frame
        IBGFrameInfo *firstFrame = frames[0];
        XCTAssertEqual(firstFrame.startTimestampInMicroseconds, 1000.0);
        XCTAssertEqual(firstFrame.durationInMicroseconds, 16.67);
        
        // Verify the second frame
        IBGFrameInfo *secondFrame = frames[1];
        XCTAssertEqual(secondFrame.startTimestampInMicroseconds, 1016.67);
        XCTAssertEqual(secondFrame.durationInMicroseconds, 33.33);
        
        // Verify the third frame
        IBGFrameInfo *thirdFrame = frames[2];
        XCTAssertEqual(thirdFrame.startTimestampInMicroseconds, 1050.0);
        XCTAssertEqual(thirdFrame.durationInMicroseconds, 50.0);
        
        return YES;
    }]]);
}

- (void)testEndScreenRenderForCustomUiTrace {
    FlutterError *error;
    
    // Create mock frame data
    NSDictionary *frameData = @{
        @"frameData": @[
            @[@(2000.0), @(20.0)],   // Frame 1: start time 2000.0µs, duration 20.0µs
            @[@(2020.0), @(25.0)]    // Frame 2: start time 2020.0µs, duration 25.0µs
        ]
    };
    
    [self.api endScreenRenderForCustomUiTraceData:frameData error:&error];
    
    // Verify that endCustomUITraceCPWithFrames was called
    OCMVerify([self.mAPM endCustomUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        // Verify that we have the correct number of frames
        XCTAssertEqual(frames.count, 2);
        
        // Verify the first frame
        IBGFrameInfo *firstFrame = frames[0];
        XCTAssertEqual(firstFrame.startTimestampInMicroseconds, 2000.0);
        XCTAssertEqual(firstFrame.durationInMicroseconds, 20.0);
        
        // Verify the second frame
        IBGFrameInfo *secondFrame = frames[1];
        XCTAssertEqual(secondFrame.startTimestampInMicroseconds, 2020.0);
        XCTAssertEqual(secondFrame.durationInMicroseconds, 25.0);
        
        return YES;
    }]]);
}

- (void)testEndScreenRenderForAutoUiTraceWithEmptyFrameData {
    FlutterError *error;
    
    // Create empty frame data
    NSDictionary *frameData = @{
        @"frameData": @[]
    };
    
    [self.api endScreenRenderForAutoUiTraceData:frameData error:&error];
    
    // Verify that endAutoUITraceCPWithFrames was called with empty array
    OCMVerify([self.mAPM endAutoUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        XCTAssertEqual(frames.count, 0);
        return YES;
    }]]);
}

- (void)testEndScreenRenderForCustomUiTraceWithEmptyFrameData {
    FlutterError *error;
    
    // Create empty frame data
    NSDictionary *frameData = @{
        @"frameData": @[]
    };
    
    [self.api endScreenRenderForCustomUiTraceData:frameData error:&error];
    
    // Verify that endCustomUITraceCPWithFrames was called with empty array
    OCMVerify([self.mAPM endCustomUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        XCTAssertEqual(frames.count, 0);
        return YES;
    }]]);
}

- (void)testEndScreenRenderForAutoUiTraceWithMalformedFrameData {
    FlutterError *error;
    
    // Create malformed frame data (missing values or extra values)
    NSDictionary *frameData = @{
        @"frameData": @[
            @[@(1000.0)],            // Frame with only one value (should be ignored)
            @[@(1016.67), @(33.33)], // Valid frame
            @[@(1050.0), @(50.0), @(100.0)] // Frame with extra values (should be ignored)
        ]
    };
    
    [self.api endScreenRenderForAutoUiTraceData:frameData error:&error];
    
    // Verify that endAutoUITraceCPWithFrames was called with only valid frames
    OCMVerify([self.mAPM endAutoUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        // Should only have 1 valid frame (first and third frames are ignored due to wrong count)
        XCTAssertEqual(frames.count, 1);
        
        // Verify the valid frame
        IBGFrameInfo *frame = frames[0];
        XCTAssertEqual(frame.startTimestampInMicroseconds, 1016.67);
        XCTAssertEqual(frame.durationInMicroseconds, 33.33);
        
        return YES;
    }]]);
}

- (void)testEndScreenRenderForCustomUiTraceWithMalformedFrameData {
    FlutterError *error;
    
    // Create malformed frame data (missing values)
    NSDictionary *frameData = @{
        @"frameData": @[
            @[@(2000.0)],            // Frame with only one value (should be ignored)
            @[@(2020.0), @(25.0)]    // Valid frame
        ]
    };
    
    [self.api endScreenRenderForCustomUiTraceData:frameData error:&error];
    
    // Verify that endCustomUITraceCPWithFrames was called with only valid frames
    OCMVerify([self.mAPM endCustomUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        // Should only have 1 valid frame
        XCTAssertEqual(frames.count, 1);
        
        // Verify the valid frame
        IBGFrameInfo *frame = frames[0];
        XCTAssertEqual(frame.startTimestampInMicroseconds, 2020.0);
        XCTAssertEqual(frame.durationInMicroseconds, 25.0);
        
        return YES;
    }]]);
}

- (void)testEndScreenRenderForAutoUiTraceWithNilFrameData {
    FlutterError *error;
    
    // Create frame data with nil frameData
    NSDictionary *frameData = @{
        @"frameData": [NSNull null]
    };
    
    [self.api endScreenRenderForAutoUiTraceData:frameData error:&error];
    
    // Verify that endAutoUITraceCPWithFrames was called with empty array
    OCMVerify([self.mAPM endAutoUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        XCTAssertEqual(frames.count, 0);
        return YES;
    }]]);
}

- (void)testEndScreenRenderForCustomUiTraceWithNilFrameData {
    FlutterError *error;
    
    // Create frame data with nil frameData
    NSDictionary *frameData = @{
        @"frameData": [NSNull null]
    };
    
    [self.api endScreenRenderForCustomUiTraceData:frameData error:&error];
    
    // Verify that endCustomUITraceCPWithFrames was called with empty array
    OCMVerify([self.mAPM endCustomUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        XCTAssertEqual(frames.count, 0);
        return YES;
    }]]);
}

- (void)testEndScreenRenderForAutoUiTraceWithMissingFrameDataKey {
    FlutterError *error;
    
    // Create frame data without frameData key
    NSDictionary *frameData = @{
        @"otherKey": @"someValue"
    };
    
    [self.api endScreenRenderForAutoUiTraceData:frameData error:&error];
    
    // Verify that endAutoUITraceCPWithFrames was called with empty array
    OCMVerify([self.mAPM endAutoUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        XCTAssertEqual(frames.count, 0);
        return YES;
    }]]);
}

- (void)testEndScreenRenderForCustomUiTraceWithMissingFrameDataKey {
    FlutterError *error;
    
    // Create frame data without frameData key
    NSDictionary *frameData = @{
        @"otherKey": @"someValue"
    };
    
    [self.api endScreenRenderForCustomUiTraceData:frameData error:&error];
    
    // Verify that endCustomUITraceCPWithFrames was called with empty array
    OCMVerify([self.mAPM endCustomUITraceCPWithFrames:[OCMArg checkWithBlock:^BOOL(NSArray<IBGFrameInfo *> *frames) {
        XCTAssertEqual(frames.count, 0);
        return YES;
    }]]);
}

@end
