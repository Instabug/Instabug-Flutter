//
//  InstabugSampleTests.m
//  InstabugSampleTests
//
//  Created by Ali Abdelfattah on 2/14/21.
//

#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "InstabugFlutterPlugin.h"

@interface InstabugSampleTests : XCTestCase

@end

@implementation InstabugSampleTests

static const NSTimeInterval kTimeout = 30.0;

 - (void)testShowWelcomeMessageWithMode {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *arguments = [NSArray arrayWithObjects:@"WelcomeMessageMode.live", nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"showWelcomeMessageWithMode:" arguments:arguments];
     [[[mock stub] classMethod] showWelcomeMessageWithMode:@"WelcomeMessageMode.live"];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] showWelcomeMessageWithMode:@"WelcomeMessageMode.live"];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testIdentifyUserWithEmail {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *arguments = [NSArray arrayWithObjects:@"test@test.com", @"name", nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"identifyUserWithEmail:name:" arguments:arguments];
     [[[mock stub] classMethod] identifyUserWithEmail:@"test@test.com"name:@"name"];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] identifyUserWithEmail:@"test@test.com"name:@"name"];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testLogOut {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"logOut" arguments:NULL];
     [[[mock stub] classMethod] logOut];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] logOut];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testAppendTags {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *tags = [NSArray arrayWithObjects:@"tag1", @"tag2", nil];
     NSArray *arguments = [NSArray arrayWithObjects: tags, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"appendTags:" arguments:arguments];
     [[[mock stub] classMethod] appendTags:tags];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] appendTags:tags];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

- (void)testAddExperiments {
    id mock = OCMClassMock([InstabugFlutterPlugin class]);
    InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
    
    NSArray *experiments = [NSArray arrayWithObjects:@"exp1", @"exp2", nil];
    NSArray *arguments = [NSArray arrayWithObjects: experiments, nil];
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"addExperiments:" arguments:arguments];
    [[[mock stub] classMethod] addExperiments:experiments];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
    [instabug  handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

    [[[mock verify] classMethod] addExperiments:experiments];
    [self waitForExpectationsWithTimeout:kTimeout handler:nil];
}

- (void)testRemoveExperiments {
    id mock = OCMClassMock([InstabugFlutterPlugin class]);
    InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
    
    NSArray *experiments = [NSArray arrayWithObjects:@"exp1", @"exp2", nil];
    NSArray *arguments = [NSArray arrayWithObjects: experiments, nil];
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"removeExperiments:" arguments:arguments];
    [[[mock stub] classMethod] removeExperiments:experiments];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
    [instabug  handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

    [[[mock verify] classMethod] removeExperiments:experiments];
    [self waitForExpectationsWithTimeout:kTimeout handler:nil];
}

- (void)testClearAllExperiments {
    id mock = OCMClassMock([InstabugFlutterPlugin class]);
    InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
    
    FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"clearAllExperiments" arguments:NULL];
    [[[mock stub] classMethod] clearAllExperiments];

    XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
    [instabug  handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

    [[[mock verify] classMethod] clearAllExperiments];
    [self waitForExpectationsWithTimeout:kTimeout handler:nil];
}

 - (void)testShowBugReportingWithReportTypeAndOptions {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *options = [NSArray arrayWithObjects:@"commentFieldRequired", @"disablePostSendingDialog", nil];
     NSArray *arguments = [NSArray arrayWithObjects:@"bug", options, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"showBugReportingWithReportTypeAndOptions:options:" arguments:arguments];
     [[[mock stub] classMethod] showBugReportingWithReportTypeAndOptions:@"bug"options:options];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] showBugReportingWithReportTypeAndOptions:@"bug"options:options];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testSetSessionProfilerEnabled {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *arguments = [NSArray arrayWithObjects:@(1), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setSessionProfilerEnabled:" arguments:arguments];
     [[[mock stub] classMethod] setSessionProfilerEnabled:@(1)];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] setSessionProfilerEnabled:@(1)];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testSetPrimaryColor {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *arguments = [NSArray arrayWithObjects:@(1123123123121), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setPrimaryColor:" arguments:arguments];
     [[[mock stub] classMethod] setPrimaryColor:@(1123123123121)];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] setPrimaryColor:@(1123123123121)];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testSetFloatingButtonEdge {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];
     
     NSArray *arguments = [NSArray arrayWithObjects:@"FloatingButtonEdge.left", @(300), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setFloatingButtonEdge:withTopOffset:" arguments:arguments];
     [[[mock stub] classMethod] setFloatingButtonEdge:@"FloatingButtonEdge.left"withTopOffset:@(300)];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] setFloatingButtonEdge:@"FloatingButtonEdge.left"withTopOffset:@(300)];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testAddFileAttachmentWithData {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     FlutterStandardTypedData *data;
     NSArray *arguments = [NSArray arrayWithObjects:data, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"addFileAttachmentWithData:" arguments:arguments];
     [[[mock stub] classMethod] addFileAttachmentWithData:data];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] addFileAttachmentWithData:data];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testSetEnabledAttachmentTypes {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *arguments = [NSArray arrayWithObjects:@(1),@(1),@(1),@(1), nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setEnabledAttachmentTypes:extraScreenShot:galleryImage:screenRecording:" arguments:arguments];
     [[[mock stub] classMethod] setEnabledAttachmentTypes:@(1) extraScreenShot:@(1) galleryImage:@(1) screenRecording:@(1) ];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] setEnabledAttachmentTypes:@(1) extraScreenShot:@(1) galleryImage:@(1) screenRecording:@(1)];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }

 - (void)testSetEmailFieldRequiredForFeatureRequests {
     id mock = OCMClassMock([InstabugFlutterPlugin class]);
     InstabugFlutterPlugin *instabug = [[InstabugFlutterPlugin alloc] init];

     NSArray *actions = [NSArray arrayWithObjects:@"reportBug", @"requestNewFeature", nil];
     NSArray *arguments = [NSArray arrayWithObjects:@(1), actions, nil];
     FlutterMethodCall *call = [FlutterMethodCall methodCallWithMethodName:@"setEmailFieldRequiredForFeatureRequests:forAction:" arguments:arguments];
     [[[mock stub] classMethod] setEmailFieldRequiredForFeatureRequests:@(1) forAction:actions];

     XCTestExpectation *expectation = [self expectationWithDescription:@"Result is called"];
     [instabug handleMethodCall:call result:^(id _Nullable result) {
         XCTAssertNil(result);
         [expectation fulfill];
     }];

     [[[mock verify] classMethod] setEmailFieldRequiredForFeatureRequests:@(1) forAction:actions];
     [self waitForExpectationsWithTimeout:kTimeout handler:nil];
 }


@end
