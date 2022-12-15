#import <XCTest/XCTest.h>
#import "Util/XCUIElement+Instabug.h"
#import "Util/InstabugUITestsUtils.h"

@interface FeatureRequestsUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation FeatureRequestsUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)testShowFeatureRequestsScreen {
    [self.app.buttons[@"Show Feature Requests"] scrollDownAndTap];

    [self.app.staticTexts[@"Feature Requests"] assertExistsWithTimeout:2];
}

@end
