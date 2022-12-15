#import "XCUIElement+Instabug.h"

@implementation XCUIElement (Instabug)

- (void)scrollDownAndTap {
    [self scrollDownAndTapWithBlock:^(XCUIApplication *app) {
        [app swipeUp];
    }];
}

- (void)scrollUpAndTap {
    [self scrollDownAndTapWithBlock:^(XCUIApplication *app) {
        [app swipeDown];
    }];
}

- (void)scrollDownAndTapWithBlock:(void (^)(XCUIApplication *app))block {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    int count = 0;
    while (!self.isHittable && count < 10) {
        block(app);
        count++;
    }

    sleep(1);
    [self tap];
}

- (void)closeKeyboard {
    [self typeText:@"\n"];
}

/// Taps on the button's coordinates without checking if it's visible.
/// This is useful as XCUITest fails to scroll to Flutter widgets even though they might be visible
/// on the screen.
- (void)forceTap {
    XCUICoordinate *coordinate = [self coordinateWithNormalizedOffset:CGVectorMake(0.0f, 0.0f)];
    [coordinate tap];
}

- (void)assertExists {
    XCTAssertTrue(self.exists, "Element described by: %@ doesn't exist, expected to exist", self.description);
}

- (void)assertDoesNotExist {
    XCTAssertFalse(self.exists, "Element described by: %@ exists, expected to not exist", self.description);
}

@end
