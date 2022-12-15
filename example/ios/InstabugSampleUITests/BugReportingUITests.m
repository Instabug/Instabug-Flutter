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

- (void)testFloatingButtonInvocationEvent {
    // Grabbing the "Floating Button" invocation event button
    // inside the "Change Invocation Events" section as it
    // conflicts with Instabug's floating button.
    XCUIElement *invocationEvents = [[self.app.otherElements containingPredicate:[NSPredicate predicateWithFormat:@"label == 'Change Invocation Event'"]] element];
    [invocationEvents.buttons[@"Floating Button"] forceTap];
    [self.app.buttons[@"IBGFloatingButtonAccessibilityIdentifier"] tap];

    [self assertOptionsPromptIsVisible];
}

- (void)testNoneInvocationEvent {
    [self.app.buttons[@"None"] tap];

    [self.app.buttons[@"IBGFloatingButtonAccessibilityIdentifier"] assertDoesNotExist];
}

- (void)testManualInvocation {
    [self.app.buttons[@"Invoke"] tap];

    [self assertOptionsPromptIsVisible];
}

- (void)testOnDismissCallbackIsCalled {
    [self.app.buttons[@"Set On Dismiss Callback"] scrollDownAndTap];
    [self.app.buttons[@"Invoke"] scrollUpAndTap];
    [self.app.buttons[@"Cancel"] tap];

    [self.app.staticTexts[@"onDismiss callback called with DismissType.cancel and ReportType.bug"] assertExistsWithTimeout:2];
}

- (void)testChangeReportTypes {
    [self.app.buttons[@"Bug"] scrollDownAndTap];
    [self.app.buttons[@"Feedback"] scrollDownAndTap];
    [self.app.buttons[@"Invoke"] scrollUpAndTap];

    [self assertOptionsPromptIsVisible];
    [self.app.staticTexts[@"Report a bug"] assertExistsWithTimeout:2000];
    [self.app.staticTexts[@"Suggest an improvement"] assertExistsWithTimeout:2000];
    [self.app.staticTexts[@"Ask a question"] assertDoesNotExist];
}

- (void)testChangeFloatingButtonEdge {
    // Grabbing the "Floating Button" invocation event button
    // inside the "Change Invocation Events" section as it
    // conflicts with Instabug's floating button.
    XCUIElement *invocationEvents = [[self.app.otherElements containingPredicate:[NSPredicate predicateWithFormat:@"label == 'Change Invocation Event'"]] element];
    [invocationEvents.buttons[@"Floating Button"] forceTap];
    [self.app.buttons[@"Move Floating Button to Left"] scrollDownAndTap];

    XCUIElement *floatingButton = self.app.buttons[@"IBGFloatingButtonAccessibilityIdentifier"];
    CGFloat floatingButtonLeft = floatingButton.frame.origin.x;
    CGFloat screenMiddle = self.app.frame.size.width / 2.0f;
    XCTAssertLessThan(floatingButtonLeft, screenMiddle, @"Floating button isn't to the left of the screen");
}

- (void)assertOptionsPromptIsVisible {
    [self.app.cells[@"IBGReportBugPromptOptionAccessibilityIdentifier"] assertExistsWithTimeout:2];
}

@end
