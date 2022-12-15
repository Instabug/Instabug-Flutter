#import "XCUIElement+Instabug.h"

@implementation XCUIElement (Instabug)

- (void)scrollAndTap {
    XCUIApplication *app = [[XCUIApplication alloc] init];
    
    while (!self.isHittable) {
        [app swipeUp];
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

@end
