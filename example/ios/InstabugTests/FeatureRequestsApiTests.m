#import <XCTest/XCTest.h>
#import "OCMock/OCMock.h"
#import "FeatureRequestsApi.h"
#import "InstabugSDK/IBGFeatureRequests.h"

@interface FeatureRequestsApiTests : XCTestCase

@property (nonatomic, strong) id mFeatureRequests;
@property (nonatomic, strong) FeatureRequestsApi *api;

@end

@implementation FeatureRequestsApiTests

- (void)setUp {
    self.mFeatureRequests = OCMClassMock([IBGFeatureRequests class]);
    self.api = [[FeatureRequestsApi alloc] init];
}

- (void)testShow {
    FlutterError *error;

    [self.api showWithError:&error];

    OCMVerify([self.mFeatureRequests show]);
}

- (void)testSetEmailFieldRequired {
    NSNumber *isRequired = @1;
    NSArray<NSString *> *actionTypes = @[@"ActionType.reportBug", @"ActionType.requestNewFeature"];
    FlutterError *error;
    
    [self.api setEmailFieldRequiredIsRequired:isRequired actionTypes:actionTypes error:&error];
    
    OCMVerify([self.mFeatureRequests setEmailFieldRequired:YES forAction:IBGActionReportBug | IBGActionRequestNewFeature]);
}

@end
