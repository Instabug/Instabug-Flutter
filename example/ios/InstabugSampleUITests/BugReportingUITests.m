#import <XCTest/XCTest.h>
#import "Util/XCUIElement+Instabug.h"

@interface BugReportingUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation BugReportingUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
    [self.app.buttons[@"Restart Instabug"] tap];
}

- (void)testMultipleScreenshotsInReproSteps {
    NSString *screen = @"My Screen";

    XCUIElement *screenField = self.app.textFields[@"Enter screen name"];
    [screenField tap];
    [screenField typeText:screen];
    [screenField closeKeyboard];
    [self.app.buttons[@"Report Screen Change"] tapWithNumberOfTaps:2 numberOfTouches:1];
    
    [self.app.buttons[@"Send Bug Report"] tap];
    [self.app.staticTexts[@"IBGBugVCReproStepsDisclaimerAccessibilityIdentifier"] tap];

    NSPredicate *screensPredicate = [NSPredicate predicateWithFormat:@"label == %@", screen];
    XCUIElementQuery *screensQuery = [self.app.staticTexts matchingPredicate:screensPredicate];

    XCTAssertEqual(2, screensQuery.count);
}

@end
