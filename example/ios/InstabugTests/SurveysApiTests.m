#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "SurveysApi.h"
#import "InstabugSDK/IBGSurveys.h"
#import "Util/IBGSurvey+Test.h"

@interface SurveysApiTests : XCTestCase

@property (nonatomic, strong) id mSurveys;
@property (nonatomic, strong) SurveysFlutterApi *mFlutterApi;
@property (nonatomic, strong) SurveysApi *api;

@end

@implementation SurveysApiTests

- (void)setUp {
    self.mSurveys = OCMClassMock([IBGSurveys class]);
    self.mFlutterApi = OCMPartialMock([[SurveysFlutterApi alloc] init]);
    self.api = [[SurveysApi alloc] initWithFlutterApi:self.mFlutterApi];
}

- (void)testSetEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mSurveys setEnabled:YES]);
}

- (void)testShowSurveyIfAvailable {
    FlutterError *error;

    [self.api showSurveyIfAvailableWithError:&error];

    OCMVerify([self.mSurveys showSurveyIfAvailable]);
}

- (void)testShowSurvey {
    NSString *token = @"survey-token";
    FlutterError *error;

    [self.api showSurveySurveyToken:token error:&error];

    OCMVerify([self.mSurveys showSurveyWithToken:token]);
}

- (void)testSetAutoShowingEnabled {
    NSNumber *isEnabled = @1;
    FlutterError *error;

    [self.api setAutoShowingEnabledIsEnabled:isEnabled error:&error];

    OCMVerify([self.mSurveys setAutoShowingEnabled:YES]);
}

- (void)testSetShouldShowWelcomeScreen {
    NSNumber *shouldShowWelcomeScreen = @1;
    FlutterError *error;

    [self.api setShouldShowWelcomeScreenShouldShowWelcomeScreen:shouldShowWelcomeScreen error:&error];

    OCMVerify([self.mSurveys setShouldShowWelcomeScreen:shouldShowWelcomeScreen]);
}

- (void)testHasRespondedToSurvey {
    NSString *token = @"survey-token";
    NSNumber *expected = @1;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    OCMStub([self.mSurveys hasRespondedToSurveyWithToken:token completionHandler:([OCMArg invokeBlockWithArgs:expected, nil])]);

    [self.api hasRespondedToSurveySurveyToken:token completion:^(NSNumber *actual, FlutterError *error) {
        [expectation fulfill];
        XCTAssertEqual(expected.boolValue, actual.boolValue);
    }];

    OCMVerify([self.mSurveys hasRespondedToSurveyWithToken:token completionHandler:[OCMArg any]]);
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testGetAvailableSurveys {
    NSArray<NSString *> *expected = @[@"survey1"];
    IBGSurvey *survey = [[IBGSurvey alloc] init];
    survey.title = expected[0];
    NSArray<IBGSurvey *> *surveys = @[survey];
    XCTestExpectation *expectation = [self expectationWithDescription:@"Call completion handler"];

    OCMStub([self.mSurveys availableSurveysWithCompletionHandler:([OCMArg invokeBlockWithArgs:surveys, nil])]);;

    [self.api getAvailableSurveysWithCompletion:^(NSArray<NSString *> *actual, FlutterError *error) {
        [expectation fulfill];
        XCTAssertTrue([expected isEqualToArray:actual]);
    }];

    OCMVerify([self.mSurveys availableSurveysWithCompletionHandler:[OCMArg any]]);
    [self waitForExpectations:@[expectation] timeout:5.0];
}

- (void)testBindOnShowSurveyCallback {
    FlutterError *error;

    [self.api bindOnShowSurveyCallbackWithError:&error];
    IBGSurveys.willShowSurveyHandler();

    OCMVerify([self.mSurveys setWillShowSurveyHandler:[OCMArg any]]);
    OCMVerify([self.mFlutterApi onShowSurveyWithCompletion:[OCMArg invokeBlock]]);
}

- (void)testBindOnDismissSurveyCallback {
    FlutterError *error;

    [self.api bindOnDismissSurveyCallbackWithError:&error];
    IBGSurveys.didDismissSurveyHandler();

    OCMVerify([self.mSurveys setDidDismissSurveyHandler:[OCMArg any]]);
    OCMVerify([self.mFlutterApi onDismissSurveyWithCompletion:[OCMArg invokeBlock]]);
}

@end
