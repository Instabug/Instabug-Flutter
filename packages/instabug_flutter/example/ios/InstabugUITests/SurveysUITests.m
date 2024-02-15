#import <XCTest/XCTest.h>
#import "Util/XCUIElement+Instabug.h"
#import "Util/InstabugUITestsUtils.h"

@interface SurveysUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation SurveysUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)testShowManualSurvey {
    [self.app.buttons[@"Show Manual Survey"] scrollDownAndTap];

    [self.app.otherElements[@"SurveyNavigationVC"] assertExistsWithTimeout:2];
}

@end
