#import <XCTest/XCTest.h>
#import "Util/XCUIElement+Instabug.h"
#import "Util/InstabugUITestsUtils.h"

@interface InstabugUITests : XCTestCase

@property (nonatomic, strong) XCUIApplication *app;

@end

@implementation InstabugUITests

- (void)setUp {
    self.continueAfterFailure = NO;
    self.app = [[XCUIApplication alloc] init];
    [self.app launch];
}

- (void)testChangePrimaryColor {
    NSString *color = @"#FF0000";
    UIColor *expected = [UIColor redColor];
    XCUIElement *colorField = self.app.textFields[@"Enter primary color"];
    [colorField tap];
    [colorField typeText:color];
    [colorField closeKeyboard];
    [self.app.buttons[@"Change Primary Color"] tap];

    XCUIElement *floatingButton = self.app.buttons[@"IBGFloatingButtonAccessibilityIdentifier"];
    UIImage *image = [[floatingButton screenshot] image];
    int x = image.size.width / 2;
    int y = 5;
    UIColor *actual = [InstabugUITestsUtils getPixelColorWithImage:image x:x y:y];
    XCTAssertTrue([actual isEqual:expected]);
}

@end

